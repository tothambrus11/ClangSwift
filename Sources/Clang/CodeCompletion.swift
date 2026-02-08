import cclang

/// Describes a single piece of text within a code-completion string.
///
/// Each "chunk" within a code-completion string (`CXCompletionString`) is
/// either a piece of text with a specific "kind" that describes how that text
/// should be interpreted by the client or is another completion string.
public enum CompletionChunkKind {
  /// A code-completion string that describes "optional" text that
  /// could be a part of the template (but is not required).
  ///
  /// The Optional chunk is the only kind of chunk that has a code-completion
  /// string for its representation, which is accessible via
  /// `clang_getCompletionChunkCompletionString()`. The code-completion string
  /// describes an additional part of the template that is completely optional.
  /// For example, optional chunks can be used to describe the placeholders for
  /// arguments that match up with defaulted function parameters.
  case optional

  /// Text that a user would be expected to type to get this
  /// code-completion result.
  ///
  /// There will be exactly one "typed text" chunk in a semantic string, which
  /// will typically provide the spelling of a keyword or the name of a
  /// declaration that could be used at the current code point. Clients are
  /// expected to filter the code-completion results based on the text in this
  /// chunk.
  case typedText

  /// Text that should be inserted as part of a code-completion result.
  ///
  /// A "text" chunk represents text that is part of the template to be
  /// inserted into user code should this particular code-completion result
  /// be selected.
  case text

  /// Placeholder text that should be replaced by the user.
  ///
  /// A "placeholder" chunk marks a place where the user should insert text
  /// into the code-completion template.
  case placeholder

  /// Informative text that should be displayed but never inserted as
  /// part of the template.
  case informative

  /// Text that describes the current parameter when code-completion is
  /// referring to function call, message send, or template specialization.
  case currentParameter

  /// A left parenthesis ('('), used to initiate a function call or
  /// signal the beginning of a function parameter list.
  case leftParen

  /// A right parenthesis (')'), used to finish a function call or
  /// signal the end of a function parameter list.
  case rightParen

  /// A left bracket ('[').
  case leftBracket

  /// A right bracket (']').
  case rightBracket

  /// A left brace ('{').
  case leftBrace

  /// A right brace ('}').
  case rightBrace

  /// A left angle bracket ('<').
  case leftAngle

  /// A right angle bracket ('>').
  case rightAngle

  /// A comma separator (',').
  case comma

  /// Text that specifies the result type of a given result.
  ///
  /// This special kind of informative chunk is not meant to be inserted into
  /// the text buffer. Rather, it is meant to illustrate the type that an
  /// expression using the given completion string would have.
  case resultType

  /// A colon (':').
  case colon

  /// A semicolon (';').
  case semiColon

  /// An '=' sign.
  case equal

  /// Horizontal space (' ').
  case horizontalSpace

  /// Vertical space ('\\n'), after which it is generally a good idea to
  /// perform indentation.
  case verticalSpace

  internal init?(clang: CXCompletionChunkKind) {
    switch clang {
    case CXCompletionChunk_Optional: self = .optional
    case CXCompletionChunk_TypedText: self = .typedText
    case CXCompletionChunk_Text: self = .text
    case CXCompletionChunk_Placeholder: self = .placeholder
    case CXCompletionChunk_Informative: self = .informative
    case CXCompletionChunk_CurrentParameter: self = .currentParameter
    case CXCompletionChunk_LeftParen: self = .leftParen
    case CXCompletionChunk_RightParen: self = .rightParen
    case CXCompletionChunk_LeftBracket: self = .leftBracket
    case CXCompletionChunk_RightBracket: self = .rightBracket
    case CXCompletionChunk_LeftBrace: self = .leftBrace
    case CXCompletionChunk_RightBrace: self = .rightBrace
    case CXCompletionChunk_LeftAngle: self = .leftAngle
    case CXCompletionChunk_RightAngle: self = .rightAngle
    case CXCompletionChunk_Comma: self = .comma
    case CXCompletionChunk_ResultType: self = .resultType
    case CXCompletionChunk_Colon: self = .colon
    case CXCompletionChunk_SemiColon: self = .semiColon
    case CXCompletionChunk_Equal: self = .equal
    case CXCompletionChunk_HorizontalSpace: self = .horizontalSpace
    case CXCompletionChunk_VerticalSpace: self = .verticalSpace
    default: return nil
    }
  }
}

/// Flags that can be passed to `clang_codeCompleteAt()` to modify its behavior.
///
/// The enumerators in this enumeration can be bitwise-OR'd together to provide
/// multiple options to `clang_codeCompleteAt()`.
public struct CodeCompleteFlags: OptionSet, Sendable {
  public typealias RawValue = CXCodeComplete_Flags.RawValue
  public let rawValue: RawValue

  public init(rawValue: RawValue) {
    self.rawValue = rawValue
  }

  /// Whether to include macros within the set of code completions returned.
  public static let includeMacros = CodeCompleteFlags(rawValue: CXCodeComplete_IncludeMacros.rawValue)

  /// Whether to include code patterns for language constructs within the set of
  /// code completions, e.g., for loops.
  public static let includeCodePatterns = CodeCompleteFlags(rawValue: CXCodeComplete_IncludeCodePatterns.rawValue)

  /// Whether to include brief documentation within the set of code completions
  /// returned.
  public static let includeBriefComments = CodeCompleteFlags(rawValue: CXCodeComplete_IncludeBriefComments.rawValue)

