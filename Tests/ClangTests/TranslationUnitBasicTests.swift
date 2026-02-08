import XCTest
@testable import Clang

final class TranslationUnitBasicTests: XCTestCase {
  func testInitTranslationUnitUsingArguments() throws {
    let unit = try TranslationUnit(
      clangSource: "int main(void) {int a; return 0;}",
      language: .c,
      commandLineArgs: ["-Wall"]
    )

    XCTAssertEqual(unit.diagnostics.map { $0.description }, ["unused variable \'a\'"])
  }

  func testInitUsingStringAsSource() throws {
    let unit = try TranslationUnit(clangSource: "int main() {}", language: .c)
    let lexems = unit.tokens(in: unit.cursor.range).map { $0.spelling(in: unit) }
    XCTAssertEqual(lexems, ["int", "main", "(", ")", "{", "}"])
  }

  func testTUReparsing() throws {
    let filename = "input_tests/reparse.c"
    let index = Index()
    let unit = try TranslationUnit(path: filename, index: index)

    let src = "int add(int, int);"
    let unsavedFile = UnsavedFile(filename: filename, contents: src)

    try unit.reparseTransaltionUnit(using: [unsavedFile], options: unit.defaultReparseOptions)

    XCTAssertEqual(
      unit.tokens(in: unit.cursor.range).map { $0.spelling(in: unit) },
      ["int", "add", "(", "int", ",", "int", ")", ";"]
    )
  }

  func testInitFromASTFile() throws {
    let filename = "input_tests/init-ast.c"
    let astFilename = "/tmp/ClangSwift-init-ast-\(UUID().uuidString).ast"

    let unit = try TranslationUnit(path: filename)
    try unit.saveTranslationUnit(in: astFilename, withOptions: unit.defaultSaveOptions)
    defer { try? FileManager.default.removeItem(atPath: astFilename) }

    let unit2 = try TranslationUnit(astFilename: astFilename)
    XCTAssertEqual(
      unit2.tokens(in: unit2.cursor.range).map { $0.spelling(in: unit2) },
      ["int", "main", "(", "void", ")", "{", "return", "0", ";", "}"]
    )
  }

  func testParsingWithUnsavedFile() throws {
    let filename = "input_tests/unsaved-file.c"
    let src = "int main(void) { return 0; }"
    let unsavedFile = UnsavedFile(filename: filename, contents: src)
    let unit = try TranslationUnit(path: filename, unsavedFiles: [unsavedFile])

    XCTAssertEqual(
      unit.tokens(in: unit.cursor.range).map { $0.spelling(in: unit) },
      ["int", "main", "(", "void", ")", "{", "return", "0", ";", "}"]
    )
  }

  func testDisposeTranslateUnit() throws {
    let filename = "input_tests/init-ast.c"
    let unit = try TranslationUnit(path: filename)
    let cursor = unit.cursor
    for _ in 0..<2 {
      _ = cursor.translationUnit
    }
  }
}
