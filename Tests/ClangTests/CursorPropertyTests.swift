import XCTest
import cclang

@testable import Clang

final class CursorPropertyTests: XCTestCase {

  // MARK: - isAnonymous Tests

  func testIsAnonymous_AnonymousStruct() throws {
    let src = "struct { int x; int y; } point;"
    let tu = try TestHelpers.makeTU(source: src, language: .c)
    let cursor = try XCTUnwrap(TestHelpers.firstCursorOfType(StructDecl.self, in: tu))
    
    XCTAssertTrue(cursor.isAnonymous)
  }

  func testIsAnonymous_AnonymousUnion() throws {
    let src = "union { int i; float f; } value;"
    let tu = try TestHelpers.makeTU(source: src, language: .c)
    let cursor = try XCTUnwrap(TestHelpers.firstCursorOfType(UnionDecl.self, in: tu))
    
    XCTAssertTrue(cursor.isAnonymous)
  }

  func testIsAnonymous_AnonymousEnum() throws {
    let src = "enum { VALUE_A, VALUE_B };"
    let tu = try TestHelpers.makeTU(source: src, language: .c)
    let cursor = try XCTUnwrap(TestHelpers.firstCursorOfType(EnumDecl.self, in: tu))
    
    XCTAssertTrue(cursor.isAnonymous)
  }

  func testIsAnonymous_NamedStruct() throws {
    let src = "struct Point { int x; int y; };"
    let tu = try TestHelpers.makeTU(source: src, language: .c)
    let cursor = try XCTUnwrap(TestHelpers.firstStruct(named: "Point", in: tu))
    
    XCTAssertFalse(cursor.isAnonymous)
  }

  func testIsAnonymous_NamedUnion() throws {
    let src = "union Value { int i; float f; };"
    let tu = try TestHelpers.makeTU(source: src, language: .c)
    let cursor = try XCTUnwrap(TestHelpers.firstUnion(named: "Value", in: tu))
    
    XCTAssertFalse(cursor.isAnonymous)
  }

  func testIsAnonymous_NamedEnum() throws {
    let src = "enum Color { RED, GREEN, BLUE };"
    let tu = try TestHelpers.makeTU(source: src, language: .c)
    let cursor = try XCTUnwrap(TestHelpers.firstEnum(named: "Color", in: tu))
    
    XCTAssertFalse(cursor.isAnonymous)
  }

  func testIsAnonymous_AnonymousNamespaceInCpp() throws {
    let src = "namespace { void helperFunction() {} }"
    let tu = try TestHelpers.makeTU(source: src, language: .cPlusPlus)
    let cursor = try XCTUnwrap(TestHelpers.firstCursorOfType(Namespace.self, in: tu))
    
    XCTAssertTrue(cursor.isAnonymous)
  }

  func testIsAnonymous_NamedNamespaceInCpp() throws {
    let src = "namespace MyNamespace { void helperFunction() {} }"
    let tu = try TestHelpers.makeTU(source: src, language: .cPlusPlus)
    let cursor = try XCTUnwrap(TestHelpers.firstNamespace(named: "MyNamespace", in: tu))
    
    XCTAssertFalse(cursor.isAnonymous)
  }

  // MARK: - isAnonymousRecordDeclaration Tests

  func testIsAnonymousRecordDeclaration_AnonymousStructMember() throws {
    let src = "struct Outer { struct { int x; int y; }; };"
    let tu = try TestHelpers.makeTU(source: src, language: .c)
    
    let inner = try XCTUnwrap(TestHelpers.firstCursor(in: tu) { cursor in
      (cursor is StructDecl && cursor.isAnonymous) ? cursor : nil
    })
    
    XCTAssertTrue(inner.isAnonymousRecordDeclaration)
  }

  func testIsAnonymousRecordDeclaration_AnonymousUnionMember() throws {
    let src = "struct Outer { union { int i; float f; }; };"
    let tu = try TestHelpers.makeTU(source: src, language: .c)
    
    let inner = try XCTUnwrap(TestHelpers.firstCursor(in: tu) { cursor in
      (cursor is UnionDecl && cursor.isAnonymous) ? cursor : nil
    })
    
    XCTAssertTrue(inner.isAnonymousRecordDeclaration)
  }
  
