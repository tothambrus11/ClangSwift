import cclang

/// Categorizes how memory is being used by a translation unit.
public enum TUResourceUsageKind {
  case ast
  case identifiers
  case selectors
  case globalCompletionResults
  case sourceManagerContentCache
  case astSideTables
  case sourceManagerMemBufferMalloc
  case sourceManagerMemBufferMMap
  case externalASTSourceMemBufferMalloc
  case externalASTSourceMemBufferMMap
  case preprocessor
  case preprocessingRecord
  case sourceManagerDataStructures
  case preprocessorHeaderSearch

  // Sentinel values from the C API.
  case memoryInBytesBegin
  case memoryInBytesEnd
  case first
  case last

  internal init?(clang: CXTUResourceUsageKind) {
    switch clang {
    case CXTUResourceUsage_AST: self = .ast
    case CXTUResourceUsage_Identifiers: self = .identifiers
    case CXTUResourceUsage_Selectors: self = .selectors
    case CXTUResourceUsage_GlobalCompletionResults: self = .globalCompletionResults
    case CXTUResourceUsage_SourceManagerContentCache: self = .sourceManagerContentCache
    case CXTUResourceUsage_AST_SideTables: self = .astSideTables
    case CXTUResourceUsage_SourceManager_Membuffer_Malloc: self = .sourceManagerMemBufferMalloc
    case CXTUResourceUsage_SourceManager_Membuffer_MMap: self = .sourceManagerMemBufferMMap
    case CXTUResourceUsage_ExternalASTSource_Membuffer_Malloc: self = .externalASTSourceMemBufferMalloc
    case CXTUResourceUsage_ExternalASTSource_Membuffer_MMap: self = .externalASTSourceMemBufferMMap
    case CXTUResourceUsage_Preprocessor: self = .preprocessor
    case CXTUResourceUsage_PreprocessingRecord: self = .preprocessingRecord
    case CXTUResourceUsage_SourceManager_DataStructures: self = .sourceManagerDataStructures
    case CXTUResourceUsage_Preprocessor_HeaderSearch: self = .preprocessorHeaderSearch
    case CXTUResourceUsage_MEMORY_IN_BYTES_BEGIN: self = .memoryInBytesBegin
    case CXTUResourceUsage_MEMORY_IN_BYTES_END: self = .memoryInBytesEnd
    case CXTUResourceUsage_First: self = .first
    case CXTUResourceUsage_Last: self = .last
    default: return nil
    }
  }

  internal var asClang: CXTUResourceUsageKind {
    switch self {
    case .ast: return CXTUResourceUsage_AST
    case .identifiers: return CXTUResourceUsage_Identifiers
    case .selectors: return CXTUResourceUsage_Selectors
    case .globalCompletionResults: return CXTUResourceUsage_GlobalCompletionResults
    case .sourceManagerContentCache: return CXTUResourceUsage_SourceManagerContentCache
    case .astSideTables: return CXTUResourceUsage_AST_SideTables
    case .sourceManagerMemBufferMalloc: return CXTUResourceUsage_SourceManager_Membuffer_Malloc
    case .sourceManagerMemBufferMMap: return CXTUResourceUsage_SourceManager_Membuffer_MMap
    case .externalASTSourceMemBufferMalloc: return CXTUResourceUsage_ExternalASTSource_Membuffer_Malloc
    case .externalASTSourceMemBufferMMap: return CXTUResourceUsage_ExternalASTSource_Membuffer_MMap
    case .preprocessor: return CXTUResourceUsage_Preprocessor
    case .preprocessingRecord: return CXTUResourceUsage_PreprocessingRecord
    case .sourceManagerDataStructures: return CXTUResourceUsage_SourceManager_DataStructures
    case .preprocessorHeaderSearch: return CXTUResourceUsage_Preprocessor_HeaderSearch
    case .memoryInBytesBegin: return CXTUResourceUsage_MEMORY_IN_BYTES_BEGIN
    case .memoryInBytesEnd: return CXTUResourceUsage_MEMORY_IN_BYTES_END
    case .first: return CXTUResourceUsage_First
    case .last: return CXTUResourceUsage_Last
    }
  }

  /// Returns the human-readable null-terminated C string that represents the
  /// name of the memory category. This string should never be freed.
  public var name: String {
    return String(cString: clang_getTUResourceUsageName(asClang))
  }
}

public struct TUResourceUsageEntry {
  public let kind: TUResourceUsageKind
  public let amount: UInt

  internal init?(clang: CXTUResourceUsageEntry) {
    guard let kind = TUResourceUsageKind(clang: clang.kind) else { return nil }
    self.kind = kind
    self.amount = UInt(clang.amount)
  }
}

/// The memory usage of a TranslationUnit, broken into categories.
public struct TUResourceUsage {
  public let entries: [TUResourceUsageEntry]

  internal init(clang usage: CXTUResourceUsage) {
    var result: [TUResourceUsageEntry] = []
    result.reserveCapacity(Int(usage.numEntries))

    if let ptr = usage.entries {
      for i in 0..<Int(usage.numEntries) {
        if let entry = TUResourceUsageEntry(clang: ptr[i]) {
          result.append(entry)
        }
      }
    }

    self.entries = result
  }
}

extension TranslationUnit {
  /// Return the memory usage of a translation unit.
  ///
  /// This object should be released with `clang_disposeCXTUResourceUsage()`.
  public var resourceUsage: TUResourceUsage {
    let usage = clang_getCXTUResourceUsage(clang)
    defer { clang_disposeCXTUResourceUsage(usage) }
    return TUResourceUsage(clang: usage)
  }
}
