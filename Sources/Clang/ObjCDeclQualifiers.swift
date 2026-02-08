import cclang

/// 'Qualifiers' written next to the return and parameter types in
/// Objective-C method declarations.
public struct ObjCDeclQualifiers: OptionSet, Sendable {
  public typealias RawValue = CXObjCDeclQualifierKind.RawValue
  public let rawValue: RawValue

  public init(rawValue: RawValue) {
    self.rawValue = rawValue
  }

  public static let none = ObjCDeclQualifiers(rawValue: CXObjCDeclQualifier_None.rawValue)
  public static let `in` = ObjCDeclQualifiers(rawValue: CXObjCDeclQualifier_In.rawValue)
  public static let `inout` = ObjCDeclQualifiers(rawValue: CXObjCDeclQualifier_Inout.rawValue)
  public static let out = ObjCDeclQualifiers(rawValue: CXObjCDeclQualifier_Out.rawValue)
  public static let bycopy = ObjCDeclQualifiers(rawValue: CXObjCDeclQualifier_Bycopy.rawValue)
  public static let byref = ObjCDeclQualifiers(rawValue: CXObjCDeclQualifier_Byref.rawValue)
  public static let oneway = ObjCDeclQualifiers(rawValue: CXObjCDeclQualifier_Oneway.rawValue)
}

extension Cursor {
  /// Given a cursor that represents an Objective-C method or parameter
  /// declaration, return the associated Objective-C qualifiers for the return
  /// type or the parameter respectively. The bits are formed from
  /// `CXObjCDeclQualifierKind`.
  public var objcDeclQualifiers: ObjCDeclQualifiers {
    return ObjCDeclQualifiers(rawValue: clang_Cursor_getObjCDeclQualifiers(asClang()))
  }
}
