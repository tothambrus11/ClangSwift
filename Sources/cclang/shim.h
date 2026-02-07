#include <clang-c/Platform.h>

#ifdef I // For some reason this is defined
#undef I
#endif

#include <clang-c/Index.h>
#include <clang-c/CXDiagnostic.h>
#include <clang-c/CXFile.h>
#include <clang-c/CXSourceLocation.h>
#include <clang-c/BuildSystem.h>
#include <clang-c/CXErrorCode.h>
#include <clang-c/Documentation.h>
#include <clang-c/CXCompilationDatabase.h>
#include <clang-c/CXString.h>
#include <clang-c/FatalErrorHandler.h>
#include <clang-c/Rewrite.h>
