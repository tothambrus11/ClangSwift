import cclang

/// MARK: Special Types
public struct RecordType: ClangTypeBacked {
  let clang: CXType
  /// Computes the offset of a named field in a record of the given type
  /// in bytes as it would be returned by __offsetof__ as per C++11[18.2p4]
  /// - returns: The offset of a field with the given name in the type.
  /// - throws:
  ///     - `TypeLayoutError.invalid` if the type declaration is not a record
  ///        field.
  ///     - `TypeLayoutError.incomplete` if the type declaration is an
  ///       incomplete type
  ///     - `TypeLayoutError.dependent` if the type declaration is dependent
  ///     - `TypeLayoutError.invalidFieldName` if the field is not found in
  ///       the receiving type.
  public func offsetOf(fieldName: String) throws -> Int {
    let val = clang_Type_getOffsetOf(asClang(), fieldName)
    if let error = TypeLayoutError(clang: CXTypeLayoutError(rawValue: Int32(val))) {
      throw error
    }
    return Int(val)
  }

  /// Gathers and returns all the fields of this record.
  public func fields() -> [Cursor] {
    let fields = Box([Cursor]())
    let fieldsRef = Unmanaged.passUnretained(fields)
    let opaque = fieldsRef.toOpaque()
    clang_Type_visitFields(
      asClang(),
      { (child, opaque) -> CXVisitorResult in
        guard let opaque else { return CXVisit_Break }
        let fieldsRef = Unmanaged<Box<[Cursor]>>.fromOpaque(opaque)
        let fields = fieldsRef.takeUnretainedValue()
        if let cursor = convertCursor(child) {
          fields.value.append(cursor)
        }
        return CXVisit_Continue
      }, opaque)
    return fields.value
  }
}

/// MARK: Standard Types

/// A type whose specific kind is not exposed via this interface.
public struct UnexposedType: ClangTypeBacked {
  let clang: CXType
}

public struct VoidType: ClangTypeBacked {
  let clang: CXType
}

public struct BoolType: ClangTypeBacked {
  let clang: CXType
}

public struct Char_UType: ClangTypeBacked {
  let clang: CXType
}

public struct UCharType: ClangTypeBacked {
  let clang: CXType
}

public struct Char16Type: ClangTypeBacked {
  let clang: CXType
}

public struct Char32Type: ClangTypeBacked {
  let clang: CXType
}

public struct UShortType: ClangTypeBacked {
  let clang: CXType
}

public struct UIntType: ClangTypeBacked {
  let clang: CXType
}

public struct ULongType: ClangTypeBacked {
  let clang: CXType
}

public struct ULongLongType: ClangTypeBacked {
  let clang: CXType
}

public struct UInt128Type: ClangTypeBacked {
  let clang: CXType
}

public struct Char_SType: ClangTypeBacked {
  let clang: CXType
}

public struct SCharType: ClangTypeBacked {
  let clang: CXType
}

public struct WCharType: ClangTypeBacked {
  let clang: CXType
}

public struct ShortType: ClangTypeBacked {
  let clang: CXType
}

public struct HalfType: ClangTypeBacked {
  let clang: CXType
}

public struct Float16Type: ClangTypeBacked {
  let clang: CXType
}

public struct ShortAccumType: ClangTypeBacked {
  let clang: CXType
}

public struct AccumType: ClangTypeBacked {
  let clang: CXType
}

public struct LongAccumType: ClangTypeBacked {
  let clang: CXType
}

public struct UShortAccumType: ClangTypeBacked {
  let clang: CXType
}

public struct UAccumType: ClangTypeBacked {
  let clang: CXType
}

public struct ULongAccumType: ClangTypeBacked {
  let clang: CXType
}

public struct BFloat16Type: ClangTypeBacked {
  let clang: CXType
}

public struct IntType: ClangTypeBacked {
  let clang: CXType
}

public struct LongType: ClangTypeBacked {
  let clang: CXType
}

public struct LongLongType: ClangTypeBacked {
  let clang: CXType
}

public struct Int128Type: ClangTypeBacked {
  let clang: CXType
}

public struct FloatType: ClangTypeBacked {
  let clang: CXType
}

public struct DoubleType: ClangTypeBacked {
  let clang: CXType
}

public struct LongDoubleType: ClangTypeBacked {
  let clang: CXType
}

public struct Ibm128Type: ClangTypeBacked {
  let clang: CXType
}

public struct NullPtrType: ClangTypeBacked {
  let clang: CXType
}

