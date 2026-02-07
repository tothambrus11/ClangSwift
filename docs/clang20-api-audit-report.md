# Clang 20 API vs Swift wrapper audit

- Shim: `Sources/cclang/shim.h`
- LLVM include: `/usr/lib/llvm-20/include`
- clang-c headers included by shim: 12
- clang-c headers parsed: 12

## Enum coverage summary (heuristic)

For each C enum found in the shim-included headers, this checks whether each member identifier is referenced anywhere in `Sources/Clang`. Missing references usually imply missing wrapper mapping or missing OptionSet constants.

### Key enums

- `CXCursorKind`: present 203/304 (missing 101)
- `CXTypeKind`: present 128/128 (missing 0)
- `CXTokenKind`: present 5/5 (missing 0)
- `CXCallingConv`: present 25/25 (missing 0)
- `CXLanguageKind`: present 4/4 (missing 0)
- `CXDiagnosticSeverity`: present 5/5 (missing 0)
- `CXLoadDiag_Error`: present 4/4 (missing 0)
- `CXTemplateArgumentKind`: present 10/10 (missing 0)
- `CXVisibilityKind`: present 4/4 (missing 0)
- `CX_StorageClass`: present 8/8 (missing 0)

### Enums with missing members

#### `CX_BinaryOperatorKind`

- Total: 35, referenced: 0, missing: 35
- Missing member identifiers (not referenced in Swift):

  - `CX_BO_Invalid`
  - `CX_BO_PtrMemD`
  - `CX_BO_PtrMemI`
  - `CX_BO_Mul`
  - `CX_BO_Div`
  - `CX_BO_Rem`
  - `CX_BO_Add`
  - `CX_BO_Sub`
  - `CX_BO_Shl`
  - `CX_BO_Shr`
  - `CX_BO_Cmp`
  - `CX_BO_LT`
  - `CX_BO_GT`
  - `CX_BO_LE`
  - `CX_BO_GE`
  - `CX_BO_EQ`
  - `CX_BO_NE`
  - `CX_BO_And`
  - `CX_BO_Xor`
  - `CX_BO_Or`
  - `CX_BO_LAnd`
  - `CX_BO_LOr`
  - `CX_BO_Assign`
  - `CX_BO_MulAssign`
  - `CX_BO_DivAssign`
  - `CX_BO_RemAssign`
  - `CX_BO_AddAssign`
  - `CX_BO_SubAssign`
  - `CX_BO_ShlAssign`
  - `CX_BO_ShrAssign`
  - `CX_BO_AndAssign`
  - `CX_BO_XorAssign`
  - `CX_BO_OrAssign`
  - `CX_BO_Comma`
  - `CX_BO_LAST`

#### `CXBinaryOperatorKind`

- Total: 34, referenced: 0, missing: 34
- Missing member identifiers (not referenced in Swift):

  - `CXBinaryOperator_Invalid`
  - `CXBinaryOperator_PtrMemD`
  - `CXBinaryOperator_PtrMemI`
  - `CXBinaryOperator_Mul`
  - `CXBinaryOperator_Div`
  - `CXBinaryOperator_Rem`
  - `CXBinaryOperator_Add`
  - `CXBinaryOperator_Sub`
  - `CXBinaryOperator_Shl`
  - `CXBinaryOperator_Shr`
  - `CXBinaryOperator_Cmp`
  - `CXBinaryOperator_LT`
  - `CXBinaryOperator_GT`
  - `CXBinaryOperator_LE`
  - `CXBinaryOperator_GE`
  - `CXBinaryOperator_EQ`
  - `CXBinaryOperator_NE`
  - `CXBinaryOperator_And`
  - `CXBinaryOperator_Xor`
  - `CXBinaryOperator_Or`
  - `CXBinaryOperator_LAnd`
  - `CXBinaryOperator_LOr`
  - `CXBinaryOperator_Assign`
  - `CXBinaryOperator_MulAssign`
  - `CXBinaryOperator_DivAssign`
  - `CXBinaryOperator_RemAssign`
  - `CXBinaryOperator_AddAssign`
  - `CXBinaryOperator_SubAssign`
  - `CXBinaryOperator_ShlAssign`
  - `CXBinaryOperator_ShrAssign`
  - `CXBinaryOperator_AndAssign`
  - `CXBinaryOperator_XorAssign`
  - `CXBinaryOperator_OrAssign`
  - `CXBinaryOperator_Comma`

