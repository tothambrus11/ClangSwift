#!/usr/bin/env python3
"""clang_api_audit.py

Rerunnable audit to compare Clang's public clang-c C API surface (from headers)
against this repo's Swift wrapper coverage.

Primary goal for upgrades (e.g. Clang 4 -> 20): find new/changed enum members
and other public API that the Swift wrappers either:
  - do not reference at all, or
    - do not expose via typed Swift wrappers (by design or by omission).

This script is intentionally heuristic-based (fast text/regex), not a C parser.
It should be used as a checklist generator, not a proof of full correctness.

Usage:
  python3 utils/clang_api_audit.py \
    --llvm-include /usr/lib/llvm-21/include \
    --shim Sources/cclang/shim.h \
    --swift Sources/Clang \
    --out docs/clang21-api-audit-report.md
"""

from __future__ import annotations

import argparse
import os
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List, Optional, Sequence, Set, Tuple


@dataclass(frozen=True)
class CEnum:
    name: str
    members: Tuple[str, ...]
    header: str


C_COMMENT_BLOCK = re.compile(r"/\*.*?\*/", re.DOTALL)
C_COMMENT_LINE = re.compile(r"//.*?$", re.MULTILINE)


def strip_c_comments(text: str) -> str:
    text = C_COMMENT_BLOCK.sub("", text)
    text = C_COMMENT_LINE.sub("", text)
    return text


def strip_preprocessor_lines(text: str) -> str:
    lines = []
    for line in text.splitlines():
        if line.lstrip().startswith("#"):
            continue
        lines.append(line)
    return "\n".join(lines)


def find_includes_from_shim(shim_path: Path) -> List[str]:
    text = shim_path.read_text(encoding="utf-8", errors="replace")
    includes: List[str] = []
    for m in re.finditer(r"^\s*#\s*include\s*<\s*(clang-c/[^>]+)\s*>\s*$", text, re.MULTILINE):
        includes.append(m.group(1))
    return includes


def _find_matching_brace(text: str, open_index: int) -> Optional[int]:
    depth = 0
    for i in range(open_index, len(text)):
        ch = text[i]
        if ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0:
                return i
    return None


def parse_c_enums(header_path: Path) -> List[CEnum]:
    raw = header_path.read_text(encoding="utf-8", errors="replace")
    text = strip_preprocessor_lines(strip_c_comments(raw))

    enums: List[CEnum] = []
    i = 0
    while True:
        m = re.search(r"\b(enum|typedef\s+enum)\b", text[i:])
        if not m:
            break
        start = i + m.start()
        kind = m.group(1)

        # Skip forward declarations like `enum Foo;` which have no `{...}`.
        brace_open = text.find("{", start)
        semi = text.find(";", start)
        if semi != -1 and (brace_open == -1 or semi < brace_open):
            i = semi + 1
            continue
        if brace_open == -1:
            i = start + 4
            continue

        brace_close = _find_matching_brace(text, brace_open)
        if brace_close is None:
            i = brace_open + 1
            continue

        before = text[start:brace_open]
        body = text[brace_open + 1 : brace_close]
        after = text[brace_close + 1 : brace_close + 200]

        name: Optional[str] = None
        if kind == "enum":
            mname = re.search(r"\benum\s+([A-Za-z_][A-Za-z0-9_]*)\b", before)
            if mname:
                name = mname.group(1)
        else:
            # typedef enum
            # Parse the typedef name from the tokens between `}` and `;`.
            k = brace_close + 1
            semi2 = text.find(";", k)
            if semi2 != -1:
                tail = text[k:semi2]
                toks = re.findall(r"\b[A-Za-z_][A-Za-z0-9_]*\b", tail)
                if toks:
                    name = toks[-1]

        # Heuristic: skip anonymous typedef enums without a name
        if not name:
            i = brace_close + 1
            continue

        # Extract member identifiers; ignore assignments and trailing commas.
        members: List[str] = []
        for mem in body.split(","):
            token = mem.strip()
            if not token:
                continue
            # Remove any '= ...'
            token = token.split("=")[0].strip()
            # Remove attributes / macros on same line
            token = re.sub(r"\s+.*$", "", token)
            if re.match(r"^[A-Za-z_][A-Za-z0-9_]*$", token):
                members.append(token)

        # Only keep enums that look like part of libclang's public CX API.
        if not members:
            i = brace_close + 1
            continue

        enums.append(CEnum(name=name, members=tuple(members), header=str(header_path)))
        i = brace_close + 1

    return enums


def iter_files(root: Path, suffix: str) -> Iterable[Path]:
    for path in root.rglob(f"*{suffix}"):
        if path.is_file():
            yield path


def build_identifier_set(swift_root: Path) -> Set[str]:
    identifiers: Set[str] = set()

    ident_re = re.compile(r"\b[A-Za-z_][A-Za-z0-9_]*\b")

    for file_path in iter_files(swift_root, ".swift"):
        text = file_path.read_text(encoding="utf-8", errors="replace")
        identifiers.update(ident_re.findall(text))

    return identifiers


def summarize_enums(enums: Sequence[CEnum], swift_idents: Set[str]) -> List[Dict[str, object]]:
    rows: List[Dict[str, object]] = []
    # Deduplicate: some headers can define the same enum name via different forms;
    # keep the variant with the most members.
    best_by_name: Dict[str, CEnum] = {}
    for e in enums:
        current = best_by_name.get(e.name)
        if current is None or len(e.members) > len(current.members):
            best_by_name[e.name] = e

    for e in sorted(best_by_name.values(), key=lambda x: x.name.lower()):
        members = list(e.members)
        missing = [m for m in members if m not in swift_idents]
        present = len(members) - len(missing)
        rows.append(
            {
                "enum": e.name,
                "header": e.header,
                "total": len(members),
                "present": present,
                "missing": missing,
            }
        )
    return rows


