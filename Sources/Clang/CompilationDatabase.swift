import cclang

/// Error codes for Compilation Database.
public enum CompilationDatabaseError {
  /// No error occurred.
  case noError

  /// Database can not be loaded.
  case canNotLoadDatabase

  internal init?(clang: CXCompilationDatabase_Error) {
    switch clang {
    case CXCompilationDatabase_NoError: self = .noError
    case CXCompilationDatabase_CanNotLoadDatabase: self = .canNotLoadDatabase
    default: return nil
    }
  }
}

/// A compilation database holds all information used to compile files in a
/// project. For each file in the database, it can be queried for the working
/// directory or the command line used for the compiler invocation.
///
/// Must be freed by `clang_CompilationDatabase_dispose`.
public final class CompilationDatabase {
  private let clang: CXCompilationDatabase

  private init(clang: CXCompilationDatabase) {
    self.clang = clang
  }

  deinit {
    clang_CompilationDatabase_dispose(clang)
  }

  /// Creates a compilation database from the database found in directory
  /// `buildDir`. For example, CMake can output a `compile_commands.json` which
  /// can be used to build the database.
  ///
  /// It must be freed by `clang_CompilationDatabase_dispose`.
  public static func fromDirectory(_ buildDir: String) throws -> CompilationDatabase {
    var errorCode = CXCompilationDatabase_Error(rawValue: 0)
    let db: CXCompilationDatabase? = buildDir.withCString { cString in
      return clang_CompilationDatabase_fromDirectory(cString, &errorCode)
    }

    if let db {
      return CompilationDatabase(clang: db)
    }

    if let error = CompilationDatabaseError(clang: errorCode) {
      throw error
    }

    // Unknown error code; preserve behavior by throwing a generic error.
    throw ClangError.failure
  }

  /// Find the compile commands used for a file. The compile commands must be
  /// freed by `clang_CompileCommands_dispose`.
  public func compileCommands(for completeFileName: String) -> CompileCommands {
    let cmds: CXCompileCommands? = completeFileName.withCString { cString in
      return clang_CompilationDatabase_getCompileCommands(clang, cString)
    }
    return CompileCommands(clang: cmds)
  }

  /// Get all the compile commands in the given compilation database.
  public func allCompileCommands() -> CompileCommands {
    return CompileCommands(clang: clang_CompilationDatabase_getAllCompileCommands(clang))
  }
}

/// Contains the results of a search in the compilation database.
///
/// When searching for the compile command for a file, the compilation db can
/// return several commands, as the file may have been compiled with different
/// options in different places of the project. This choice of compile commands
/// is wrapped in this opaque data structure. It must be freed by
/// `clang_CompileCommands_dispose`.
public final class CompileCommands {
  private let clang: CXCompileCommands?

  fileprivate init(clang: CXCompileCommands?) {
    self.clang = clang
  }

  deinit {
    if let clang {
      clang_CompileCommands_dispose(clang)
    }
  }

  /// Get the number of compile commands we have.
  public var count: Int {
    guard let clang else { return 0 }
    return Int(clang_CompileCommands_getSize(clang))
  }

  /// Get the `i`'th compile command.
  ///
  /// Note: `0 <= i < clang_CompileCommands_getSize(CXCompileCommands)`.
  public func command(at index: Int) -> CompileCommand? {
    guard let clang else { return nil }
    let cmd = clang_CompileCommands_getCommand(clang, UInt32(index))
    return CompileCommand(clang: cmd)
  }
}

/// Represents the command line invocation to compile a specific file.
public struct CompileCommand {
  fileprivate let clang: CXCompileCommand

  fileprivate init?(clang: CXCompileCommand?) {
    guard let clang else { return nil }
    self.clang = clang
  }

  /// Get the working directory where the CompileCommand was executed from.
  public var directory: String {
    return clang_CompileCommand_getDirectory(clang).asSwift()
  }

  /// Get the file name associated with the CompileCommand.
  public var filename: String {
    return clang_CompileCommand_getFilename(clang).asSwift()
  }

  /// Get the number of arguments of the CompileCommand.
  public var argumentCount: Int {
    return Int(clang_CompileCommand_getNumArgs(clang))
  }

  /// Get the argument at `index`.
  public func argument(at index: Int) -> String {
    return clang_CompileCommand_getArg(clang, UInt32(index)).asSwift()
  }
}

extension CompilationDatabaseError: Error {}