  func testIsAnonymousRecordDeclaration_AnonymousStructWithVarName() throws {
    let src = "struct { int x; int y; } point;"
    let tu = try TestHelpers.makeTU(source: src, language: .c)
    let cursor = try XCTUnwrap(TestHelpers.firstCursorOfType(StructDecl.self, in: tu))
    
    // Anonymous but with a variable name - not an anonymous record declaration
    XCTAssertFalse(cursor.isAnonymousRecordDeclaration)
  }

  func testIsAnonymousRecordDeclaration_AnonymousUnionWithVarName() throws {
    let src = "union { int i; float f; } value;"
    let tu = try TestHelpers.makeTU(source: src, language: .c)
    let cursor = try XCTUnwrap(TestHelpers.firstCursorOfType(UnionDecl.self, in: tu))
    
    // Anonymous but with a variable name - not an anonymous record declaration
    XCTAssertFalse(cursor.isAnonymousRecordDeclaration)
  }

  func testIsAnonymousRecordDeclaration_NamedStruct() throws {
    let src = "struct Point { int x; int y; };"
    let tu = try TestHelpers.makeTU(source: src, language: .c)
    let cursor = try XCTUnwrap(TestHelpers.firstStruct(named: "Point", in: tu))
    
    XCTAssertFalse(cursor.isAnonymousRecordDeclaration)
  }

  func testIsAnonymousRecordDeclaration_NamedUnion() throws {
    let src = "union Value { int i; float f; };"
    let tu = try TestHelpers.makeTU(source: src, language: .c)
    let cursor = try XCTUnwrap(TestHelpers.firstUnion(named: "Value", in: tu))
    
    XCTAssertFalse(cursor.isAnonymousRecordDeclaration)
  }

  func testIsAnonymousRecordDeclaration_Enum() throws {
    let src = "enum { VALUE_A, VALUE_B };"
    let tu = try TestHelpers.makeTU(source: src, language: .c)
    let cursor = try XCTUnwrap(TestHelpers.firstCursorOfType(EnumDecl.self, in: tu))
    
    // Enum (even anonymous) should return false as it only applies to structs and unions
    XCTAssertFalse(cursor.isAnonymousRecordDeclaration)
  }

  func testIsAnonymousRecordDeclaration_NestedAnonymousStruct() throws {
    let src = "struct Outer { struct { int x; int y; }; };"
    let tu = try TestHelpers.makeTU(source: src, language: .c)
    let outer = try XCTUnwrap(TestHelpers.firstStruct(named: "Outer", in: tu))
    
    var anonymousStructFound = false
    outer.visitChildren { cursor in
      if cursor is StructDecl && cursor.isAnonymous {
        XCTAssertTrue(cursor.isAnonymousRecordDeclaration)
        anonymousStructFound = true
        return .abort
      }
      return .recurse
    }
    
    XCTAssertTrue(anonymousStructFound)
  }

  func testIsAnonymousRecordDeclaration_AnonymousUnionInCpp() throws {
    let src = "class MyClass { union { int i; float f; }; };"
    let tu = try TestHelpers.makeTU(source: src, language: .cPlusPlus)
    let myClass = try XCTUnwrap(TestHelpers.firstClass(named: "MyClass", in: tu))
    
    var anonymousUnionFound = false
    myClass.visitChildren { cursor in
      if cursor is UnionDecl && cursor.isAnonymous {
        XCTAssertTrue(cursor.isAnonymousRecordDeclaration)
        anonymousUnionFound = true
        return .abort
      }
      return .recurse
    }
    
    XCTAssertTrue(anonymousUnionFound)
  }

  // MARK: - Combined Tests

  func testBothProperties_AnonymousVsNamed() throws {
    let src = "struct Named { int a; }; struct Outer { struct { int b; }; };"
    let tu = try TestHelpers.makeTU(source: src, language: .c)
    
    let named = try XCTUnwrap(TestHelpers.firstStruct(named: "Named", in: tu))
    let outer = try XCTUnwrap(TestHelpers.firstStruct(named: "Outer", in: tu))
    
    // Named struct should be false for both
    XCTAssertFalse(named.isAnonymous)
    XCTAssertFalse(named.isAnonymousRecordDeclaration)
    
    // Find anonymous member struct
    var anonymousFound = false
    outer.visitChildren { cursor in
      if cursor is StructDecl && cursor.isAnonymous {
        XCTAssertTrue(cursor.isAnonymous)
        XCTAssertTrue(cursor.isAnonymousRecordDeclaration)
        anonymousFound = true
        return .abort
      }
      return .recurse
    }
    
    XCTAssertTrue(anonymousFound)
  }
}
