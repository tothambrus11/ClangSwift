# Clang 20 API vs Swift wrapper audit

- Shim: `Sources/cclang/shim.h`
- LLVM include: `/usr/lib/llvm-21/include`
- clang-c headers included by shim: 12
- clang-c headers parsed: 12

## Enum coverage summary (heuristic)

For each C enum found in the shim-included headers, this checks whether each member identifier is referenced anywhere in `Sources/Clang`. Missing references usually imply missing wrapper mapping or missing OptionSet constants.

### Key enums

- `CXCursorKind`: present 307/307 (missing 0)
- `CXTypeKind`: present 129/129 (missing 0)
- `CXTokenKind`: present 5/5 (missing 0)
- `CXCallingConv`: present 37/37 (missing 0)
- `CXLanguageKind`: present 4/4 (missing 0)
- `CXDiagnosticSeverity`: present 5/5 (missing 0)
- `CXLoadDiag_Error`: present 4/4 (missing 0)
- `CXTemplateArgumentKind`: present 10/10 (missing 0)
- `CXVisibilityKind`: present 4/4 (missing 0)
- `CX_StorageClass`: present 8/8 (missing 0)

### Enums with missing members

No missing members detected by this heuristic.

## Notes

- This is a text-based audit. It can produce false positives (e.g. an enum member is intentionally not wrapped).
- Missing references in Swift are most serious for enums that are exhaustively switched over (cursor/type/token/convention).
- For OptionSets, missing members are usually safe but reduce discoverability.
