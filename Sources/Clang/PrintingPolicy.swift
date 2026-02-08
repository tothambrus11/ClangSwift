import cclang

/// Properties for the printing policy.
///
/// See `clang::PrintingPolicy` for more information.
public enum PrintingPolicyProperty {
  case indentation
  case suppressSpecifiers
  case suppressTagKeyword
  case includeTagDefinition
  case suppressScope
  case suppressUnwrittenScope
  case suppressInitializers
  case constantArraySizeAsWritten
  case anonymousTagLocations
  case suppressStrongLifetime
  case suppressLifetimeQualifiers
  case suppressTemplateArgsInCXXConstructors
  case bool
  case restrict
  case alignof
  case underscoreAlignof
  case useVoidForZeroParams
  case terseOutput
  case polishForDeclaration
  case half
  case mswChar
  case includeNewlines
  case msvcFormatting
  case constantsAsWritten
  case suppressImplicitBase
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
