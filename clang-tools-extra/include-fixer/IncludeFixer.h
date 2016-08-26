//===-- IncludeFixer.h - Include inserter -----------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_CLANG_TOOLS_EXTRA_INCLUDE_FIXER_INCLUDEFIXER_H
#define LLVM_CLANG_TOOLS_EXTRA_INCLUDE_FIXER_INCLUDEFIXER_H

#include "IncludeFixerContext.h"
#include "SymbolIndexManager.h"
#include "clang/Format/Format.h"
#include "clang/Tooling/Core/Replacement.h"
#include "clang/Tooling/Tooling.h"
#include <memory>
#include <vector>

namespace clang {

class CompilerInvocation;
class DiagnosticConsumer;
class FileManager;
class PCHContainerOperations;

namespace include_fixer {

class IncludeFixerActionFactory : public clang::tooling::ToolAction {
public:
  /// \param SymbolIndexMgr A source for matching symbols to header files.
  /// \param Contexts The contexts for the symbols being queried.
  /// \param StyleName Fallback style for reformatting.
  /// \param MinimizeIncludePaths whether inserted include paths are optimized.
  IncludeFixerActionFactory(SymbolIndexManager &SymbolIndexMgr,
                            std::vector<IncludeFixerContext> &Contexts,
                            StringRef StyleName,
                            bool MinimizeIncludePaths = true);

  ~IncludeFixerActionFactory() override;

  bool
  runInvocation(clang::CompilerInvocation *Invocation,
                clang::FileManager *Files,
                std::shared_ptr<clang::PCHContainerOperations> PCHContainerOps,
                clang::DiagnosticConsumer *Diagnostics) override;

private:
  /// The client to use to find cross-references.
  SymbolIndexManager &SymbolIndexMgr;

  /// Multiple contexts for files being processed.
  std::vector<IncludeFixerContext> &Contexts;

  /// Whether inserted include paths should be optimized.
  bool MinimizeIncludePaths;

  /// The fallback format style for formatting after insertion if no
  /// clang-format config file was found.
  std::string FallbackStyle;
};

/// Create replacements, which are generated by clang-format, for the
/// missing header and mising qualifiers insertions. The function uses the
/// first header for insertion.
///
/// \param Code The source code.
/// \param Context The context which contains all information for creating
/// include-fixer replacements.
/// \param Style clang-format style being used.
/// \param AddQualifiers  Whether we should add qualifiers to all instances of
/// an unidentified symbol.
///
/// \return Formatted replacements for inserting, sorting headers and adding
/// qualifiers on success; otherwise, an llvm::Error carrying llvm::StringError
/// is returned.
llvm::Expected<tooling::Replacements> createIncludeFixerReplacements(
    StringRef Code, const IncludeFixerContext &Context,
    const format::FormatStyle &Style = format::getLLVMStyle(),
    bool AddQualifiers = true);

} // namespace include_fixer
} // namespace clang

#endif // LLVM_CLANG_TOOLS_EXTRA_INCLUDE_FIXER_INCLUDEFIXER_H
