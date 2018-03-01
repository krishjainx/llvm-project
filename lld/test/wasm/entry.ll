; RUN: llc -filetype=obj %s -o %t.o

target triple = "wasm32-unknown-unknown-wasm"

define hidden void @entry() local_unnamed_addr #0 {
entry:
  ret void
}

; RUN: wasm-ld --check-signatures -e entry -o %t1.wasm %t.o
; RUN: obj2yaml %t1.wasm | FileCheck %s
; RUN: wasm-ld --check-signatures --entry=entry -o %t2.wasm %t.o
; RUN: obj2yaml %t2.wasm | FileCheck %s

; CHECK:        - Type:            EXPORT
; CHECK-NEXT:     Exports:
; CHECK-NEXT:       - Name:            memory
; CHECK-NEXT:         Kind:            MEMORY
; CHECK-NEXT:         Index:           0
; CHECK-NEXT:       - Name:            __heap_base
; CHECK-NEXT:         Kind:            GLOBAL
; CHECK-NEXT:         Index:           1
; CHECK-NEXT:       - Name:            __data_end
; CHECK-NEXT:         Kind:            GLOBAL
; CHECK-NEXT:         Index:           2
; CHECK-NEXT:       - Name:            entry
; CHECK-NEXT:         Kind:            FUNCTION
; CHECK-NEXT:         Index:           0
; CHECK-NEXT:   - Type:

; The __wasm_call_ctors is somewhat special.  Make sure we can use it
; as the entry point if we choose
; RUN: wasm-ld --check-signatures --entry=__wasm_call_ctors -o %t3.wasm %t.o
; RUN: obj2yaml %t3.wasm | FileCheck %s -check-prefix=CHECK-CTOR

; CHECK-CTOR:        - Type:            EXPORT
; CHECK-CTOR-NEXT:     Exports:
; CHECK-CTOR-NEXT:       - Name:            memory
; CHECK-CTOR-NEXT:         Kind:            MEMORY
; CHECK-CTOR-NEXT:         Index:           0
; CHECK-CTOR-NEXT:       - Name:            __wasm_call_ctors
; CHECK-CTOR-NEXT:         Kind:            FUNCTION
; CHECK-CTOR-NEXT:         Index:           0
; CHECK-CTOR-NEXT:       - Name:            __heap_base
; CHECK-CTOR-NEXT:         Kind:            GLOBAL
; CHECK-CTOR-NEXT:         Index:           1
; CHECK-CTOR-NEXT:       - Name:            __data_end
; CHECK-CTOR-NEXT:         Kind:            GLOBAL
; CHECK-CTOR-NEXT:         Index:           2
; CHECK-CTOR-NEXT:   - Type:
