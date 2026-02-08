import XCTest
@testable import Clang

final class TranslationUnitResourceUsageTests: XCTestCase {
  func testResourceUsageIsAvailable() throws {
    let tu = try TestHelpers.makeTU(source: "int main(void) { return 0; }",
                                   language: .c)

    let usage = tu.resourceUsage
    XCTAssertFalse(usage.entries.isEmpty)

    XCTAssertTrue(usage.entries.contains { $0.amount > 0 })

    if let first = usage.entries.first {
      XCTAssertFalse(first.kind.name.isEmpty)
    }
  }
}
