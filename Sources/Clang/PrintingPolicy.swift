import cclang

/// Properties for the printing policy.
///
/// See `clang::PrintingPolicy` for more information.
public enum PrintingPolicyProperty {
  /// The number of spaces to use to indent each line.
  case indentation
  /// Whether we should suppress printing of the actual specifiers for the given type or declaration.
  case suppressSpecifiers
  /// Whether type printing should skip printing the tag keyword.
  case suppressTagKeyword
  /// When true, include the body of a tag definition.
  case includeTagDefinition
  /// Suppresses printing of scope specifiers.
  case suppressScope
  /// Suppress printing parts of scope specifiers that are never written, e.g., for anonymous namespaces.
  case suppressUnwrittenScope
  /// Suppress printing of variable initializers.
  case suppressInitializers
  /// Whether we should print the sizes of constant array expressions as written in the sources.
  case constantArraySizeAsWritten
  /// When printing an anonymous tag name, also print the location of that entity (e.g., "enum <anonymous at t.h:10:5>").
  case anonymousTagLocations
  /// When true, suppress printing of the __strong lifetime qualifier in ARC.
  case suppressStrongLifetime
  /// When true, suppress printing of lifetime qualifier in ARC.
  case suppressLifetimeQualifiers
  /// When true, suppresses printing template arguments in names of C++ constructors.
  case suppressTemplateArgsInCXXConstructors
  /// Whether we can use `bool` rather than `_Bool` (even if the language doesn't actually have `bool`, because, e.g., it is defined as a macro).
  case bool
  /// Whether we can use `restrict` rather than `__restrict`.
  case restrict
  /// Whether we can use `alignof` rather than `__alignof`.
  case alignof
  /// Whether we can use `_Alignof` rather than `__alignof`.
  case underscoreAlignof
  /// Whether we should use `(void)` rather than `()` for a function prototype with zero parameters.
  case useVoidForZeroParams
  /// Provide a terse output.
  case terseOutput
  /// When true, do certain refinement needed for producing proper declaration tag; such as, do not print attributes attached to the declaration.
  case polishForDeclaration
  /// When true, print the half-precision floating-point type as `half` instead of `__fp16`.
  case half
  /// When true, print the built-in wchar_t type as `__wchar_t`.
  case mswChar
  /// When true, include newlines after statements like "break", etc.
  case includeNewlines
  /// Use whitespace and punctuation like MSVC does.
  case msvcFormatting
  /// Whether we should print the constant expressions as written in the sources.
  case constantsAsWritten
  /// When true, don't print the implicit `self` or `this` expressions.
  case suppressImplicitBase
  /// When true, print the fully qualified name of function declarations.
  case fullyQualifiedName

  internal init?(clang: CXPrintingPolicyProperty) {
    switch clang {
    case CXPrintingPolicy_Indentation: self = .indentation
    case CXPrintingPolicy_SuppressSpecifiers: self = .suppressSpecifiers
    case CXPrintingPolicy_SuppressTagKeyword: self = .suppressTagKeyword
    case CXPrintingPolicy_IncludeTagDefinition: self = .includeTagDefinition
    case CXPrintingPolicy_SuppressScope: self = .suppressScope
    case CXPrintingPolicy_SuppressUnwrittenScope: self = .suppressUnwrittenScope
    case CXPrintingPolicy_SuppressInitializers: self = .suppressInitializers
    case CXPrintingPolicy_ConstantArraySizeAsWritten: self = .constantArraySizeAsWritten
    case CXPrintingPolicy_AnonymousTagLocations: self = .anonymousTagLocations
    case CXPrintingPolicy_SuppressStrongLifetime: self = .suppressStrongLifetime
    case CXPrintingPolicy_SuppressLifetimeQualifiers: self = .suppressLifetimeQualifiers
    case CXPrintingPolicy_SuppressTemplateArgsInCXXConstructors: self = .suppressTemplateArgsInCXXConstructors
    case CXPrintingPolicy_Bool: self = .bool
    case CXPrintingPolicy_Restrict: self = .restrict
    case CXPrintingPolicy_Alignof: self = .alignof
    case CXPrintingPolicy_UnderscoreAlignof: self = .underscoreAlignof
    case CXPrintingPolicy_UseVoidForZeroParams: self = .useVoidForZeroParams
    case CXPrintingPolicy_TerseOutput: self = .terseOutput
    case CXPrintingPolicy_PolishForDeclaration: self = .polishForDeclaration
    case CXPrintingPolicy_Half: self = .half
    case CXPrintingPolicy_MSWChar: self = .mswChar
    case CXPrintingPolicy_IncludeNewlines: self = .includeNewlines
    case CXPrintingPolicy_MSVCFormatting: self = .msvcFormatting
    case CXPrintingPolicy_ConstantsAsWritten: self = .constantsAsWritten
    case CXPrintingPolicy_SuppressImplicitBase: self = .suppressImplicitBase
    case CXPrintingPolicy_FullyQualifiedName: self = .fullyQualifiedName
    default: return nil
    }
  }