  /// Whether to speed up completion by omitting top- or namespace-level
  /// entities defined in the preamble. There's no guarantee any particular
  /// entity is omitted. This may be useful if the headers are indexed
  /// externally.
  public static let skipPreamble = CodeCompleteFlags(rawValue: CXCodeComplete_SkipPreamble.rawValue)

  /// Whether to include completions with small fix-its, e.g. change '.' to '->'
  /// on member access, etc.
  public static let includeCompletionsWithFixIts = CodeCompleteFlags(rawValue: CXCodeComplete_IncludeCompletionsWithFixIts.rawValue)
}

/// Bits that represent the context under which completion is occurring.
///
/// The enumerators in this enumeration may be bitwise-OR'd together if
/// multiple contexts are occurring simultaneously.
public struct CompletionContext: OptionSet, Sendable {
  public typealias RawValue = CXCompletionContext.RawValue
  public let rawValue: RawValue

  public init(rawValue: RawValue) {
    self.rawValue = rawValue
  }

  /// The context for completions is unexposed, as only Clang results should be
  /// included. (This is equivalent to having no context bits set.)
  public static let unexposed = CompletionContext(rawValue: CXCompletionContext_Unexposed.rawValue)

  /// Completions for any possible type should be included in the results.
  public static let anyType = CompletionContext(rawValue: CXCompletionContext_AnyType.rawValue)

  /// Completions for any possible value (variables, function calls, etc.)
  /// should be included in the results.
  public static let anyValue = CompletionContext(rawValue: CXCompletionContext_AnyValue.rawValue)

  /// Completions for values that resolve to an Objective-C object should be
  /// included in the results.
  public static let objcObjectValue = CompletionContext(rawValue: CXCompletionContext_ObjCObjectValue.rawValue)

  /// Completions for values that resolve to an Objective-C selector should be
  /// included in the results.
  public static let objcSelectorValue = CompletionContext(rawValue: CXCompletionContext_ObjCSelectorValue.rawValue)

  /// Completions for values that resolve to a C++ class type should be
  /// included in the results.
  public static let cxxClassTypeValue = CompletionContext(rawValue: CXCompletionContext_CXXClassTypeValue.rawValue)

  /// Completions for fields of the member being accessed using the dot operator
  /// should be included in the results.
  public static let dotMemberAccess = CompletionContext(rawValue: CXCompletionContext_DotMemberAccess.rawValue)

  /// Completions for fields of the member being accessed using the arrow
  /// operator should be included in the results.
  public static let arrowMemberAccess = CompletionContext(rawValue: CXCompletionContext_ArrowMemberAccess.rawValue)

  /// Completions for properties of the Objective-C object being accessed using
  /// the dot operator should be included in the results.
  public static let objcPropertyAccess = CompletionContext(rawValue: CXCompletionContext_ObjCPropertyAccess.rawValue)

  /// Completions for enum tags should be included in the results.
  public static let enumTag = CompletionContext(rawValue: CXCompletionContext_EnumTag.rawValue)

  /// Completions for union tags should be included in the results.
  public static let unionTag = CompletionContext(rawValue: CXCompletionContext_UnionTag.rawValue)

  /// Completions for struct tags should be included in the results.
  public static let structTag = CompletionContext(rawValue: CXCompletionContext_StructTag.rawValue)

  /// Completions for C++ class names should be included in the results.
  public static let classTag = CompletionContext(rawValue: CXCompletionContext_ClassTag.rawValue)

  /// Completions for C++ namespaces and namespace aliases should be included in
  /// the results.
  public static let namespace = CompletionContext(rawValue: CXCompletionContext_Namespace.rawValue)

  /// Completions for C++ nested name specifiers should be included in the
  /// results.
  public static let nestedNameSpecifier = CompletionContext(rawValue: CXCompletionContext_NestedNameSpecifier.rawValue)

  /// Completions for Objective-C interfaces (classes) should be included in the
  /// results.
  public static let objcInterface = CompletionContext(rawValue: CXCompletionContext_ObjCInterface.rawValue)

  /// Completions for Objective-C protocols should be included in the results.
  public static let objcProtocol = CompletionContext(rawValue: CXCompletionContext_ObjCProtocol.rawValue)

  /// Completions for Objective-C categories should be included in the results.
  public static let objcCategory = CompletionContext(rawValue: CXCompletionContext_ObjCCategory.rawValue)

  /// Completions for Objective-C instance messages should be included in the
  /// results.
  public static let objcInstanceMessage = CompletionContext(rawValue: CXCompletionContext_ObjCInstanceMessage.rawValue)

  /// Completions for Objective-C class messages should be included in the
  /// results.
  public static let objcClassMessage = CompletionContext(rawValue: CXCompletionContext_ObjCClassMessage.rawValue)

  /// Completions for Objective-C selector names should be included in the
  /// results.
  public static let objcSelectorName = CompletionContext(rawValue: CXCompletionContext_ObjCSelectorName.rawValue)

  /// Completions for preprocessor macro names should be included in the
  /// results.
  public static let macroName = CompletionContext(rawValue: CXCompletionContext_MacroName.rawValue)

  /// Natural language completions should be included in the results.
  public static let naturalLanguage = CompletionContext(rawValue: CXCompletionContext_NaturalLanguage.rawValue)

  /// `#include` file completions should be included in the results.
  public static let includedFile = CompletionContext(rawValue: CXCompletionContext_IncludedFile.rawValue)

  /// The current context is unknown, so set all contexts.
  public static let unknown = CompletionContext(rawValue: CXCompletionContext_Unknown.rawValue)
}
