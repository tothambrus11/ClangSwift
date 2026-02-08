import XCTest
@testable import Clang

enum TestHelpers {
  static func makeTU(source: String,
                     language: Language,
                     args: [String] = [],
                     options: TranslationUnitOptions = []) throws -> TranslationUnit {
    return try TranslationUnit(clangSource: source,
                               language: language,
                               commandLineArgs: args,
                               options: options)
  }

  static func firstFunction(named name: String, in tu: TranslationUnit) -> Cursor? {
    var found: Cursor?
    tu.visitChildren { cursor in
      if cursor is FunctionDecl, cursor.description == name {
        found = cursor
        return .abort
      }
      return .recurse
    }
    return found
  }

  static func firstCursor<T>(in tu: TranslationUnit, where predicate: (Cursor) -> T?) -> T? {
    var found: T?
    tu.visitChildren { cursor in
      if let value = predicate(cursor) {
        found = value
        return .abort
      }
      return .recurse
    }
    return found
  }
}
