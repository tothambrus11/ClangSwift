import XCTest
@testable import Clang

final class SourceLocationTests: XCTestCase {
  func testLocationInitFromLineAndColumn() throws {
    let filename = "input_tests/locations.c"
    let unit = try TranslationUnit(path: filename)
    let file = unit.getFile(for: unit.spelling)!

    let start = SourceLocation(translationUnit: unit, file: file, line: 2, column: 3)
    let end = SourceLocation(translationUnit: unit, file: file, line: 4, column: 17)
    let range = SourceRange(start: start, end: end)

    XCTAssertEqual(
      unit.tokens(in: range).map { $0.spelling(in: unit) },
      [
        "int", "a", "=", "1", ";",
        "int", "b", "=", "1", ";",
        "int", "c", "=", "a", "+", "b", ";",
      ]
    )
  }

  func testLocationInitFromOffset() throws {
    let filename = "input_tests/locations.c"
    let unit = try TranslationUnit(path: filename)
    let file = unit.getFile(for: unit.spelling)!

    let start = SourceLocation(translationUnit: unit, file: file, offset: 19)
    let end = SourceLocation(translationUnit: unit, file: file, offset: 59)
    let range = SourceRange(start: start, end: end)

    XCTAssertEqual(
      unit.tokens(in: range).map { $0.spelling(in: unit) },
      [
        "int", "a", "=", "1", ";",
        "int", "b", "=", "1", ";",
        "int", "c", "=", "a", "+", "b", ";",
      ]
    )
  }
}