#### `CXChoice`

- Total: 3, referenced: 0, missing: 3
- Missing member identifiers (not referenced in Swift):

  - `CXChoice_Default`
  - `CXChoice_Enabled`
  - `CXChoice_Disabled`

#### `CXCodeComplete_Flags`

- Total: 5, referenced: 0, missing: 5
- Missing member identifiers (not referenced in Swift):

  - `CXCodeComplete_IncludeMacros`
  - `CXCodeComplete_IncludeCodePatterns`
  - `CXCodeComplete_IncludeBriefComments`
  - `CXCodeComplete_SkipPreamble`
  - `CXCodeComplete_IncludeCompletionsWithFixIts`

#### `CXCommentInlineCommandRenderKind`

- Total: 5, referenced: 0, missing: 5
- Missing member identifiers (not referenced in Swift):

  - `CXCommentInlineCommandRenderKind_Normal`
  - `CXCommentInlineCommandRenderKind_Bold`
  - `CXCommentInlineCommandRenderKind_Monospaced`
  - `CXCommentInlineCommandRenderKind_Emphasized`
  - `CXCommentInlineCommandRenderKind_Anchor`

#### `CXCompilationDatabase_Error`

- Total: 2, referenced: 0, missing: 2
- Missing member identifiers (not referenced in Swift):

  - `CXCompilationDatabase_NoError`
  - `CXCompilationDatabase_CanNotLoadDatabase`

#### `CXCompletionChunkKind`

- Total: 21, referenced: 0, missing: 21
- Missing member identifiers (not referenced in Swift):

  - `CXCompletionChunk_Optional`
  - `CXCompletionChunk_TypedText`
  - `CXCompletionChunk_Text`
  - `CXCompletionChunk_Placeholder`
  - `CXCompletionChunk_Informative`
  - `CXCompletionChunk_CurrentParameter`
  - `CXCompletionChunk_LeftParen`
  - `CXCompletionChunk_RightParen`
  - `CXCompletionChunk_LeftBracket`
  - `CXCompletionChunk_RightBracket`
  - `CXCompletionChunk_LeftBrace`
  - `CXCompletionChunk_RightBrace`
  - `CXCompletionChunk_LeftAngle`
  - `CXCompletionChunk_RightAngle`
  - `CXCompletionChunk_Comma`
  - `CXCompletionChunk_ResultType`
  - `CXCompletionChunk_Colon`
  - `CXCompletionChunk_SemiColon`
  - `CXCompletionChunk_Equal`
  - `CXCompletionChunk_HorizontalSpace`
  - `CXCompletionChunk_VerticalSpace`

#### `CXCompletionContext`

- Total: 25, referenced: 0, missing: 25
- Missing member identifiers (not referenced in Swift):

  - `CXCompletionContext_Unexposed`
  - `CXCompletionContext_AnyType`
  - `CXCompletionContext_AnyValue`
  - `CXCompletionContext_ObjCObjectValue`
  - `CXCompletionContext_ObjCSelectorValue`
  - `CXCompletionContext_CXXClassTypeValue`
  - `CXCompletionContext_DotMemberAccess`
  - `CXCompletionContext_ArrowMemberAccess`
  - `CXCompletionContext_ObjCPropertyAccess`
  - `CXCompletionContext_EnumTag`
  - `CXCompletionContext_UnionTag`
  - `CXCompletionContext_StructTag`
  - `CXCompletionContext_ClassTag`
  - `CXCompletionContext_Namespace`
  - `CXCompletionContext_NestedNameSpecifier`
  - `CXCompletionContext_ObjCInterface`
  - `CXCompletionContext_ObjCProtocol`
  - `CXCompletionContext_ObjCCategory`
  - `CXCompletionContext_ObjCInstanceMessage`
  - `CXCompletionContext_ObjCClassMessage`
  - `CXCompletionContext_ObjCSelectorName`
  - `CXCompletionContext_MacroName`
  - `CXCompletionContext_NaturalLanguage`
  - `CXCompletionContext_IncludedFile`
  - `CXCompletionContext_Unknown`