public struct OverloadType: ClangTypeBacked {
  let clang: CXType
}

public struct DependentType: ClangTypeBacked {
  let clang: CXType
}

public struct ObjCIdType: ClangTypeBacked {
  let clang: CXType
}

public struct ObjCClassType: ClangTypeBacked {
  let clang: CXType
}

public struct ObjCSelType: ClangTypeBacked {
  let clang: CXType
}

public struct Float128Type: ClangTypeBacked {
  let clang: CXType
}

public struct ComplexType: ClangTypeBacked {
  let clang: CXType
}

/// OpenCL PipeType.
public struct PipeType: ClangTypeBacked {
  let clang: CXType
}

public struct PointerType: ClangTypeBacked {
  let clang: CXType

  public var pointee: CType? {
    return convertType(clang_getPointeeType(clang))
  }
}

public struct BlockPointerType: ClangTypeBacked {
  let clang: CXType
}

public struct LValueReferenceType: ClangTypeBacked {
  let clang: CXType
}

public struct RValueReferenceType: ClangTypeBacked {
  let clang: CXType
}

public struct EnumType: ClangTypeBacked {
  let clang: CXType
}

public struct TypedefType: ClangTypeBacked {
  let clang: CXType
}

public struct ObjCInterfaceType: ClangTypeBacked {
  let clang: CXType
}

public struct ObjCObjectType: ClangTypeBacked {
  let clang: CXType
}

public struct AttributedType: ClangTypeBacked {
  let clang: CXType
}

public struct ObjCTypeParam: ClangTypeBacked {
  let clang: CXType
}

public struct ObjCObjectPointerType: ClangTypeBacked {
  let clang: CXType
}

public struct FunctionNoProtoType: ClangTypeBacked {
  let clang: CXType
}

public struct FunctionProtoType: ClangTypeBacked {
  let clang: CXType
}

public struct ConstantArrayType: ClangTypeBacked {
  let clang: CXType

  public var element: CType? {
    return convertType(clang_getArrayElementType(clang))
  }

  public var count: Int32 {
    return clang_getNumArgTypes(clang)
  }
}

public struct VectorType: ClangTypeBacked {
  let clang: CXType
}

public struct ExtVectorType: ClangTypeBacked {
  let clang: CXType
}

public struct IncompleteArrayType: ClangTypeBacked {
  let clang: CXType

  public var element: CType? {
    return convertType(clang_getArrayElementType(clang))
  }
}

public struct VariableArrayType: ClangTypeBacked {
  let clang: CXType

  public var element: CType? {
    return convertType(clang_getArrayElementType(clang))
  }
}

public struct DependentSizedArrayType: ClangTypeBacked {
  let clang: CXType
}

public struct MemberPointerType: ClangTypeBacked {
  let clang: CXType
}

public struct AtomicType: ClangTypeBacked {
  let clang: CXType
}

public struct BTFTagAttributedType: ClangTypeBacked {
  let clang: CXType
}

/// HLSL Types
public struct HLSLResourceType: ClangTypeBacked {
  let clang: CXType
}

/// HLSL Types
public struct HLSLAttributedResourceType: ClangTypeBacked {
  let clang: CXType
}

/// HLSL Types
public struct HLSLInlineSpirvType: ClangTypeBacked {
  let clang: CXType
}

public struct AutoType: ClangTypeBacked {
  let clang: CXType
}

/// Represents a type that was referred to using an elaborated type keyword.
public struct ElaboratedType: ClangTypeBacked {
  let clang: CXType
}

/// OpenCL builtin types.
public struct OCLImage1dROType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage1dArrayROType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage1dBufferROType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dROType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dArrayROType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dDepthROType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dArrayDepthROType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dMSAAROType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dArrayMSAAROType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dMSAADepthROType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dArrayMSAADepthROType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage3dROType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage1dWOType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage1dArrayWOType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage1dBufferWOType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dWOType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dArrayWOType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dDepthWOType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dArrayDepthWOType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dMSAAWOType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dArrayMSAAWOType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dMSAADepthWOType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dArrayMSAADepthWOType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage3dWOType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage1dRWType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage1dArrayRWType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage1dBufferRWType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dRWType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dArrayRWType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dDepthRWType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dArrayDepthRWType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dMSAARWType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dArrayMSAARWType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dMSAADepthRWType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage2dArrayMSAADepthRWType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLImage3dRWType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLSamplerType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLEventType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLQueueType: ClangTypeBacked { let clang: CXType }
/// OpenCL builtin types.
public struct OCLReserveIDType: ClangTypeBacked { let clang: CXType }