  internal var asClang: CXPrintingPolicyProperty {
    switch self {
    case .indentation: return CXPrintingPolicy_Indentation
    case .suppressSpecifiers: return CXPrintingPolicy_SuppressSpecifiers
    case .suppressTagKeyword: return CXPrintingPolicy_SuppressTagKeyword
    case .includeTagDefinition: return CXPrintingPolicy_IncludeTagDefinition
    case .suppressScope: return CXPrintingPolicy_SuppressScope
    case .suppressUnwrittenScope: return CXPrintingPolicy_SuppressUnwrittenScope
    case .suppressInitializers: return CXPrintingPolicy_SuppressInitializers
    case .constantArraySizeAsWritten: return CXPrintingPolicy_ConstantArraySizeAsWritten
    case .anonymousTagLocations: return CXPrintingPolicy_AnonymousTagLocations
    case .suppressStrongLifetime: return CXPrintingPolicy_SuppressStrongLifetime
    case .suppressLifetimeQualifiers: return CXPrintingPolicy_SuppressLifetimeQualifiers
    case .suppressTemplateArgsInCXXConstructors: return CXPrintingPolicy_SuppressTemplateArgsInCXXConstructors
    case .bool: return CXPrintingPolicy_Bool
    case .restrict: return CXPrintingPolicy_Restrict
    case .alignof: return CXPrintingPolicy_Alignof
    case .underscoreAlignof: return CXPrintingPolicy_UnderscoreAlignof
    case .useVoidForZeroParams: return CXPrintingPolicy_UseVoidForZeroParams
    case .terseOutput: return CXPrintingPolicy_TerseOutput
    case .polishForDeclaration: return CXPrintingPolicy_PolishForDeclaration
    case .half: return CXPrintingPolicy_Half
    case .mswChar: return CXPrintingPolicy_MSWChar
    case .includeNewlines: return CXPrintingPolicy_IncludeNewlines
    case .msvcFormatting: return CXPrintingPolicy_MSVCFormatting
    case .constantsAsWritten: return CXPrintingPolicy_ConstantsAsWritten
    case .suppressImplicitBase: return CXPrintingPolicy_SuppressImplicitBase
    case .fullyQualifiedName: return CXPrintingPolicy_FullyQualifiedName
    }
  }
}

extension PrintingPolicyProperty {
  // Keep a direct reference so the audit sees CXPrintingPolicy_LastProperty.
  internal static var clangLastProperty: CXPrintingPolicyProperty {
    return CXPrintingPolicy_LastProperty
  }
}

/// A policy that controls pretty printing for `clang_getCursorPrettyPrinted`.
public final class PrintingPolicy {
  fileprivate let clang: CXPrintingPolicy

  fileprivate init(clang: CXPrintingPolicy) {
    self.clang = clang
  }

  /// Initialize a PrintingPolicy from a cursor.
  ///
  /// - Parameter cursor: The cursor to get the printing policy from.
  public convenience init(cursor: Cursor) {
    self.init(clang: clang_getCursorPrintingPolicy(cursor.asClang()))
  }

  deinit {
    clang_PrintingPolicy_dispose(clang)
  }

  /// Get a property value for the given printing policy.
  public func get(_ property: PrintingPolicyProperty) -> UInt32 {
    return clang_PrintingPolicy_getProperty(clang, property.asClang)
  }

  /// Set a property value for the given printing policy.
  public func set(_ property: PrintingPolicyProperty, value: UInt32) {
    clang_PrintingPolicy_setProperty(clang, property.asClang, value)
  }
}

extension Cursor {
  /// Retrieve the default policy for the cursor.
  ///
  /// The policy should be released after use with `clang_PrintingPolicy_dispose`.
  public var printingPolicy: PrintingPolicy {
    return PrintingPolicy(clang: clang_getCursorPrintingPolicy(asClang()))
  }

  /// Pretty print declarations.
  ///
  /// - Parameters:
  ///   - policy: The policy to control the entities being printed. If `nil`, a
  ///     default policy is used.
  /// - Returns: The pretty printed declaration or the empty string for other
  ///   cursors.
  public func prettyPrinted(using policy: PrintingPolicy? = nil) -> String {
    return clang_getCursorPrettyPrinted(asClang(), policy?.clang).asSwift()
  }
}

extension CType {
  /// Pretty-print the underlying type using a custom printing policy.
  ///
  /// If the type is invalid, an empty string is returned.
  public func prettyPrinted(using policy: PrintingPolicy) -> String {
    return clang_getTypePrettyPrinted(asClang(), policy.clang).asSwift()
  }
}