#### `CXCursor_ExceptionSpecificationKind`

- Total: 10, referenced: 0, missing: 10
- Missing member identifiers (not referenced in Swift):

  - `CXCursor_ExceptionSpecificationKind_None`
  - `CXCursor_ExceptionSpecificationKind_DynamicNone`
  - `CXCursor_ExceptionSpecificationKind_Dynamic`
  - `CXCursor_ExceptionSpecificationKind_MSAny`
  - `CXCursor_ExceptionSpecificationKind_BasicNoexcept`
  - `CXCursor_ExceptionSpecificationKind_ComputedNoexcept`
  - `CXCursor_ExceptionSpecificationKind_Unevaluated`
  - `CXCursor_ExceptionSpecificationKind_Uninstantiated`
  - `CXCursor_ExceptionSpecificationKind_Unparsed`
  - `CXCursor_ExceptionSpecificationKind_NoThrow`

#### `CXCursorKind`

- Total: 304, referenced: 203, missing: 101
- Missing member identifiers (not referenced in Swift):

  - `CXCursor_FirstDecl`
  - `CXCursor_LastDecl`
  - `CXCursor_FirstRef`
  - `CXCursor_LastRef`
  - `CXCursor_FirstInvalid`
  - `CXCursor_LastInvalid`
  - `CXCursor_FirstExpr`
  - `CXCursor_ArraySectionExpr`
  - `CXCursor_FixedPointLiteral`
  - `CXCursor_OMPArrayShapingExpr`
  - `CXCursor_OMPIteratorExpr`
  - `CXCursor_CXXAddrspaceCastExpr`
  - `CXCursor_ConceptSpecializationExpr`
  - `CXCursor_RequiresExpr`
  - `CXCursor_CXXParenListInitExpr`
  - `CXCursor_PackIndexingExpr`
  - `CXCursor_LastExpr`
  - `CXCursor_FirstStmt`
  - `CXCursor_OMPTargetSimdDirective`
  - `CXCursor_OMPTeamsDistributeDirective`
  - `CXCursor_OMPTeamsDistributeSimdDirective`
  - `CXCursor_OMPTeamsDistributeParallelForSimdDirective`
  - `CXCursor_OMPTeamsDistributeParallelForDirective`
  - `CXCursor_OMPTargetTeamsDirective`
  - `CXCursor_OMPTargetTeamsDistributeDirective`
  - `CXCursor_OMPTargetTeamsDistributeParallelForDirective`
  - `CXCursor_OMPTargetTeamsDistributeParallelForSimdDirective`
  - `CXCursor_OMPTargetTeamsDistributeSimdDirective`
  - `CXCursor_BuiltinBitCastExpr`
  - `CXCursor_OMPMasterTaskLoopDirective`
  - `CXCursor_OMPParallelMasterTaskLoopDirective`
  - `CXCursor_OMPMasterTaskLoopSimdDirective`
  - `CXCursor_OMPParallelMasterTaskLoopSimdDirective`
  - `CXCursor_OMPParallelMasterDirective`
  - `CXCursor_OMPDepobjDirective`
  - `CXCursor_OMPScanDirective`
  - `CXCursor_OMPTileDirective`
  - `CXCursor_OMPCanonicalLoop`
  - `CXCursor_OMPInteropDirective`
  - `CXCursor_OMPDispatchDirective`
  - `CXCursor_OMPMaskedDirective`
  - `CXCursor_OMPUnrollDirective`
  - `CXCursor_OMPMetaDirective`
  - `CXCursor_OMPGenericLoopDirective`
  - `CXCursor_OMPTeamsGenericLoopDirective`
  - `CXCursor_OMPTargetTeamsGenericLoopDirective`
  - `CXCursor_OMPParallelGenericLoopDirective`
  - `CXCursor_OMPTargetParallelGenericLoopDirective`
  - `CXCursor_OMPParallelMaskedDirective`
  - `CXCursor_OMPMaskedTaskLoopDirective`
  - `CXCursor_OMPMaskedTaskLoopSimdDirective`
  - `CXCursor_OMPParallelMaskedTaskLoopDirective`
  - `CXCursor_OMPParallelMaskedTaskLoopSimdDirective`
  - `CXCursor_OMPErrorDirective`
  - `CXCursor_OMPScopeDirective`
  - `CXCursor_OMPReverseDirective`
  - `CXCursor_OMPInterchangeDirective`
  - `CXCursor_OMPAssumeDirective`
  - `CXCursor_OpenACCComputeConstruct`
  - `CXCursor_OpenACCLoopConstruct`
  - `CXCursor_OpenACCCombinedConstruct`
  - `CXCursor_OpenACCDataConstruct`
  - `CXCursor_OpenACCEnterDataConstruct`
  - `CXCursor_OpenACCExitDataConstruct`
  - `CXCursor_OpenACCHostDataConstruct`
  - `CXCursor_OpenACCWaitConstruct`
  - `CXCursor_OpenACCInitConstruct`
  - `CXCursor_OpenACCShutdownConstruct`
  - `CXCursor_OpenACCSetConstruct`
  - `CXCursor_OpenACCUpdateConstruct`
  - `CXCursor_LastStmt`
  - `CXCursor_FirstAttr`
  - `CXCursor_NSReturnsRetained`
  - `CXCursor_NSReturnsNotRetained`
  - `CXCursor_NSReturnsAutoreleased`
  - `CXCursor_NSConsumesSelf`
  - `CXCursor_NSConsumed`
  - `CXCursor_ObjCException`
  - `CXCursor_ObjCNSObject`
  - `CXCursor_ObjCIndependentClass`
  - `CXCursor_ObjCPreciseLifetime`
  - `CXCursor_ObjCReturnsInnerPointer`
  - `CXCursor_ObjCRequiresSuper`
  - `CXCursor_ObjCRootClass`
  - `CXCursor_ObjCSubclassingRestricted`
  - `CXCursor_ObjCExplicitProtocolImpl`
  - `CXCursor_ObjCDesignatedInitializer`
  - `CXCursor_ObjCRuntimeVisible`
  - `CXCursor_ObjCBoxable`
  - `CXCursor_FlagEnum`
  - `CXCursor_ConvergentAttr`
  - `CXCursor_WarnUnusedAttr`
  - `CXCursor_WarnUnusedResultAttr`
  - `CXCursor_AlignedAttr`
  - `CXCursor_LastAttr`
  - `CXCursor_FirstPreprocessing`
  - `CXCursor_LastPreprocessing`
  - `CXCursor_FriendDecl`
  - `CXCursor_ConceptDecl`
  - `CXCursor_FirstExtraDecl`
  - `CXCursor_LastExtraDecl`

