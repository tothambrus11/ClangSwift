import cclang

/// Used to express an option policy in the Clang C API.
///
/// In Clang's C headers this is spelled as `CXChoice` and is typically used
/// when an API wants a tri-state value: use a default, force-enable, or
/// force-disable.
public enum Choice {
  /// Use the default value of an option that may depend on the process
  /// environment.
  case `default`

  /// Enable the option.
  case enabled

  /// Disable the option.
  case disabled

  internal init?(clang: CXChoice) {
    switch clang {
    case CXChoice_Default: self = .default
    case CXChoice_Enabled: self = .enabled
    case CXChoice_Disabled: self = .disabled
    default: return nil
    }
  }

  internal var asClang: CXChoice {
    switch self {
    case .default: return CXChoice_Default
    case .enabled: return CXChoice_Enabled
    case .disabled: return CXChoice_Disabled
    }
  }
}
