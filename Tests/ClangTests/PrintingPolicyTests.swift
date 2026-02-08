import XCTest
@testable import Clang

final class PrintingPolicyTests: XCTestCase {
  func testPrettyPrintedUsesPolicy() throws {
    let source = #"""
    namespace N {
      struct S { int x; };
      S f();
    }
    """#

    let tu = try TestHelpers.makeTU(source: source,
                                   language: .cPlusPlus,
                                   args: ["-std=c++17"])

    guard let cursor = TestHelpers.firstFunction(named: "f", in: tu) else {
      return XCTFail("Failed to find function cursor")
    }

    let defaultPrinted = cursor.prettyPrinted()
    XCTAssertFalse(defaultPrinted.isEmpty)

    let policy = cursor.printingPolicy
    policy.set(.fullyQualifiedName, value: 1)
    let qualifiedPrinted = cursor.prettyPrinted(using: policy)

    XCTAssertFalse(qualifiedPrinted.isEmpty)
    XCTAssertTrue(qualifiedPrinted.contains("::") || qualifiedPrinted.contains("N"))

    if let function = cursor as? FunctionDecl, let resultType = function.resultType {
      let typePrinted = resultType.prettyPrinted(using: policy)
      XCTAssertFalse(typePrinted.isEmpty)
    }
  }
}
