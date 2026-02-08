import XCTest
@testable import Clang

final class IndexingIntegrationTests: XCTestCase {
  func testIndexActionFindsFunctions() throws {
    let filename = "input_tests/index-action.c"
    let unit = try TranslationUnit(path: filename)

    let indexerCallbacks = Clang.IndexerCallbacks()
    var functionsFound = Set<String>()
    indexerCallbacks.indexDeclaration = { decl in
      if decl.cursor is FunctionDecl {
        functionsFound.insert(decl.cursor!.description)
      }
    }

    try unit.indexTranslationUnit(
      indexAction: IndexAction(),
      indexerCallbacks: indexerCallbacks,
      options: .none
    )

    XCTAssertEqual(functionsFound, Set(["main", "didLaunch"]))
  }

  func testIsFromMainFile() throws {
    let unit = try TranslationUnit(path: "input_tests/is-from-main-file.c")

    var functions = [Cursor]()
    unit.visitChildren { cursor in
      if cursor is FunctionDecl && cursor.range.start.isFromMainFile {
        functions.append(cursor)
      }
      return .recurse
    }

    XCTAssertEqual(functions.map { $0.description }, ["main"])
  }

  func testVisitInclusion() throws {
    func fileName(_ file: File) -> String {
      file.name.components(separatedBy: "/").last!
    }

    let expected = [
      ["inclusion.c"],
      ["inclusion-header.h", "inclusion.c"],
    ]

    let unit = try TranslationUnit(path: "input_tests/inclusion.c")
    var inclusion: [[String]] = []

    unit.visitInclusion { file, stack in
      let inc = [fileName(file)] + stack.map { fileName($0.file) }
      inclusion.append(inc)
    }

    XCTAssertEqual(inclusion, expected)
  }

  func testGetFile() throws {
    let fileName = "input_tests/init-ast.c"
    let unit = try TranslationUnit(path: fileName)
    XCTAssertNotNil(unit.getFile(for: fileName))
    XCTAssertNil(unit.getFile(for: "42"))
  }
}
