import cclang

public enum IdxEntityKind {
  case unexposed
  case `typedef`
  case function
  case variable
  case field
  case enumConstant
  case objcClass
  case objcProtocol
  case objcCategory
  case objcInstanceMethod
  case objcClassMethod
  case objcProperty
  case objcIvar
  case `enum`
  case `struct`
  case union
  case cxxClass
  case cxxNamespace
  case cxxNamespaceAlias
  case cxxStaticVariable
  case cxxStaticMethod
  case cxxInstanceMethod
  case cxxConstructor
  case cxxDestructor
  case cxxConversionFunction
  case cxxTypeAlias
  case cxxInterface
  case cxxConcept

  internal init?(clang: CXIdxEntityKind) {
    switch clang {
    case CXIdxEntity_Unexposed: self = .unexposed
    case CXIdxEntity_Typedef: self = .typedef
    case CXIdxEntity_Function: self = .function
    case CXIdxEntity_Variable: self = .variable
    case CXIdxEntity_Field: self = .field
    case CXIdxEntity_EnumConstant: self = .enumConstant
    case CXIdxEntity_ObjCClass: self = .objcClass
    case CXIdxEntity_ObjCProtocol: self = .objcProtocol
    case CXIdxEntity_ObjCCategory: self = .objcCategory
    case CXIdxEntity_ObjCInstanceMethod: self = .objcInstanceMethod
    case CXIdxEntity_ObjCClassMethod: self = .objcClassMethod
    case CXIdxEntity_ObjCProperty: self = .objcProperty
    case CXIdxEntity_ObjCIvar: self = .objcIvar
    case CXIdxEntity_Enum: self = .enum
    case CXIdxEntity_Struct: self = .struct
    case CXIdxEntity_Union: self = .union
    case CXIdxEntity_CXXClass: self = .cxxClass
    case CXIdxEntity_CXXNamespace: self = .cxxNamespace
    case CXIdxEntity_CXXNamespaceAlias: self = .cxxNamespaceAlias
    case CXIdxEntity_CXXStaticVariable: self = .cxxStaticVariable
    case CXIdxEntity_CXXStaticMethod: self = .cxxStaticMethod
    case CXIdxEntity_CXXInstanceMethod: self = .cxxInstanceMethod
    case CXIdxEntity_CXXConstructor: self = .cxxConstructor
    case CXIdxEntity_CXXDestructor: self = .cxxDestructor
    case CXIdxEntity_CXXConversionFunction: self = .cxxConversionFunction
    case CXIdxEntity_CXXTypeAlias: self = .cxxTypeAlias
    case CXIdxEntity_CXXInterface: self = .cxxInterface
    case CXIdxEntity_CXXConcept: self = .cxxConcept
    default: return nil
    }
  }
}

public enum IdxEntityLanguage {
  case none
  case c
  case objectiveC
  case cxx
  case swift

  internal init?(clang: CXIdxEntityLanguage) {
    switch clang {
    case CXIdxEntityLang_None: self = .none
    case CXIdxEntityLang_C: self = .c
    case CXIdxEntityLang_ObjC: self = .objectiveC
    case CXIdxEntityLang_CXX: self = .cxx
    case CXIdxEntityLang_Swift: self = .swift
    default: return nil
    }
  }
}

/// Extra C++ template information for an entity.
public enum IdxEntityCXXTemplateKind {
  case nonTemplate
  case template
  case templatePartialSpecialization
  case templateSpecialization

  internal init?(clang: CXIdxEntityCXXTemplateKind) {
    switch clang {
    case CXIdxEntity_NonTemplate: self = .nonTemplate
    case CXIdxEntity_Template: self = .template
    case CXIdxEntity_TemplatePartialSpecialization: self = .templatePartialSpecialization
    case CXIdxEntity_TemplateSpecialization: self = .templateSpecialization
    default: return nil
    }
  }
}

public enum IdxAttrKind {
  case unexposed
  case ibAction
  case ibOutlet
  case ibOutletCollection

  internal init?(clang: CXIdxAttrKind) {
    switch clang {
    case CXIdxAttr_Unexposed: self = .unexposed
    case CXIdxAttr_IBAction: self = .ibAction
    case CXIdxAttr_IBOutlet: self = .ibOutlet
    case CXIdxAttr_IBOutletCollection: self = .ibOutletCollection
    default: return nil
    }
  }
}

public struct IdxDeclInfoFlags: OptionSet, Sendable {
  public typealias RawValue = CXIdxDeclInfoFlags.RawValue
  public let rawValue: RawValue

  public init(rawValue: RawValue) {
    self.rawValue = rawValue
  }

  public static let skipped = IdxDeclInfoFlags(rawValue: CXIdxDeclFlag_Skipped.rawValue)
}

public enum IdxObjCContainerKind {
  case forwardRef
  case `interface`
  case implementation

  internal init?(clang: CXIdxObjCContainerKind) {
    switch clang {
    case CXIdxObjCContainer_ForwardRef: self = .forwardRef
    case CXIdxObjCContainer_Interface: self = .interface
    case CXIdxObjCContainer_Implementation: self = .implementation
    default: return nil
    }
  }
}

/// Data for IndexerCallbacks#indexEntityReference.
///
/// This may be deprecated in a future version as this duplicates the
/// `CXSymbolRole_Implicit` bit in `CXSymbolRole`.
public enum IdxEntityRefKind {
  /// The entity is referenced directly in user's code.
  case direct

  /// An implicit reference, e.g. a reference of an Objective-C method
  /// via the dot syntax.
  case implicit

  internal init?(clang: CXIdxEntityRefKind) {
    switch clang {
    case CXIdxEntityRef_Direct: self = .direct
    case CXIdxEntityRef_Implicit: self = .implicit
    default: return nil
    }
  }
}