public struct OCLIntelSubgroupAVCMcePayloadType: ClangTypeBacked { let clang: CXType }
public struct OCLIntelSubgroupAVCImePayloadType: ClangTypeBacked { let clang: CXType }
public struct OCLIntelSubgroupAVCRefPayloadType: ClangTypeBacked { let clang: CXType }
public struct OCLIntelSubgroupAVCSicPayloadType: ClangTypeBacked { let clang: CXType }
public struct OCLIntelSubgroupAVCMceResultType: ClangTypeBacked { let clang: CXType }
public struct OCLIntelSubgroupAVCImeResultType: ClangTypeBacked { let clang: CXType }
public struct OCLIntelSubgroupAVCRefResultType: ClangTypeBacked { let clang: CXType }
public struct OCLIntelSubgroupAVCSicResultType: ClangTypeBacked { let clang: CXType }
public struct OCLIntelSubgroupAVCImeResultSingleReferenceStreamoutType: ClangTypeBacked {
  let clang: CXType
}
public struct OCLIntelSubgroupAVCImeResultDualReferenceStreamoutType: ClangTypeBacked {
  let clang: CXType
}
public struct OCLIntelSubgroupAVCImeSingleReferenceStreaminType: ClangTypeBacked {
  let clang: CXType
}
public struct OCLIntelSubgroupAVCImeDualReferenceStreaminType: ClangTypeBacked { let clang: CXType }

/// Converts a CXType to a CType, returning `nil` if it was unsuccessful
func convertType(_ clang: CXType) -> CType? {
  switch clang.kind {
  case CXType_Invalid: return nil
  case CXType_Unexposed: return UnexposedType(clang: clang)
  case CXType_FirstBuiltin: return UnexposedType(clang: clang)
  case CXType_Void: return VoidType(clang: clang)
  case CXType_Bool: return BoolType(clang: clang)
  case CXType_Char_U: return Char_UType(clang: clang)
  case CXType_UChar: return UCharType(clang: clang)
  case CXType_Char16: return Char16Type(clang: clang)
  case CXType_Char32: return Char32Type(clang: clang)
  case CXType_UShort: return UShortType(clang: clang)
  case CXType_UInt: return UIntType(clang: clang)
  case CXType_ULong: return ULongType(clang: clang)
  case CXType_ULongLong: return ULongLongType(clang: clang)
  case CXType_UInt128: return UInt128Type(clang: clang)
  case CXType_Char_S: return Char_SType(clang: clang)
  case CXType_SChar: return SCharType(clang: clang)
  case CXType_WChar: return WCharType(clang: clang)
  case CXType_Short: return ShortType(clang: clang)
  case CXType_Half: return HalfType(clang: clang)
  case CXType_Float16: return Float16Type(clang: clang)
  case CXType_ShortAccum: return ShortAccumType(clang: clang)
  case CXType_Accum: return AccumType(clang: clang)
  case CXType_LongAccum: return LongAccumType(clang: clang)
  case CXType_UShortAccum: return UShortAccumType(clang: clang)
  case CXType_UAccum: return UAccumType(clang: clang)
  case CXType_ULongAccum: return ULongAccumType(clang: clang)
  case CXType_BFloat16: return BFloat16Type(clang: clang)
  case CXType_Int: return IntType(clang: clang)
  case CXType_Long: return LongType(clang: clang)
  case CXType_LongLong: return LongLongType(clang: clang)
  case CXType_Int128: return Int128Type(clang: clang)
  case CXType_Float: return FloatType(clang: clang)
  case CXType_Double: return DoubleType(clang: clang)
  case CXType_LongDouble: return LongDoubleType(clang: clang)
  case CXType_Ibm128: return Ibm128Type(clang: clang)
  case CXType_NullPtr: return NullPtrType(clang: clang)
  case CXType_Overload: return OverloadType(clang: clang)
  case CXType_Dependent: return DependentType(clang: clang)
  case CXType_ObjCId: return ObjCIdType(clang: clang)
  case CXType_ObjCClass: return ObjCClassType(clang: clang)
  case CXType_ObjCSel: return ObjCSelType(clang: clang)
  case CXType_Float128: return Float128Type(clang: clang)
  case CXType_Complex: return ComplexType(clang: clang)
  case CXType_Pipe: return PipeType(clang: clang)
  case CXType_Pointer: return PointerType(clang: clang)
  case CXType_BlockPointer: return BlockPointerType(clang: clang)
  case CXType_LValueReference: return LValueReferenceType(clang: clang)
  case CXType_RValueReference: return RValueReferenceType(clang: clang)
  case CXType_Record: return RecordType(clang: clang)
  case CXType_Enum: return EnumType(clang: clang)
  case CXType_Typedef: return TypedefType(clang: clang)
  case CXType_ObjCInterface: return ObjCInterfaceType(clang: clang)
  case CXType_ObjCObject: return ObjCObjectType(clang: clang)
  case CXType_Attributed: return AttributedType(clang: clang)
  case CXType_ObjCObjectPointer: return ObjCObjectPointerType(clang: clang)
  case CXType_ObjCTypeParam: return ObjCTypeParam(clang: clang)
  case CXType_FunctionNoProto: return FunctionNoProtoType(clang: clang)
  case CXType_FunctionProto: return FunctionProtoType(clang: clang)
  case CXType_ConstantArray: return ConstantArrayType(clang: clang)
  case CXType_Vector: return VectorType(clang: clang)
  case CXType_ExtVector: return ExtVectorType(clang: clang)
  case CXType_IncompleteArray: return IncompleteArrayType(clang: clang)
  case CXType_VariableArray: return VariableArrayType(clang: clang)
  case CXType_DependentSizedArray: return DependentSizedArrayType(clang: clang)
  case CXType_MemberPointer: return MemberPointerType(clang: clang)
  case CXType_Atomic: return AtomicType(clang: clang)
  case CXType_BTFTagAttributed: return BTFTagAttributedType(clang: clang)
  case CXType_HLSLResource: return HLSLResourceType(clang: clang)
  case CXType_HLSLAttributedResource: return HLSLAttributedResourceType(clang: clang)
  case CXType_HLSLInlineSpirv: return HLSLInlineSpirvType(clang: clang)
  case CXType_Auto: return AutoType(clang: clang)
  case CXType_Elaborated: return ElaboratedType(clang: clang)
  case CXType_OCLImage1dRO: return OCLImage1dROType(clang: clang)
  case CXType_OCLImage1dArrayRO: return OCLImage1dArrayROType(clang: clang)
  case CXType_OCLImage1dBufferRO: return OCLImage1dBufferROType(clang: clang)
  case CXType_OCLImage2dRO: return OCLImage2dROType(clang: clang)
  case CXType_OCLImage2dArrayRO: return OCLImage2dArrayROType(clang: clang)
  case CXType_OCLImage2dDepthRO: return OCLImage2dDepthROType(clang: clang)
  case CXType_OCLImage2dArrayDepthRO: return OCLImage2dArrayDepthROType(clang: clang)
  case CXType_OCLImage2dMSAARO: return OCLImage2dMSAAROType(clang: clang)
  case CXType_OCLImage2dArrayMSAARO: return OCLImage2dArrayMSAAROType(clang: clang)
  case CXType_OCLImage2dMSAADepthRO: return OCLImage2dMSAADepthROType(clang: clang)
  case CXType_OCLImage2dArrayMSAADepthRO: return OCLImage2dArrayMSAADepthROType(clang: clang)
  case CXType_OCLImage3dRO: return OCLImage3dROType(clang: clang)
  case CXType_OCLImage1dWO: return OCLImage1dWOType(clang: clang)
  case CXType_OCLImage1dArrayWO: return OCLImage1dArrayWOType(clang: clang)
  case CXType_OCLImage1dBufferWO: return OCLImage1dBufferWOType(clang: clang)
  case CXType_OCLImage2dWO: return OCLImage2dWOType(clang: clang)
  case CXType_OCLImage2dArrayWO: return OCLImage2dArrayWOType(clang: clang)
  case CXType_OCLImage2dDepthWO: return OCLImage2dDepthWOType(clang: clang)
  case CXType_OCLImage2dArrayDepthWO: return OCLImage2dArrayDepthWOType(clang: clang)
  case CXType_OCLImage2dMSAAWO: return OCLImage2dMSAAWOType(clang: clang)
  case CXType_OCLImage2dArrayMSAAWO: return OCLImage2dArrayMSAAWOType(clang: clang)
  case CXType_OCLImage2dMSAADepthWO: return OCLImage2dMSAADepthWOType(clang: clang)
  case CXType_OCLImage2dArrayMSAADepthWO: return OCLImage2dArrayMSAADepthWOType(clang: clang)
  case CXType_OCLImage3dWO: return OCLImage3dWOType(clang: clang)
  case CXType_OCLImage1dRW: return OCLImage1dRWType(clang: clang)
  case CXType_OCLImage1dArrayRW: return OCLImage1dArrayRWType(clang: clang)
  case CXType_OCLImage1dBufferRW: return OCLImage1dBufferRWType(clang: clang)
  case CXType_OCLImage2dRW: return OCLImage2dRWType(clang: clang)
  case CXType_OCLImage2dArrayRW: return OCLImage2dArrayRWType(clang: clang)
  case CXType_OCLImage2dDepthRW: return OCLImage2dDepthRWType(clang: clang)
  case CXType_OCLImage2dArrayDepthRW: return OCLImage2dArrayDepthRWType(clang: clang)
  case CXType_OCLImage2dMSAARW: return OCLImage2dMSAARWType(clang: clang)
  case CXType_OCLImage2dArrayMSAARW: return OCLImage2dArrayMSAARWType(clang: clang)
  case CXType_OCLImage2dMSAADepthRW: return OCLImage2dMSAADepthRWType(clang: clang)
  case CXType_OCLImage2dArrayMSAADepthRW: return OCLImage2dArrayMSAADepthRWType(clang: clang)
  case CXType_OCLImage3dRW: return OCLImage3dRWType(clang: clang)
  case CXType_OCLSampler: return OCLSamplerType(clang: clang)
  case CXType_OCLEvent: return OCLEventType(clang: clang)
  case CXType_OCLQueue: return OCLQueueType(clang: clang)
  case CXType_OCLReserveID: return OCLReserveIDType(clang: clang)
  case CXType_OCLIntelSubgroupAVCMcePayload: return OCLIntelSubgroupAVCMcePayloadType(clang: clang)
  case CXType_OCLIntelSubgroupAVCImePayload: return OCLIntelSubgroupAVCImePayloadType(clang: clang)
  case CXType_OCLIntelSubgroupAVCRefPayload: return OCLIntelSubgroupAVCRefPayloadType(clang: clang)
  case CXType_OCLIntelSubgroupAVCSicPayload: return OCLIntelSubgroupAVCSicPayloadType(clang: clang)
  case CXType_OCLIntelSubgroupAVCMceResult: return OCLIntelSubgroupAVCMceResultType(clang: clang)
  case CXType_OCLIntelSubgroupAVCImeResult: return OCLIntelSubgroupAVCImeResultType(clang: clang)
  case CXType_OCLIntelSubgroupAVCRefResult: return OCLIntelSubgroupAVCRefResultType(clang: clang)
  case CXType_OCLIntelSubgroupAVCSicResult: return OCLIntelSubgroupAVCSicResultType(clang: clang)
  case CXType_OCLIntelSubgroupAVCImeResultSingleReferenceStreamout:
    return OCLIntelSubgroupAVCImeResultSingleReferenceStreamoutType(clang: clang)
  case CXType_OCLIntelSubgroupAVCImeResultDualReferenceStreamout:
    return OCLIntelSubgroupAVCImeResultDualReferenceStreamoutType(clang: clang)
  case CXType_OCLIntelSubgroupAVCImeSingleReferenceStreamin:
    return OCLIntelSubgroupAVCImeSingleReferenceStreaminType(clang: clang)
  case CXType_OCLIntelSubgroupAVCImeDualReferenceStreamin:
    return OCLIntelSubgroupAVCImeDualReferenceStreaminType(clang: clang)
  case CXType_OCLIntelSubgroupAVCImeResultSingleRefStreamout:
    return OCLIntelSubgroupAVCImeResultSingleReferenceStreamoutType(clang: clang)
  case CXType_OCLIntelSubgroupAVCImeResultDualRefStreamout:
    return OCLIntelSubgroupAVCImeResultDualReferenceStreamoutType(clang: clang)
  case CXType_OCLIntelSubgroupAVCImeSingleRefStreamin:
    return OCLIntelSubgroupAVCImeSingleReferenceStreaminType(clang: clang)
  case CXType_OCLIntelSubgroupAVCImeDualRefStreamin:
    return OCLIntelSubgroupAVCImeDualReferenceStreaminType(clang: clang)
  case CXType_LastBuiltin: return UnexposedType(clang: clang)
  default: fatalError("invalid CXTypeKind \(clang)")
  }
}
