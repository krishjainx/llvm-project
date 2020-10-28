; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -indvars %s | FileCheck %s
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128-ni:1"
target triple = "x86_64-unknown-linux-gnu"

define i32 @testDiv(i8* %p, i64* %p1) {
; CHECK-LABEL: @testDiv(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP1:%.*]]
; CHECK:       loop1:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[LOOP2_EXIT:%.*]] ], [ 8, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[EXITCOND3:%.*]] = icmp eq i64 [[INDVARS_IV]], 15
; CHECK-NEXT:    br i1 [[EXITCOND3]], label [[EXIT:%.*]], label [[GENERAL_CASE24:%.*]]
; CHECK:       general_case24:
; CHECK-NEXT:    br i1 false, label [[LOOP2_PREHEADER:%.*]], label [[LOOP2_EXIT]]
; CHECK:       loop2.preheader:
; CHECK-NEXT:    [[TMP0:%.*]] = udiv i64 14, [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP1:%.*]] = udiv i64 60392, [[TMP0]]
; CHECK-NEXT:    br label [[LOOP2:%.*]]
; CHECK:       loop2:
; CHECK-NEXT:    [[INDVARS_IV1:%.*]] = phi i64 [ [[TMP1]], [[LOOP2_PREHEADER]] ], [ [[INDVARS_IV_NEXT2:%.*]], [[LOOP2]] ]
; CHECK-NEXT:    [[LOCAL_2_57:%.*]] = phi i32 [ [[I7:%.*]], [[LOOP2]] ], [ 1, [[LOOP2_PREHEADER]] ]
; CHECK-NEXT:    [[INDVARS_IV_NEXT2]] = add nsw i64 [[INDVARS_IV1]], -1
; CHECK-NEXT:    [[I4:%.*]] = load atomic i64, i64* [[P1:%.*]] unordered, align 8
; CHECK-NEXT:    [[I6:%.*]] = sub i64 [[I4]], [[INDVARS_IV_NEXT2]]
; CHECK-NEXT:    store atomic i64 [[I6]], i64* [[P1]] unordered, align 8
; CHECK-NEXT:    [[I7]] = add nuw nsw i32 [[LOCAL_2_57]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[I7]], 9
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP2_EXIT_LOOPEXIT:%.*]], label [[LOOP2]]
; CHECK:       loop2.exit.loopexit:
; CHECK-NEXT:    br label [[LOOP2_EXIT]]
; CHECK:       loop2.exit:
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    br i1 false, label [[EXIT]], label [[LOOP1]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 0
;
entry:
  br label %loop1

loop1:                                            ; preds = %loop2.exit, %entry
  %local_0_ = phi i32 [ 8, %entry ], [ %i9, %loop2.exit ]
  %local_2_ = phi i32 [ 63864, %entry ], [ %local_2_43, %loop2.exit ]
  %local_3_ = phi i32 [ 51, %entry ], [ %local_3_44, %loop2.exit ]
  %i = udiv i32 14, %local_0_
  %i1 = icmp ugt i32 %local_0_, 14
  br i1 %i1, label %exit, label %general_case24

general_case24:                                   ; preds = %loop1
  %i2 = udiv i32 60392, %i
  br i1 false, label %loop2, label %loop2.exit

loop2:                                            ; preds = %loop2, %general_case24
  %local_1_56 = phi i32 [ %i2, %general_case24 ], [ %i3, %loop2 ]
  %local_2_57 = phi i32 [ 1, %general_case24 ], [ %i7, %loop2 ]
  %i3 = add i32 %local_1_56, -1
  %i4 = load atomic i64, i64* %p1 unordered, align 8
  %i5 = sext i32 %i3 to i64
  %i6 = sub i64 %i4, %i5
  store atomic i64 %i6, i64* %p1 unordered, align 8
  %i7 = add nuw nsw i32 %local_2_57, 1
  %i8 = icmp ugt i32 %local_2_57, 7
  br i1 %i8, label %loop2.exit, label %loop2

loop2.exit:                                       ; preds = %loop2, %general_case24
  %local_2_43 = phi i32 [ %local_2_, %general_case24 ], [ 9, %loop2 ]
  %local_3_44 = phi i32 [ %local_3_, %general_case24 ], [ %local_1_56, %loop2 ]
  %i9 = add nuw nsw i32 %local_0_, 1
  %i10 = icmp ugt i32 %local_0_, 129
  br i1 %i10, label %exit, label %loop1

exit:                                             ; preds = %loop2.exit, %loop1
  ret i32 0
}

