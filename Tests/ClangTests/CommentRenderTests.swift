import XCTest
@testable import Clang

final class CommentRenderTests: XCTestCase {
  func testInlineCommandRenderKindIsExposed() throws {
    let source = #"""
    /**
      * Brief docs with \c monospaced
     */
    int f(void) { return 0; }
    """#

    let tu = try TestHelpers.makeTU(source: source,
                                   language: .c,
                                   args: ["-fparse-all-comments"])

    guard let cursor = TestHelpers.firstFunction(named: "f", in: tu) else {
      return XCTFail("Failed to find function cursor")
    }

    guard let fullComment = cursor.fullComment else {
      return XCTFail("Expected parsed full comment")
    }

    func findInline(_ comment: Comment) -> InlineCommandComment? {
      if let inline = comment as? InlineCommandComment { return inline }
      for child in comment.children {
        if let child {
          if let found = findInline(child) { return found }
        }
      }
      return nil
    }

    guard let inline = findInline(fullComment) else {
      return XCTFail("Expected to find InlineCommandComment")
    }

    XCTAssertEqual(inline.arguments.count, 1)
    XCTAssertEqual(inline.arguments.first, "monospaced")
    XCTAssertEqual(inline.renderKind, .monospaced)

    XCTAssertFalse(fullComment.html.isEmpty)
    XCTAssertTrue(fullComment.html.contains("monospaced"))
  }
}