def filter_interesting(rows: List[Dict[str, object]]) -> List[Dict[str, object]]:
    # Focus on enums likely to impact wrapper behavior.
    # Keep any CX* enums plus a few known ones.
    interesting: List[Dict[str, object]] = []
    for r in rows:
        name = str(r["enum"])
        if name.startswith("CX") or name in {"CXCursorKind", "CXTypeKind", "CXTokenKind"}:
            interesting.append(r)
    return interesting


def format_markdown(
    shim_path: Path,
    include_root: Path,
    included_headers: Sequence[str],
    parsed_headers: Sequence[Path],
    rows: Sequence[Dict[str, object]],
) -> str:
    def rel(p: Path) -> str:
        try:
            return str(p.relative_to(Path.cwd()))
        except Exception:
            return str(p)

    lines: List[str] = []
    lines.append("# Clang 20 API vs Swift wrapper audit")
    lines.append("")
    lines.append(f"- Shim: `{rel(shim_path)}`")
    lines.append(f"- LLVM include: `{include_root}`")
    lines.append(f"- clang-c headers included by shim: {len(included_headers)}")
    lines.append(f"- clang-c headers parsed: {len(parsed_headers)}")
    lines.append("")

    lines.append("## Enum coverage summary (heuristic)")
    lines.append("")
    lines.append(
        "For each C enum found in the shim-included headers, this checks whether each member identifier is referenced "
        "anywhere in `Sources/Clang`. Missing references usually imply missing wrapper mapping or missing OptionSet constants."
    )
    lines.append("")

    # Highlight a few key enums at top
    key_order = [
        "CXCursorKind",
        "CXTypeKind",
        "CXTokenKind",
        "CXCallingConv",
        "CXLanguageKind",
        "CXDiagnosticSeverity",
        "CXLoadDiag_Error",
        "CXTemplateArgumentKind",
        "CXVisibilityKind",
        "CX_StorageClass",
    ]

    by_name: Dict[str, Dict[str, object]] = {str(r["enum"]): r for r in rows}
    lines.append("### Key enums")
    lines.append("")
    for name in key_order:
        r = by_name.get(name)
        if not r:
            continue
        lines.append(
            f"- `{name}`: present {r['present']}/{r['total']} (missing {len(r['missing'])})"
        )
    lines.append("")

    # Full list with missing members (truncate per enum)
    lines.append("### Enums with missing members")
    lines.append("")
    any_missing = False
    for r in rows:
        missing: List[str] = list(r["missing"])  # type: ignore[assignment]
        if not missing:
            continue
        any_missing = True
        enum_name = str(r["enum"])
        lines.append(f"#### `{enum_name}`")
        lines.append("")
        lines.append(f"- Total: {r['total']}, referenced: {r['present']}, missing: {len(missing)}")
        # Avoid gigantic markdown, but allow full lists for large enums
        # like CXCursorKind so we can use the report as a checklist.
        cap = 500
        shown = missing[:cap]
        lines.append("- Missing member identifiers (not referenced in Swift):")
        lines.append("")
        for m in shown:
            lines.append(f"  - `{m}`")
        if len(missing) > cap:
            lines.append(f"  - ... and {len(missing) - cap} more")
        lines.append("")

    if not any_missing:
        lines.append("No missing members detected by this heuristic.")
        lines.append("")

    lines.append("## Notes")
    lines.append("")
    lines.append("- This is a text-based audit. It can produce false positives (e.g. an enum member is intentionally not wrapped).")
    lines.append("- Missing references in Swift are most serious for enums that are exhaustively switched over (cursor/type/token/convention).")
    lines.append("- For OptionSets, missing members are usually safe but reduce discoverability.")
    lines.append("")

    return "\n".join(lines)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--llvm-include", default="/usr/lib/llvm-21/include", help="Path containing clang-c/")
    ap.add_argument("--shim", default="Sources/cclang/shim.h", help="Path to shim.h")
    ap.add_argument("--swift", default="Sources/Clang", help="Swift wrapper root")
    ap.add_argument("--out", default="docs/clang21-api-audit-report.md", help="Output markdown path")
    args = ap.parse_args()

    include_root = Path(args.llvm_include)
    shim_path = Path(args.shim)
    swift_root = Path(args.swift)
    out_path = Path(args.out)

    if not shim_path.exists():
        raise SystemExit(f"shim not found: {shim_path}")
    if not (include_root / "clang-c").exists():
        raise SystemExit(f"clang-c headers not found under: {include_root}")
    if not swift_root.exists():
        raise SystemExit(f"swift root not found: {swift_root}")

    included = find_includes_from_shim(shim_path)
    header_paths: List[Path] = []
    for inc in included:
        p = include_root / inc
        if p.exists():
            header_paths.append(p)

    all_enums: List[CEnum] = []
    for hp in header_paths:
        all_enums.extend(parse_c_enums(hp))

    swift_idents = build_identifier_set(swift_root)

    rows = summarize_enums(all_enums, swift_idents)
    rows = filter_interesting(rows)

    out_path.parent.mkdir(parents=True, exist_ok=True)
    report = format_markdown(
        shim_path=shim_path,
        include_root=include_root,
        included_headers=included,
        parsed_headers=header_paths,
        rows=rows,
    )
    out_path.write_text(report, encoding="utf-8")

    print(f"Wrote {out_path} ({len(report)} chars)")
    # Also print a short summary to stdout
    key = {r["enum"]: r for r in rows}
    for name in ("CXCursorKind", "CXTypeKind", "CXTokenKind"):
        if name in key:
            r = key[name]
            print(f"{name}: present {r['present']}/{r['total']} missing {len(r['missing'])}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
