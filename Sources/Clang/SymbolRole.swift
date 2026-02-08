import cclang

/// Roles that are attributed to symbol occurrences.
///
/// Internal: this currently mirrors low 9 bits of clang::index::SymbolRole with
/// higher bits zeroed. These high bits may be exposed in the future.
public struct SymbolRole: OptionSet, Sendable {
  public typealias RawValue = CXSymbolRole.RawValue
  public let rawValue: RawValue

  public init(rawValue: RawValue) {
    self.rawValue = rawValue
  }

  public static let none = SymbolRole(rawValue: CXSymbolRole_None.rawValue)
  public static let declaration = SymbolRole(rawValue: CXSymbolRole_Declaration.rawValue)
  public static let definition = SymbolRole(rawValue: CXSymbolRole_Definition.rawValue)
  public static let reference = SymbolRole(rawValue: CXSymbolRole_Reference.rawValue)
  public static let read = SymbolRole(rawValue: CXSymbolRole_Read.rawValue)
  public static let write = SymbolRole(rawValue: CXSymbolRole_Write.rawValue)
  public static let call = SymbolRole(rawValue: CXSymbolRole_Call.rawValue)
  public static let `dynamic` = SymbolRole(rawValue: CXSymbolRole_Dynamic.rawValue)
  public static let addressOf = SymbolRole(rawValue: CXSymbolRole_AddressOf.rawValue)
  public static let implicit = SymbolRole(rawValue: CXSymbolRole_Implicit.rawValue)
}
