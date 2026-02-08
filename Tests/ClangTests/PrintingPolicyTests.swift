import XCTest
import cclang
@testable import Clang

final class PrintingPolicyTests: XCTestCase {
  func testPrintFullyQualifiedDeclaration() throws {
    let source = #"""
    namespace MyNamespace {
      namespace Nested {
        class MyClass {
        public:
          static MyClass* init();
        };
      }
    }
    """#

    let tu = try TestHelpers.makeTU(source: source,
                                   language: .cPlusPlus,
                                   args: ["--std=c++17"])

    guard let method = TestHelpers.firstCursor(in: tu, where: { cursor -> CXXMethod? in
      if let method = cursor as? CXXMethod, method.description == "init" {
        return method
      }
      return nil
    }) else {
      return XCTFail("Failed to find method cursor")
    }

    // Get the return type of the method using clang_getCursorResultType
    guard let returnType = method.resultType else {
      return XCTFail("Failed to get return type")
    }

    // Create a printing policy and enable fully qualified names
    let policy = PrintingPolicy(cursor: method)
    policy.set(.fullyQualifiedName, value: 1)

    // Note: When printing types in isolation, the fullyQualifiedName setting 
    // may not add namespace qualifiers. It works better on full declarations.
    let returnTypeName = returnType.prettyPrinted(using: policy)
    XCTAssertEqual("MyClass *", returnTypeName) // This is unfortunate, but it is what it is.
    
    let qualifiedMethod = method.prettyPrinted(using: policy)
    XCTAssertEqual("static MyClass *MyNamespace::Nested::MyClass::init()", qualifiedMethod)
  }

  func testPrintFullyQualifiedNonStaticMethod() throws {
    let source = #"""
    namespace MyNamespace {
      namespace Nested {
        class MyClass {
        public:
          MyClass* getInstance();
        };
      }
    }
    """#

    let tu = try TestHelpers.makeTU(source: source,
                                   language: .cPlusPlus,
                                   args: ["--std=c++17"])

    guard let method = TestHelpers.firstCursor(in: tu, where: { cursor -> CXXMethod? in
      if let method = cursor as? CXXMethod, method.description == "getInstance" {
        return method
      }
      return nil
    }) else {
      return XCTFail("Failed to find method cursor")
    }

    // Get the return type of the method using clang_getCursorResultType
    guard let returnType = method.resultType else {
      return XCTFail("Failed to get return type")
    }

    // Create a printing policy and enable fully qualified names
    let policy = PrintingPolicy(cursor: method)
    policy.set(.fullyQualifiedName, value: 1)

    let returnTypeName = returnType.prettyPrinted(using: policy)
    XCTAssertEqual("MyClass *", returnTypeName)
    
    let qualifiedMethod = method.prettyPrinted(using: policy)
    XCTAssertEqual("MyClass *MyNamespace::Nested::MyClass::getInstance()", qualifiedMethod)
  }

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
