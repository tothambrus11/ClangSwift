import XCTest

@testable import Clang

enum TestHelpers {
  static func makeTU(
    source: String,
    language: Language,
    args: [String] = [],
    options: TranslationUnitOptions = []
  ) throws -> TranslationUnit {
    return try TranslationUnit(
      clangSource: source,
      language: language,
      commandLineArgs: args,
      options: options)
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

  static func firstOfAKind(_ kind: Cursor.Type, named name: String, in tu: TranslationUnit)
    -> Cursor?
  {
    firstCursor(in: tu) { cursor in
      if type(of: cursor) == kind, cursor.description == name {
        return cursor
      }
      return nil
    }
  }

  static func firstFunction(named name: String, in tu: TranslationUnit) -> Cursor? {
    firstOfAKind(FunctionDecl.self, named: name, in: tu)
  }

  static func firstStruct(named name: String, in tu: TranslationUnit) -> Cursor? {
    firstOfAKind(StructDecl.self, named: name, in: tu)
  }

  static func firstUnion(named name: String, in tu: TranslationUnit) -> Cursor? {
    firstOfAKind(UnionDecl.self, named: name, in: tu)
  }

  static func firstEnum(named name: String, in tu: TranslationUnit) -> Cursor? {
    firstOfAKind(EnumDecl.self, named: name, in: tu)
  }

  static func firstNamespace(named name: String, in tu: TranslationUnit) -> Cursor? {
    firstOfAKind(Namespace.self, named: name, in: tu)
  }

  static func firstClass(named name: String, in tu: TranslationUnit) -> Cursor? {
    firstOfAKind(ClassDecl.self, named: name, in: tu)
  }

  static func firstCursorOfType<T: Cursor>(_ type: T.Type, in tu: TranslationUnit) -> Cursor? {
    firstCursor(in: tu) { cursor in
      if cursor is T {
        return cursor
      }
      return nil
    }
  }

  static func firstCursor(named: String, in tu: TranslationUnit) -> Cursor? {
    firstCursor(in: tu) { cursor in
      if cursor.description == named {
        return cursor
      }
      return nil
    }
  }
}
