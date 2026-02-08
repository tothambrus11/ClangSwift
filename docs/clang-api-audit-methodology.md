# Methodology: Clang/LLVM 21 upgrade audit for this Swift libclang wrapper

This methodology aims to make the Clang 4 → Clang 21 upgrade **correct**, **thorough**, and **repeatable**, with an explicit focus on:

- API surface changes in the *public* `clang-c` headers (enums, flags, functions)
- Wrapper coverage (Swift types and helpers) vs raw imported C API
- Identifying newly added Clang API that is not exposed in Swift

## 1) Define the C surface you claim to wrap

1. Treat the shim header as the authoritative list of public C headers you import.
   - File: `Sources/cclang/shim.h`
   - It should `#include <clang-c/...>` for every public header you expect to be available to Swift.
2. For Clang 21, note that some APIs were split out into separate headers (e.g. diagnostics, file/location).

**Correctness criterion:** every C declaration used in Swift must be reachable via the shim module.

## 2) Inventory wrapper responsibilities

Split the wrapper into two categories:

- **Typed wrappers**: Swift enums/structs/protocols intended as the “Swift API” (e.g. `CallingConvention`, `TranslationUnit`, cursor/type wrappers).
- **Raw C passthrough**: places where users are expected to use `CX*` values directly.

**Correctness criterion:** for every typed wrapper, define the mapping rule (which C enum/type it corresponds to).

## 3) Enumerations & flags: enforce wrapper coverage

For each mapped C enum (examples):

- `CXCursorKind` → cursor wrapper factory
- `CXTypeKind` → type wrapper factory
- `CXCallingConv` → `CallingConvention`
- `CXDiagnosticSeverity` → `DiagnosticSeverity`
- `CXLoadDiag_Error` → `LoadDiagError`

Perform two checks:

1. **Coverage check**: every C enum member is either:
   - mapped to a Swift case/type, or
   - explicitly handled as “unknown/unexposed”.

**Correctness criterion:** the wrapper intentionally exposes (or intentionally omits, with documentation) the Clang 21 members you care about.

## 4) Tokens: validate kind coverage and token API exposure

- Confirm `CXTokenKind` members are all handled.
- Confirm token-related APIs used by Swift are still declared from the shim headers.

**Correctness criterion:** tokenization works without runtime traps for new token kinds.

## 5) Functions & structs: reconcile header changes

For each `clang_*` function used by Swift:

- ensure it is declared in the imported headers
- confirm signature changes do not break Swift interop (pointer mutability, constness, typedef moves)

**Correctness criterion:** Swift compiles without relying on transitive includes that may change.

## 6) Automate the audit (repeatable)

Use the script:

- `utils/clang_api_audit.py`

It:

- parses enums out of the shim-included `clang-c/*.h` headers
- scans `Sources/Clang` for referenced C enum member identifiers

Note: the audit intentionally does **not** treat `fatalError(...)` as a problem. In this project, crashes can be an intentional way to surface bugs or unsupported inputs.

Run it during upgrades and commit the generated report:

- `docs/clang21-api-audit-report.md`

**Correctness criterion:** upgrade PRs include a “gap report” and either close gaps or explicitly document why not.

## 7) Close gaps with a consistent policy

Recommended policy for future-proofing:

- For cursor/type/token conversion factories: decide which new Clang 21 members you want to support, then add mappings for those members.
- For Swift enums mapping C enums: add an `.unknown(rawValue:)` or return `nil` when appropriate.
- For OptionSets: expose new flags as additional static lets when they matter for users.

## 8) Verification loop

- Run `swift test` after shim/header changes.
- Run the audit script and confirm that key enums either show full coverage or have deliberate “unknown” handling.
- Add/adjust tests for any new behavior.