#### `CXIdxAttrKind`

- Total: 4, referenced: 0, missing: 4
- Missing member identifiers (not referenced in Swift):

  - `CXIdxAttr_Unexposed`
  - `CXIdxAttr_IBAction`
  - `CXIdxAttr_IBOutlet`
  - `CXIdxAttr_IBOutletCollection`

#### `CXIdxDeclInfoFlags`

- Total: 1, referenced: 0, missing: 1
- Missing member identifiers (not referenced in Swift):

  - `CXIdxDeclFlag_Skipped`

#### `CXIdxEntityCXXTemplateKind`

- Total: 4, referenced: 0, missing: 4
- Missing member identifiers (not referenced in Swift):

  - `CXIdxEntity_NonTemplate`
  - `CXIdxEntity_Template`
  - `CXIdxEntity_TemplatePartialSpecialization`
  - `CXIdxEntity_TemplateSpecialization`

#### `CXIdxEntityKind`

- Total: 28, referenced: 0, missing: 28
- Missing member identifiers (not referenced in Swift):

  - `CXIdxEntity_Unexposed`
  - `CXIdxEntity_Typedef`
  - `CXIdxEntity_Function`
  - `CXIdxEntity_Variable`
  - `CXIdxEntity_Field`
  - `CXIdxEntity_EnumConstant`
  - `CXIdxEntity_ObjCClass`
  - `CXIdxEntity_ObjCProtocol`
  - `CXIdxEntity_ObjCCategory`
  - `CXIdxEntity_ObjCInstanceMethod`
  - `CXIdxEntity_ObjCClassMethod`
  - `CXIdxEntity_ObjCProperty`
  - `CXIdxEntity_ObjCIvar`
  - `CXIdxEntity_Enum`
  - `CXIdxEntity_Struct`
  - `CXIdxEntity_Union`
  - `CXIdxEntity_CXXClass`
  - `CXIdxEntity_CXXNamespace`
  - `CXIdxEntity_CXXNamespaceAlias`
  - `CXIdxEntity_CXXStaticVariable`
  - `CXIdxEntity_CXXStaticMethod`
  - `CXIdxEntity_CXXInstanceMethod`
  - `CXIdxEntity_CXXConstructor`
  - `CXIdxEntity_CXXDestructor`
  - `CXIdxEntity_CXXConversionFunction`
  - `CXIdxEntity_CXXTypeAlias`
  - `CXIdxEntity_CXXInterface`
  - `CXIdxEntity_CXXConcept`

