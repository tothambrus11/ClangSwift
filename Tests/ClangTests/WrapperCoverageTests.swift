import XCTest
import cclang
@testable import Clang

final class WrapperCoverageTests: XCTestCase {
  func testLanguageAndChoiceMappings() {
    XCTAssertEqual(Language(clang: CXLanguage_C), .c)
    XCTAssertEqual(Language(clang: CXLanguage_ObjC), .objectiveC)
    XCTAssertEqual(Language(clang: CXLanguage_CPlusPlus), .cPlusPlus)
    XCTAssertNil(Language(clang: CXLanguage_Invalid))

    XCTAssertEqual(Choice(clang: CXChoice_Default), .default)
    XCTAssertEqual(Choice(clang: CXChoice_Enabled), .enabled)
    XCTAssertEqual(Choice(clang: CXChoice_Disabled), .disabled)

    XCTAssertEqual(Choice.enabled.asClang, CXChoice_Enabled)
  }

  func testCIndexResultAndCallingConventionMappings() {
    XCTAssertEqual(CIndexResult(clang: CXResult_Success), .success)
    XCTAssertEqual(CIndexResult(clang: CXResult_Invalid), .invalid)
    XCTAssertEqual(CIndexResult(clang: CXResult_VisitBreak), .visitBreak)

    XCTAssertEqual(CallingConvention(clang: CXCallingConv_C), .c)
    XCTAssertEqual(CallingConvention(clang: CXCallingConv_Default), .default)
    XCTAssertNil(CallingConvention(clang: CXCallingConv_Invalid))
  }

  func testCodeCompletionEnumMappings() {
    XCTAssertEqual(CompletionChunkKind(clang: CXCompletionChunk_Text), .text)
    XCTAssertEqual(CompletionChunkKind(clang: CXCompletionChunk_TypedText), .typedText)
    XCTAssertEqual(CompletionChunkKind(clang: CXCompletionChunk_LeftParen), .leftParen)

    XCTAssertEqual(CodeCompleteFlags.includeMacros.rawValue, CXCodeComplete_IncludeMacros.rawValue)
    XCTAssertTrue(CompletionContext.dotMemberAccess.rawValue != 0)
  }

  func testIndexingEnumMappings() {
    XCTAssertEqual(IdxEntityKind(clang: CXIdxEntity_Function), .function)
    XCTAssertEqual(IdxEntityLanguage(clang: CXIdxEntityLang_C), .c)
    XCTAssertEqual(IdxEntityCXXTemplateKind(clang: CXIdxEntity_Template), .template)
    XCTAssertEqual(IdxAttrKind(clang: CXIdxAttr_IBAction), .ibAction)
    XCTAssertEqual(IdxEntityRefKind(clang: CXIdxEntityRef_Implicit), .implicit)

    XCTAssertTrue(IdxDeclInfoFlags.skipped.rawValue != 0)
  }

  func testNameRefOptionsAndSymbolRoleOptionSets() {
    let opts: NameRefOptions = [.wantQualifier, .wantTemplateArgs]
    XCTAssertTrue(opts.contains(.wantQualifier))
    XCTAssertTrue(opts.contains(.wantTemplateArgs))

    let role: SymbolRole = [.declaration, .reference]
    XCTAssertTrue(role.contains(.declaration))
    XCTAssertTrue(role.contains(.reference))
  }

  func testAvailabilityAndEvalResult() throws {
    let src = #"""
    __attribute__((deprecated("use g"))) void f(void);
    void f(void) {}

    enum { X = 42 };
    """#

    let tu = try TestHelpers.makeTU(source: src, language: .c, args: ["-Wall"])

    guard let f = TestHelpers.firstFunction(named: "f", in: tu) else {
      return XCTFail("Failed to find f")
    }

    XCTAssertEqual(f.availabilityKind, .deprecated)
    XCTAssertTrue(f.availability.alwaysDeprecated)
    XCTAssertEqual(f.availability.deprecationMessage, "use g")

    var xCursor: Cursor?
    tu.visitChildren { cursor in
      if cursor is EnumConstantDecl, cursor.description == "X" {
        xCursor = cursor
        return .abort
      }
      return .recurse
    }

    guard let xCursor else {
      return XCTFail("Failed to find enum constant X")
    }

    // `clang_Cursor_Evaluate` is defined for expression cursors; some libclang
    // builds won't evaluate the decl cursor directly, so fall back to a child
    // expression.
    var xEval = xCursor.evaluate()
    if xEval == nil {
      xCursor.visitChildren { child in
        if let eval = child.evaluate() {
          xEval = eval
          return .abort
        }
        return .recurse
      }
    }

    guard let xEval else {
      return XCTFail("Failed to evaluate X")
    }

    switch xEval {
    case .int(let value):
      XCTAssertEqual(value, 42)
    default:
      XCTFail("Expected integer eval result")
    }
  }

  func testObjCDeclQualifiersAndPropertyAttributes() throws {
    let src = #"""
    @interface A
    @property(nonatomic, readonly) int x;
    - (inout int)foo:(in int)p;
    @end
    """#

    let tu = try TestHelpers.makeTU(source: src, language: .objectiveC)

    let propertyAttrs: ObjCPropertyAttributes? = TestHelpers.firstCursor(in: tu) { cursor in
      guard cursor is ObjCPropertyDecl else { return nil }
      return (cursor as? ObjCPropertyDecl)?.attributes
    }

    guard let propertyAttrs else {
      return XCTFail("Failed to find ObjCPropertyDecl")
    }
    XCTAssertTrue(propertyAttrs.contains(.nonatomic))
    XCTAssertTrue(propertyAttrs.contains(.readonly))

    let returnQuals: ObjCDeclQualifiers? = TestHelpers.firstCursor(in: tu) { cursor in
      guard cursor is ObjCInstanceMethodDecl, cursor.description == "foo:" else { return nil }
      return cursor.objcDeclQualifiers
    }

    guard let returnQuals else {
      return XCTFail("Failed to find ObjCInstanceMethodDecl")
    }
    XCTAssertTrue(returnQuals.contains(.inout))

    var paramQuals: ObjCDeclQualifiers?
    tu.visitChildren { cursor in
      if cursor is ObjCInstanceMethodDecl, cursor.description == "foo:" {
        cursor.visitChildren { child in
          if child.description == "p" {
            paramQuals = child.objcDeclQualifiers
            return .abort
          }
          return .recurse
        }
        return .abort
      }
      return .recurse
    }

    XCTAssertEqual(paramQuals?.contains(.in), true)
  }
}
