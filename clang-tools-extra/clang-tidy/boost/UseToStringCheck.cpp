//===--- UseToStringCheck.cpp - clang-tidy---------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "UseToStringCheck.h"

using namespace clang::ast_matchers;

namespace clang {
namespace tidy {
namespace boost {

AST_MATCHER(Type, isStrictlyInteger) {
  return Node.isIntegerType() && !Node.isAnyCharacterType() &&
         !Node.isBooleanType();
}

void UseToStringCheck::registerMatchers(MatchFinder *Finder) {
  if (!getLangOpts().CPlusPlus)
    return;

  Finder->addMatcher(
      callExpr(
          hasDeclaration(functionDecl(
              returns(hasDeclaration(classTemplateSpecializationDecl(
                  hasName("std::basic_string"),
                  hasTemplateArgument(0,
                                      templateArgument().bind("char_type"))))),
              hasName("boost::lexical_cast"),
              hasParameter(0, hasType(qualType(has(substTemplateTypeParmType(
                                  isStrictlyInteger()))))))),
          argumentCountIs(1), unless(isInTemplateInstantiation()))
          .bind("to_string"),
      this);
}

void UseToStringCheck::check(const MatchFinder::MatchResult &Result) {
  const auto *Call = Result.Nodes.getNodeAs<CallExpr>("to_string");
  auto CharType =
      Result.Nodes.getNodeAs<TemplateArgument>("char_type")->getAsType();

  StringRef StringType;
  if (CharType->isSpecificBuiltinType(BuiltinType::Char_S) ||
      CharType->isSpecificBuiltinType(BuiltinType::Char_U))
    StringType = "string";
  else if (CharType->isSpecificBuiltinType(BuiltinType::WChar_S) ||
           CharType->isSpecificBuiltinType(BuiltinType::WChar_U))
    StringType = "wstring";
  else
    return;

  auto Loc = Call->getLocStart();
  auto Diag =
      diag(Loc, "use std::to_%0 instead of boost::lexical_cast<std::%0>")
      << StringType;

  if (Loc.isMacroID())
    return;

  Diag << FixItHint::CreateReplacement(
      CharSourceRange::getCharRange(Call->getLocStart(),
                                    Call->getArg(0)->getExprLoc()),
      (llvm::Twine("std::to_") + StringType + "(").str());
}

} // namespace boost
} // namespace tidy
} // namespace clang
