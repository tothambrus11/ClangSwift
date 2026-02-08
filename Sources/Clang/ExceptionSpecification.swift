import cclang

/// Describes the exception specification of a cursor.
///
/// A negative value indicates that the cursor is not a function declaration.
public enum ExceptionSpecificationKind {
  /// The cursor has no exception specification.
  case none

  /// The cursor has exception specification `throw()`.
  case dynamicNone

  /// The cursor has exception specification `throw(T1, T2)`.
  case dynamic

  /// The cursor has exception specification `throw(...)`.
  case msAny

  /// The cursor has exception specification basic `noexcept`.
  case basicNoexcept

  /// The cursor has exception specification computed `noexcept`.
  case computedNoexcept

  /// The exception specification has not yet been evaluated.
  case unevaluated

  /// The exception specification has not yet been instantiated.
  case uninstantiated

  /// The exception specification has not been parsed yet.
  case unparsed

  /// The cursor has a `__declspec(nothrow)` exception specification.
  case noThrow

  internal init?(clang: CXCursor_ExceptionSpecificationKind) {
    switch clang {
    case CXCursor_ExceptionSpecificationKind_None: self = .none
    case CXCursor_ExceptionSpecificationKind_DynamicNone: self = .dynamicNone
    case CXCursor_ExceptionSpecificationKind_Dynamic: self = .dynamic
    case CXCursor_ExceptionSpecificationKind_MSAny: self = .msAny
    case CXCursor_ExceptionSpecificationKind_BasicNoexcept: self = .basicNoexcept
    case CXCursor_ExceptionSpecificationKind_ComputedNoexcept: self = .computedNoexcept
    case CXCursor_ExceptionSpecificationKind_Unevaluated: self = .unevaluated
    case CXCursor_ExceptionSpecificationKind_Uninstantiated: self = .uninstantiated
    case CXCursor_ExceptionSpecificationKind_Unparsed: self = .unparsed
    case CXCursor_ExceptionSpecificationKind_NoThrow: self = .noThrow
    default: return nil
    }
  }
}

extension Cursor {
  /// Retrieve the exception specification type associated with a given cursor.
  /// This is a value of type `CXCursor_ExceptionSpecificationKind`.
  ///
  /// This only returns a valid result if the cursor refers to a function or
  /// method.
  public var exceptionSpecificationKind: ExceptionSpecificationKind? {
    let raw = clang_getCursorExceptionSpecificationType(asClang())
    if raw < 0 { return nil }
    let clangKind = CXCursor_ExceptionSpecificationKind(rawValue: UInt32(raw))
    return ExceptionSpecificationKind(clang: clangKind)
  }
}

extension CType {
  /// Retrieve the exception specification type associated with a function type.
  /// This is a value of type `CXCursor_ExceptionSpecificationKind`.
  ///
  /// If a non-function type is passed in, `nil` is returned.
  public var exceptionSpecificationKind: ExceptionSpecificationKind? {
    let raw = clang_getExceptionSpecificationType(asClang())
    if raw < 0 { return nil }
    let clangKind = CXCursor_ExceptionSpecificationKind(rawValue: UInt32(raw))
    return ExceptionSpecificationKind(clang: clangKind)
  }
}
