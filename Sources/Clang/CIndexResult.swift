import cclang

/// Result codes used by certain higher-level libclang queries.
public enum CIndexResult {
  /// Function returned successfully.
  case success

  /// One of the parameters was invalid for the function.
  case invalid

  /// The function was terminated by a callback (e.g. it returned
  /// `CXVisit_Break`).
  case visitBreak

  internal init?(clang: CXResult) {
    switch clang {
    case CXResult_Success: self = .success
    case CXResult_Invalid: self = .invalid
    case CXResult_VisitBreak: self = .visitBreak
    default: return nil
    }
  }
}
