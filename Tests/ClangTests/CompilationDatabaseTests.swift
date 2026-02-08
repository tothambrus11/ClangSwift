import XCTest
import Foundation
@testable import Clang

final class CompilationDatabaseTests: XCTestCase {
  func testCompilationDatabaseLoadsCommands() throws {
    let tempDir = FileManager.default.temporaryDirectory
      .appendingPathComponent("ClangSwift-compdb-\(UUID().uuidString)", isDirectory: true)

    try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
    defer { try? FileManager.default.removeItem(at: tempDir) }

    // Create a dummy source file (some tools assume it exists).
    let sourceFile = tempDir.appendingPathComponent("foo.c")
    try "int foo(void) { return 0; }\n".write(to: sourceFile, atomically: true, encoding: .utf8)

    let dbFile = tempDir.appendingPathComponent("compile_commands.json")
    let json = """
    [
      {
        \"directory\": \"\(tempDir.path)\",
        \"file\": \"foo.c\",
        \"arguments\": [\"clang\", \"-c\", \"foo.c\"]
      }
    ]
    """
    try json.write(to: dbFile, atomically: true, encoding: .utf8)

    let db = try CompilationDatabase.fromDirectory(tempDir.path)
    let cmds = db.allCompileCommands()
    XCTAssertGreaterThan(cmds.count, 0)

    let cmd = cmds.command(at: 0)
    XCTAssertNotNil(cmd)
    XCTAssertEqual(cmd?.directory, tempDir.path)
    XCTAssertTrue(cmd?.filename.hasSuffix("foo.c") ?? false)
    XCTAssertGreaterThan(cmd?.argumentCount ?? 0, 0)
  }

  func testCompilationDatabaseMissingThrows() throws {
    let tempDir = FileManager.default.temporaryDirectory
      .appendingPathComponent("ClangSwift-compdb-missing-\(UUID().uuidString)", isDirectory: true)

    try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
    defer { try? FileManager.default.removeItem(at: tempDir) }

    XCTAssertThrowsError(try CompilationDatabase.fromDirectory(tempDir.path)) { error in
      // Be tolerant: libclang should normally return CanNotLoadDatabase.
      if let e = error as? CompilationDatabaseError {
        XCTAssertEqual(e, .canNotLoadDatabase)
      }
    }
  }
}