define i32 @testRem(i8* %p, i64* %p1) {
; CHECK-LABEL: @testRem(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP1:%.*]]
; CHECK:       loop1:
; CHECK-NEXT:    [[LOCAL_0_:%.*]] = phi i32 [ 8, [[ENTRY:%.*]] ], [ [[I9:%.*]], [[LOOP2_EXIT:%.*]] ]
; CHECK-NEXT:    [[I:%.*]] = udiv i32 14, [[LOCAL_0_]]
; CHECK-NEXT:    [[EXITCOND1:%.*]] = icmp eq i32 [[LOCAL_0_]], 15
; CHECK-NEXT:    br i1 [[EXITCOND1]], label [[EXIT:%.*]], label [[GENERAL_CASE24:%.*]]
; CHECK:       general_case24:
; CHECK-NEXT:    [[I2:%.*]] = urem i32 60392, [[I]]
; CHECK-NEXT:    br i1 false, label [[LOOP2_PREHEADER:%.*]], label [[LOOP2_EXIT]]
; CHECK:       loop2.preheader:
; CHECK-NEXT:    [[TMP0:%.*]] = udiv i32 14, [[LOCAL_0_]]
; CHECK-NEXT:    [[TMP1:%.*]] = udiv i32 60392, [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = mul i32 [[TMP1]], -1
; CHECK-NEXT:    [[TMP3:%.*]] = mul i32 [[TMP2]], [[TMP0]]
; CHECK-NEXT:    [[TMP4:%.*]] = sext i32 [[TMP3]] to i64
; CHECK-NEXT:    [[TMP5:%.*]] = add nsw i64 [[TMP4]], 60392
; CHECK-NEXT:    br label [[LOOP2:%.*]]
; CHECK:       loop2:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[TMP5]], [[LOOP2_PREHEADER]] ], [ [[INDVARS_IV_NEXT:%.*]], [[LOOP2]] ]
; CHECK-NEXT:    [[LOCAL_1_56:%.*]] = phi i32 [ [[I3:%.*]], [[LOOP2]] ], [ [[I2]], [[LOOP2_PREHEADER]] ]
; CHECK-NEXT:    [[LOCAL_2_57:%.*]] = phi i32 [ [[I7:%.*]], [[LOOP2]] ], [ 1, [[LOOP2_PREHEADER]] ]
; CHECK-NEXT:    [[I3]] = add i32 [[LOCAL_1_56]], -1
; CHECK-NEXT:    [[I4:%.*]] = load atomic i64, i64* [[P1:%.*]] unordered, align 8
; CHECK-NEXT:    [[I5:%.*]] = sext i32 [[I3]] to i64
; CHECK-NEXT:    [[I6:%.*]] = sub i64 [[I4]], [[I5]]
; CHECK-NEXT:    store atomic i64 [[I6]], i64* [[P1]] unordered, align 8
; CHECK-NEXT:    [[I7]] = add nuw nsw i32 [[LOCAL_2_57]], 1
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add i64 [[INDVARS_IV]], -1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[I7]], 9
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP2_EXIT_LOOPEXIT:%.*]], label [[LOOP2]]
; CHECK:       loop2.exit.loopexit:
; CHECK-NEXT:    br label [[LOOP2_EXIT]]
; CHECK:       loop2.exit:
; CHECK-NEXT:    [[I9]] = add nuw nsw i32 [[LOCAL_0_]], 1
; CHECK-NEXT:    br i1 false, label [[EXIT]], label [[LOOP1]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 0
;
entry:
  br label %loop1

loop1:                                            ; preds = %loop2.exit, %entry
  %local_0_ = phi i32 [ 8, %entry ], [ %i9, %loop2.exit ]
  %local_2_ = phi i32 [ 63864, %entry ], [ %local_2_43, %loop2.exit ]
  %local_3_ = phi i32 [ 51, %entry ], [ %local_3_44, %loop2.exit ]
  %i = udiv i32 14, %local_0_
  %i1 = icmp ugt i32 %local_0_, 14
  br i1 %i1, label %exit, label %general_case24

general_case24:                                   ; preds = %loop1
  %i2 = urem i32 60392, %i
  br i1 false, label %loop2, label %loop2.exit

loop2:                                            ; preds = %loop2, %general_case24
  %local_1_56 = phi i32 [ %i2, %general_case24 ], [ %i3, %loop2 ]
  %local_2_57 = phi i32 [ 1, %general_case24 ], [ %i7, %loop2 ]
  %i3 = add i32 %local_1_56, -1
  %i4 = load atomic i64, i64* %p1 unordered, align 8
  %i5 = sext i32 %i3 to i64
  %i6 = sub i64 %i4, %i5
  store atomic i64 %i6, i64* %p1 unordered, align 8
  %i7 = add nuw nsw i32 %local_2_57, 1
  %i8 = icmp ugt i32 %local_2_57, 7
  br i1 %i8, label %loop2.exit, label %loop2

loop2.exit:                                       ; preds = %loop2, %general_case24
  %local_2_43 = phi i32 [ %local_2_, %general_case24 ], [ 9, %loop2 ]
  %local_3_44 = phi i32 [ %local_3_, %general_case24 ], [ %local_1_56, %loop2 ]
  %i9 = add nuw nsw i32 %local_0_, 1
  %i10 = icmp ugt i32 %local_0_, 129
  br i1 %i10, label %exit, label %loop1

exit:                                             ; preds = %loop2.exit, %loop1
  ret i32 0
}