#### `CXIdxEntityLanguage`

- Total: 5, referenced: 0, missing: 5
- Missing member identifiers (not referenced in Swift):

  - `CXIdxEntityLang_None`
  - `CXIdxEntityLang_C`
  - `CXIdxEntityLang_ObjC`
  - `CXIdxEntityLang_CXX`
  - `CXIdxEntityLang_Swift`

#### `CXIdxEntityRefKind`

- Total: 2, referenced: 0, missing: 2
- Missing member identifiers (not referenced in Swift):

  - `CXIdxEntityRef_Direct`
  - `CXIdxEntityRef_Implicit`

#### `CXIdxObjCContainerKind`

- Total: 3, referenced: 0, missing: 3
- Missing member identifiers (not referenced in Swift):

  - `CXIdxObjCContainer_ForwardRef`
  - `CXIdxObjCContainer_Interface`
  - `CXIdxObjCContainer_Implementation`

#### `CXObjCDeclQualifierKind`

- Total: 7, referenced: 0, missing: 7
- Missing member identifiers (not referenced in Swift):

  - `CXObjCDeclQualifier_None`
  - `CXObjCDeclQualifier_In`
  - `CXObjCDeclQualifier_Inout`
  - `CXObjCDeclQualifier_Out`
  - `CXObjCDeclQualifier_Bycopy`
  - `CXObjCDeclQualifier_Byref`
  - `CXObjCDeclQualifier_Oneway`

#### `CXPrintingPolicyProperty`

- Total: 27, referenced: 0, missing: 27
- Missing member identifiers (not referenced in Swift):

  - `CXPrintingPolicy_Indentation`
  - `CXPrintingPolicy_SuppressSpecifiers`
  - `CXPrintingPolicy_SuppressTagKeyword`
  - `CXPrintingPolicy_IncludeTagDefinition`
  - `CXPrintingPolicy_SuppressScope`
  - `CXPrintingPolicy_SuppressUnwrittenScope`
  - `CXPrintingPolicy_SuppressInitializers`
  - `CXPrintingPolicy_ConstantArraySizeAsWritten`
  - `CXPrintingPolicy_AnonymousTagLocations`
  - `CXPrintingPolicy_SuppressStrongLifetime`
  - `CXPrintingPolicy_SuppressLifetimeQualifiers`
  - `CXPrintingPolicy_SuppressTemplateArgsInCXXConstructors`
  - `CXPrintingPolicy_Bool`
  - `CXPrintingPolicy_Restrict`
  - `CXPrintingPolicy_Alignof`
  - `CXPrintingPolicy_UnderscoreAlignof`
  - `CXPrintingPolicy_UseVoidForZeroParams`
  - `CXPrintingPolicy_TerseOutput`
  - `CXPrintingPolicy_PolishForDeclaration`
  - `CXPrintingPolicy_Half`
  - `CXPrintingPolicy_MSWChar`
  - `CXPrintingPolicy_IncludeNewlines`
  - `CXPrintingPolicy_MSVCFormatting`
  - `CXPrintingPolicy_ConstantsAsWritten`
  - `CXPrintingPolicy_SuppressImplicitBase`
  - `CXPrintingPolicy_FullyQualifiedName`
  - `CXPrintingPolicy_LastProperty`

