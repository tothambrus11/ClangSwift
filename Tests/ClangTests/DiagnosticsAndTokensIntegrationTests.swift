import XCTest
@testable import Clang

final class DiagnosticsAndTokensIntegrationTests: XCTestCase {
  func testDiagnosticFormattingRangesAndFixits() throws {
    let unit = try TranslationUnit(clangSource: "int x", language: .c)

    XCTAssertFalse(unit.diagnostics.isEmpty)

    let formatted = unit.diagnostics[0].format(options: [.sourceLocation, .column, .option])
    XCTAssertFalse(formatted.isEmpty)

    // Exercise range and fix-it paths; prefer an error with a fix-it, but don't
    // make the test overly brittle.
    let withFixit = unit.diagnostics.first { !$0.fixits.isEmpty } ?? unit.diagnostics[0]

    _ = withFixit.ranges
    if let fixit = withFixit.fixits.first {
      XCTAssertFalse(fixit.fixit.isEmpty)
    }

    XCTAssertEqual(unit.diagnostics[0].severity, .error)
  }

  func testTokenLocationRangeAndSourceLocationCursorMapping() throws {
    let unit = try TranslationUnit(
      clangSource: "int add(int a, int b) { return a + b; }",
      language: .c
    )

    let tokens = unit.tokens(in: unit.cursor.range)
    XCTAssertFalse(tokens.isEmpty)

    guard let addToken = tokens.first(where: { $0.spelling(in: unit) == "add" }) else {
      return XCTFail("Failed to find token 'add'")
    }

    let loc = addToken.location(in: unit)
    XCTAssertTrue(loc.isFromMainFile)

    let range = addToken.range(in: unit)
    XCTAssertTrue(range.start.isFromMainFile)

    let cursorAtLoc = loc.cursor(in: unit)
    XCTAssertEqual(cursorAtLoc?.description, "add")

    // Exercise File wrapper paths via SourceLocation.
    let file = loc.file
    XCTAssertFalse(file.name.isEmpty)
    let uid = file.uniqueID
    if let uid {
      // If available, it should be stable and hashable.
      XCTAssertEqual(uid, file.uniqueID)
    }
  }
}
