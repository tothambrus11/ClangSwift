import XCTest
@testable import Clang

final class ExceptionSpecificationTests: XCTestCase {
  func testExceptionSpecificationKindForCursor() throws {
    let source = #"""
    void g() noexcept {}
    int h(int x) { return x; }
    """#

    let tu = try TestHelpers.makeTU(source: source,
                                   language: .cPlusPlus,
                                   args: ["-std=c++17"])

    guard let g = TestHelpers.firstFunction(named: "g", in: tu) else {
      return XCTFail("Failed to find g")
    }
    XCTAssertEqual(g.exceptionSpecificationKind, .basicNoexcept)

    guard let h = TestHelpers.firstFunction(named: "h", in: tu) else {
      return XCTFail("Failed to find h")
    }
    XCTAssertEqual(h.exceptionSpecificationKind, ExceptionSpecificationKind.none)

    XCTAssertNil(tu.cursor.exceptionSpecificationKind)
  }
}