#### `CXReparse_Flags`

- Total: 1, referenced: 0, missing: 1
- Missing member identifiers (not referenced in Swift):

  - `CXReparse_None`

#### `CXResult`

- Total: 3, referenced: 0, missing: 3
- Missing member identifiers (not referenced in Swift):

  - `CXResult_Success`
  - `CXResult_Invalid`
  - `CXResult_VisitBreak`

#### `CXSymbolRole`

- Total: 10, referenced: 0, missing: 10
- Missing member identifiers (not referenced in Swift):

  - `CXSymbolRole_None`
  - `CXSymbolRole_Declaration`
  - `CXSymbolRole_Definition`
  - `CXSymbolRole_Reference`
  - `CXSymbolRole_Read`
  - `CXSymbolRole_Write`
  - `CXSymbolRole_Call`
  - `CXSymbolRole_Dynamic`
  - `CXSymbolRole_AddressOf`
  - `CXSymbolRole_Implicit`

#### `CXTUResourceUsageKind`

- Total: 18, referenced: 0, missing: 18
- Missing member identifiers (not referenced in Swift):

  - `CXTUResourceUsage_AST`
  - `CXTUResourceUsage_Identifiers`
  - `CXTUResourceUsage_Selectors`
  - `CXTUResourceUsage_GlobalCompletionResults`
  - `CXTUResourceUsage_SourceManagerContentCache`
  - `CXTUResourceUsage_AST_SideTables`
  - `CXTUResourceUsage_SourceManager_Membuffer_Malloc`
  - `CXTUResourceUsage_SourceManager_Membuffer_MMap`
  - `CXTUResourceUsage_ExternalASTSource_Membuffer_Malloc`
  - `CXTUResourceUsage_ExternalASTSource_Membuffer_MMap`
  - `CXTUResourceUsage_Preprocessor`
  - `CXTUResourceUsage_PreprocessingRecord`
  - `CXTUResourceUsage_SourceManager_DataStructures`
  - `CXTUResourceUsage_Preprocessor_HeaderSearch`
  - `CXTUResourceUsage_MEMORY_IN_BYTES_BEGIN`
  - `CXTUResourceUsage_MEMORY_IN_BYTES_END`
  - `CXTUResourceUsage_First`
  - `CXTUResourceUsage_Last`

#### `CXUnaryOperatorKind`

- Total: 15, referenced: 0, missing: 15
- Missing member identifiers (not referenced in Swift):

  - `CXUnaryOperator_Invalid`
  - `CXUnaryOperator_PostInc`
  - `CXUnaryOperator_PostDec`
  - `CXUnaryOperator_PreInc`
  - `CXUnaryOperator_PreDec`
  - `CXUnaryOperator_AddrOf`
  - `CXUnaryOperator_Deref`
  - `CXUnaryOperator_Plus`
  - `CXUnaryOperator_Minus`
  - `CXUnaryOperator_Not`
  - `CXUnaryOperator_LNot`
  - `CXUnaryOperator_Real`
  - `CXUnaryOperator_Imag`
  - `CXUnaryOperator_Extension`
  - `CXUnaryOperator_Coawait`

## Notes

- This is a text-based audit. It can produce false positives (e.g. an enum member is intentionally not wrapped).
- Missing references in Swift are most serious for enums that are exhaustively switched over (cursor/type/token/convention).
- For OptionSets, missing members are usually safe but reduce discoverability.
