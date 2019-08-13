; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -mtriple=aarch64-unknown-linux-gnu -cost-model -cost-kind=throughput -analyze | FileCheck %s --check-prefixes=ALL,THROUGHPUT
; RUN: opt < %s -mtriple=aarch64-unknown-linux-gnu -cost-model -cost-kind=latency -analyze | FileCheck %s --check-prefixes=ALL,LATENCY
; RUN: opt < %s -mtriple=aarch64-unknown-linux-gnu -cost-model -cost-kind=code-size -analyze | FileCheck %s --check-prefixes=ALL,CODESIZE

define i32 @extract_first_i32({i32, i32} %agg) {
; THROUGHPUT-LABEL: 'extract_first_i32'
; THROUGHPUT-NEXT:  Cost Model: Unknown cost for instruction: %r = extractvalue { i32, i32 } %agg, 0
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 %r
;
; LATENCY-LABEL: 'extract_first_i32'
; LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r = extractvalue { i32, i32 } %agg, 0
; LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 %r
;
; CODESIZE-LABEL: 'extract_first_i32'
; CODESIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r = extractvalue { i32, i32 } %agg, 0
; CODESIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 %r
;
  %r = extractvalue {i32, i32} %agg, 0
  ret i32 %r
}

define i32 @extract_second_i32({i32, i32} %agg) {
; THROUGHPUT-LABEL: 'extract_second_i32'
; THROUGHPUT-NEXT:  Cost Model: Unknown cost for instruction: %r = extractvalue { i32, i32 } %agg, 1
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 %r
;
; LATENCY-LABEL: 'extract_second_i32'
; LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r = extractvalue { i32, i32 } %agg, 1
; LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 %r
;
; CODESIZE-LABEL: 'extract_second_i32'
; CODESIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r = extractvalue { i32, i32 } %agg, 1
; CODESIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 %r
;
  %r = extractvalue {i32, i32} %agg, 1
  ret i32 %r
}

define i32 @extract_i32({i32, i1} %agg) {
; THROUGHPUT-LABEL: 'extract_i32'
; THROUGHPUT-NEXT:  Cost Model: Unknown cost for instruction: %r = extractvalue { i32, i1 } %agg, 0
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 %r
;
; LATENCY-LABEL: 'extract_i32'
; LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r = extractvalue { i32, i1 } %agg, 0
; LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 %r
;
; CODESIZE-LABEL: 'extract_i32'
; CODESIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r = extractvalue { i32, i1 } %agg, 0
; CODESIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 %r
;
  %r = extractvalue {i32, i1} %agg, 0
  ret i32 %r
}

define i1 @extract_i1({i32, i1} %agg) {
; THROUGHPUT-LABEL: 'extract_i1'
; THROUGHPUT-NEXT:  Cost Model: Unknown cost for instruction: %r = extractvalue { i32, i1 } %agg, 1
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i1 %r
;
; LATENCY-LABEL: 'extract_i1'
; LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r = extractvalue { i32, i1 } %agg, 1
; LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i1 %r
;
; CODESIZE-LABEL: 'extract_i1'
; CODESIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r = extractvalue { i32, i1 } %agg, 1
; CODESIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i1 %r
;
  %r = extractvalue {i32, i1} %agg, 1
  ret i1 %r
}

define float @extract_float({i32, float} %agg) {
; THROUGHPUT-LABEL: 'extract_float'
; THROUGHPUT-NEXT:  Cost Model: Unknown cost for instruction: %r = extractvalue { i32, float } %agg, 1
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret float %r
;
; LATENCY-LABEL: 'extract_float'
; LATENCY-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %r = extractvalue { i32, float } %agg, 1
; LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %r
;
; CODESIZE-LABEL: 'extract_float'
; CODESIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r = extractvalue { i32, float } %agg, 1
; CODESIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %r
;
  %r = extractvalue {i32, float} %agg, 1
  ret float %r
}

define [42 x i42] @extract_array({i32, [42 x i42]} %agg) {
; THROUGHPUT-LABEL: 'extract_array'
; THROUGHPUT-NEXT:  Cost Model: Unknown cost for instruction: %r = extractvalue { i32, [42 x i42] } %agg, 1
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret [42 x i42] %r
;
; LATENCY-LABEL: 'extract_array'
; LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r = extractvalue { i32, [42 x i42] } %agg, 1
; LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret [42 x i42] %r
;
; CODESIZE-LABEL: 'extract_array'
; CODESIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r = extractvalue { i32, [42 x i42] } %agg, 1
; CODESIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret [42 x i42] %r
;
  %r = extractvalue {i32, [42 x i42]} %agg, 1
  ret [42 x i42] %r
}

define <42 x i42> @extract_vector({i32, <42 x i42>} %agg) {
; THROUGHPUT-LABEL: 'extract_vector'
; THROUGHPUT-NEXT:  Cost Model: Unknown cost for instruction: %r = extractvalue { i32, <42 x i42> } %agg, 1
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <42 x i42> %r
;
; LATENCY-LABEL: 'extract_vector'
; LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r = extractvalue { i32, <42 x i42> } %agg, 1
; LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret <42 x i42> %r
;
; CODESIZE-LABEL: 'extract_vector'
; CODESIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r = extractvalue { i32, <42 x i42> } %agg, 1
; CODESIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret <42 x i42> %r
;
  %r = extractvalue {i32, <42 x i42>} %agg, 1
  ret <42 x i42> %r
}

%T1 = type { i32, float, <4 x i1> }

define %T1 @extract_struct({i32, %T1} %agg) {
; THROUGHPUT-LABEL: 'extract_struct'
; THROUGHPUT-NEXT:  Cost Model: Unknown cost for instruction: %r = extractvalue { i32, %T1 } %agg, 1
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret %T1 %r
;
; LATENCY-LABEL: 'extract_struct'
; LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r = extractvalue { i32, %T1 } %agg, 1
; LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret %T1 %r
;
; CODESIZE-LABEL: 'extract_struct'
; CODESIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r = extractvalue { i32, %T1 } %agg, 1
; CODESIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret %T1 %r
;
  %r = extractvalue {i32, %T1} %agg, 1
  ret %T1 %r
}
