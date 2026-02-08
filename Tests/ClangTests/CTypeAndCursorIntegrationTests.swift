import XCTest
@testable import Clang
import cclang


final class CTypeAndCursorIntegrationTests: XCTestCase {
  func testCTypeCanonicalTypeEncodingAndLayout() throws {
    let src = #"""
    typedef int MyInt;

    struct Foo { int a; char b; };
    struct Foo globalFoo;

    int add(MyInt x, int y) { return x + y; }
    """#

    let tu = try TestHelpers.makeTU(source: src, language: .c, args: ["-Wall"])

    guard let add = TestHelpers.firstFunction(named: "add", in: tu) else {
      return XCTFail("Failed to find add")
    }

    var xParam: Cursor?
    add.visitChildren { child in
      if child.description == "x" {
        xParam = child
        return .abort
      }
      return .recurse
    }

    guard let xParam, let xType = xParam.type else {
      return XCTFail("Failed to find parameter x and its type")
    }

    XCTAssertTrue(xType.description.contains("MyInt"))
    XCTAssertTrue(xType.canonicalType.description.contains("int"))

    // Exercise CType equality operator and canonicalization.
    XCTAssertTrue(xType == xType)
    XCTAssertFalse(xType == xType.canonicalType)
    XCTAssertTrue(xType.canonicalType == xType.canonicalType)

    // Layout queries should be available for concrete types.
    XCTAssertGreaterThan(try xType.canonicalType.sizeOf(), 0)
    XCTAssertGreaterThan(try xType.canonicalType.alignOf(), 0)

    // ObjC encoding is defined for many builtin types; for int it should be non-empty.
    XCTAssertFalse(xType.canonicalType.objcEncoding.isEmpty)

    // Exercise type declaration lookup and layout on a record type.
    let fooType: CType? = TestHelpers.firstCursor(in: tu) { cursor in
      guard cursor is VarDecl, cursor.description == "globalFoo" else { return nil }
      return cursor.type
    }

    guard let fooType else {
      return XCTFail("Failed to find globalFoo type")
    }

    XCTAssertTrue(fooType.description.contains("Foo"))
    XCTAssertNotNil(fooType.declaration)
    XCTAssertGreaterThan(try fooType.sizeOf(), 0)
    XCTAssertGreaterThan(try fooType.alignOf(), 0)

    // Nullability is only meaningful for certain pointer types; this call still
    // covers the wrapper path.
    _ = fooType.nullability
  }

  func testCursorCoreRelationships() throws {
    let src = #"""
    int f(int a) { return a; }
    int g(void) { return f(1); }
    __attribute__((unused)) int v;
    """#

    let tu = try TestHelpers.makeTU(source: src, language: .c, args: ["-Wall"])

    guard let f = TestHelpers.firstFunction(named: "f", in: tu) else {
      return XCTFail("Failed to find f")
    }

    XCTAssertFalse(f.usr.isEmpty)
    XCTAssertTrue(f.displayName.contains("f"))
    XCTAssertEqual(f.language, .c)
    XCTAssertTrue(f.isDeclaration)
    XCTAssertTrue(f.isDefinition)
    XCTAssertNotNil(f.linkage)
    XCTAssertNotNil(f.storageClass)

    let call: Cursor? = TestHelpers.firstCursor(in: tu) { cursor in
      if cursor is CallExpr {
        return cursor
      }
      return nil
    }

    guard let call else {
      return XCTFail("Failed to find CallExpr")
    }

    XCTAssertTrue(call.isExpression)
    XCTAssertNotNil(call.referenced)
    XCTAssertEqual(call.referenced?.description, "f")

    let vCursor: Cursor? = TestHelpers.firstCursor(in: tu) { cursor in
      guard cursor is VarDecl, cursor.description == "v" else { return nil }
      return cursor
    }

    XCTAssertEqual(vCursor?.hasAttributes, true)
  }

  func testCxxRefQualifierIsExposed() throws {
    let src = #"""
    struct S {
      int m() &;
      int n() &&;
    };

    int S::m() & { return 1; }
    int S::n() && { return 2; }
    """#

    let tu = try TestHelpers.makeTU(source: src, language: .cPlusPlus, args: ["-std=c++17"])

    let mCursor: Cursor? = TestHelpers.firstCursor(in: tu) { cursor in
      if cursor.description == "m" { return cursor }
      return nil
    }
    let nCursor: Cursor? = TestHelpers.firstCursor(in: tu) { cursor in
      if cursor.description == "n" { return cursor }
      return nil
    }

    guard let mCursor, let nCursor else {
      return XCTFail("Failed to find m/n")
    }

    XCTAssertEqual(mCursor.type?.cxxRefQualifier, .lvalue)
    XCTAssertEqual(nCursor.type?.cxxRefQualifier, .rvalue)
  }

}
