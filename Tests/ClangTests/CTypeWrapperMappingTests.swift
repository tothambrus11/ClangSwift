import XCTest
import cclang
@testable import Clang

final class CTypeWrapperMappingTests: XCTestCase {
  func testTypeLayoutErrorMapping() {
    XCTAssertEqual(TypeLayoutError(clang: CXTypeLayoutError_Dependent), .dependent)
    XCTAssertEqual(TypeLayoutError(clang: CXTypeLayoutError_Invalid), .invalid)
    XCTAssertEqual(TypeLayoutError(clang: CXTypeLayoutError_Incomplete), .incomplete)
    XCTAssertEqual(TypeLayoutError(clang: CXTypeLayoutError_NotConstantSize), .notConstantSize)
    XCTAssertEqual(TypeLayoutError(clang: CXTypeLayoutError_InvalidFieldName), .invalidFieldName)
    XCTAssertEqual(TypeLayoutError(clang: CXTypeLayoutError_Undeduced), .undeduced)
  }

  func testTypeNullabilityKindMapping() {
    XCTAssertEqual(TypeNullabilityKind(clang: CXTypeNullability_NonNull), .nonNull)
    XCTAssertEqual(TypeNullabilityKind(clang: CXTypeNullability_Nullable), .nullable)
    XCTAssertEqual(TypeNullabilityKind(clang: CXTypeNullability_Unspecified), .unspecified)
    XCTAssertEqual(TypeNullabilityKind(clang: CXTypeNullability_NullableResult), .nullableResult)
    XCTAssertNil(TypeNullabilityKind(clang: CXTypeNullability_Invalid))
  }

  func testRefQualifierMapping() {
    XCTAssertEqual(RefQualifier(clang: CXRefQualifier_LValue), .lvalue)
    XCTAssertEqual(RefQualifier(clang: CXRefQualifier_RValue), .rvalue)
    XCTAssertNil(RefQualifier(clang: CXRefQualifier_None))
  }
}
