import XCTest
@testable import Clang

final class DiagnosticsTests: XCTestCase {
  func testDiagnosticCount() throws {
    let src = "void main() {int a = \"\"; return 0}"
    let unit = try TranslationUnit(clangSource: src, language: .c)
    XCTAssertEqual(unit.diagnostics.count, 4)
  }
}
