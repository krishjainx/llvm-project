// RUN: %clang_cc1 -D__ARM_FEATURE_SVE -triple aarch64-none-linux-gnu -target-feature +sve -fallow-half-arguments-and-returns -fsyntax-only -verify %s
// RUN: %clang_cc1 -D__ARM_FEATURE_SVE -DSVE_OVERLOADED_FORMS -triple aarch64-none-linux-gnu -target-feature +sve -fallow-half-arguments-and-returns -fsyntax-only -verify %s

#ifdef SVE_OVERLOADED_FORMS
// A simple used,unused... macro, long enough to represent any SVE builtin.
#define SVE_ACLE_FUNC(A1,A2_UNUSED,A3,A4_UNUSED) A1##A3
#else
#define SVE_ACLE_FUNC(A1,A2,A3,A4) A1##A2##A3##A4
#endif

#include <arm_sve.h>

svint8_t test_svasrd_n_s8_m(svbool_t pg, svint8_t op1)
{
  // expected-error-re@+1 {{argument value {{[0-9]+}} is outside the valid range [1, 8]}}
  return SVE_ACLE_FUNC(svasrd,_n_s8,_m,)(pg, op1, 0);
}

svint16_t test_svasrd_n_s16_m(svbool_t pg, svint16_t op1)
{
  // expected-error-re@+1 {{argument value {{[0-9]+}} is outside the valid range [1, 16]}}
  return SVE_ACLE_FUNC(svasrd,_n_s16,_m,)(pg, op1, 17);
}

svint32_t test_svasrd_n_s32_m(svbool_t pg, svint32_t op1)
{
  // expected-error-re@+1 {{argument value {{[0-9]+}} is outside the valid range [1, 32]}}
  return SVE_ACLE_FUNC(svasrd,_n_s32,_m,)(pg, op1, 0);
}

svint64_t test_svasrd_n_s64_m(svbool_t pg, svint64_t op1)
{
  // expected-error-re@+1 {{argument value {{[0-9]+}} is outside the valid range [1, 64]}}
  return SVE_ACLE_FUNC(svasrd,_n_s64,_m,)(pg, op1, 65);
}
