// KEEP-ALL: "-mdisable-fp-elim"
// KEEP-ALL-NOT: "-momit-leaf-frame-pointer"

// KEEP-NON-LEAF: "-mdisable-fp-elim"
// KEEP-NON-LEAF: "-momit-leaf-frame-pointer"

// KEEP-NONE-NOT: "-mdisable-fp-elim"
// KEEP-NONE-NOT: "-momit-leaf-frame-pointer"

// On Linux x86, omit frame pointer when optimization is enabled.
// RUN: %clang -### -target i386-linux -S -fomit-frame-pointer %s 2>&1 | \
// RUN:   FileCheck --check-prefix=KEEP-NONE %s
// RUN: %clang -### -target i386-linux -S -O1 %s 2>&1 | \
// RUN:   FileCheck --check-prefix=KEEP-NONE %s

// -fno-omit-frame-pointer or -pg disables frame pointer omission.
// RUN: %clang -### -target i386-linux -S %s 2>&1 | \
// RUN:   FileCheck --check-prefix=KEEP-ALL %s
// RUN: %clang -### -target i386-linux -S -O1 -fno-omit-frame-pointer %s 2>&1 | \
// RUN:   FileCheck --check-prefix=KEEP-ALL %s
// RUN: %clang -### -target i386-linux -S -O1 -pg %s 2>&1 | \
// RUN:   FileCheck --check-prefix=KEEP-ALL %s

// -momit-leaf-frame-pointer omits leaf frame pointer.
// -fno-omit-frame-pointer loses out to -momit-leaf-frame-pointer.
// RUN: %clang -### -target i386 -S -momit-leaf-frame-pointer %s 2>&1 | \
// RUN:   FileCheck --check-prefix=KEEP-NON-LEAF %s
// RUN: %clang -### -target i386-linux -S -O1 -fno-omit-frame-pointer -momit-leaf-frame-pointer %s 2>&1 | \
// RUN:   FileCheck --check-prefix=KEEP-NON-LEAF %s
// RUN: %clang -### -target i386-linux -S -O1 -momit-leaf-frame-pointer %s 2>&1 | \
// RUN:   FileCheck --check-prefix=KEEP-NONE %s

// Explicit or default -fomit-frame-pointer wins over -mno-omit-leaf-frame-pointer.
// RUN: %clang -### -target i386 -S %s -fomit-frame-pointer -mno-omit-leaf-frame-pointer 2>&1 | \
// RUN:   FileCheck --check-prefix=KEEP-NONE %s
// RUN: %clang -### -target i386-linux -S %s -O1 -mno-omit-leaf-frame-pointer 2>&1 | \
// RUN:   FileCheck --check-prefix=KEEP-NONE %s

// -pg -fomit-frame-pointer => error.
// RUN: %clang -### -S -fomit-frame-pointer -pg %s 2>&1 | FileCheck -check-prefix=CHECK-NO-MIX-OMIT-FP-PG %s
// RUN: %clang -### -S -fomit-frame-pointer -fno-omit-frame-pointer -pg %s 2>&1 | FileCheck -check-prefix=CHECK-MIX-NO-OMIT-FP-PG %s
// CHECK-NO-MIX-OMIT-FP-PG: '-fomit-frame-pointer' not allowed with '-pg'
// CHECK-MIX-NO-OMIT-FP-PG-NOT: '-fomit-frame-pointer' not allowed with '-pg'

// CloudABI follows the same rules as Linux.
// RUN: %clang -### -target x86_64-unknown-cloudabi -S -O1 %s 2>&1 | \
// RUN:   FileCheck --check-prefix=KEEP-NONE %s

// RUN: %clang -### -target x86_64-unknown-cloudabi -S %s 2>&1 | \
// RUN:   FileCheck --check-prefix=KEEP-ALL %s

// NetBSD follows the same rules as Linux.
// RUN: %clang -### -target x86_64-unknown-netbsd -S -O1 %s 2>&1 | \
// RUN:   FileCheck --check-prefix=KEEP-NONE %s

// RUN: %clang -### -target x86_64-unknown-netbsd -S %s 2>&1 | \
// RUN:   FileCheck --check-prefix=KEEP-ALL %s

// OpenBSD follows the same rules as Linux.
// RUN: %clang -### -target x86_64-unknown-openbsd -S -O1 %s 2>&1 | \
// RUN:   FileCheck --check-prefix=OPENBSD-OPT %s
// RUN: %clang -### -target powerpc-unknown-openbsd -S -O1 %s 2>&1 | \
// RUN:   FileCheck --check-prefix=OPENBSD-OPT %s
// OPENBSD-OPT: "-momit-leaf-frame-pointer"

// RUN: %clang -### -target x86_64-unknown-openbsd -S %s 2>&1 | \
// RUN:   FileCheck --check-prefix=OPENBSD %s
// RUN: %clang -### -target powerpc-unknown-openbsd -S %s 2>&1 | \
// RUN:   FileCheck --check-prefix=OPENBSD %s
// OPENBSD-NOT: "-momit-leaf-frame-pointer"

// Darwin disables omitting the leaf frame pointer even under optimization
// unless the command lines are given.
// RUN: %clang -### -target i386-apple-darwin -S %s 2>&1 | \
// RUN:   FileCheck --check-prefix=KEEP-ALL %s

// RUN: %clang -### -target i386-apple-darwin -S -O1 %s 2>&1 | \
// RUN:   FileCheck --check-prefix=KEEP-ALL %s

// RUN: %clang -### -target i386-darwin -S -fomit-frame-pointer %s 2>&1 | \
// RUN:   FileCheck --check-prefix=KEEP-NONE %s

// RUN: %clang -### -target i386-darwin -S -momit-leaf-frame-pointer %s 2>&1 | \
// RUN:   FileCheck --check-prefix=KEEP-NON-LEAF %s

// RUN: %clang -### -target armv7s-apple-ios -fomit-frame-pointer %s 2>&1 | \
// RUN:   FileCheck --check-prefix=WARN-OMIT-7S %s
// WARN-OMIT-7S: warning: optimization flag '-fomit-frame-pointer' is not supported for target 'armv7s'
// WARN-OMIT-7S: "-mdisable-fp-elim"
// WARN-OMIT-7S-NOT: "-momit-leaf-frame-pointer"

// RUN: %clang -### -target armv7k-apple-watchos -fomit-frame-pointer %s 2>&1 | \
// RUN:   FileCheck --check-prefix=WARN-OMIT-7K %s
// WARN-OMIT-7K: warning: optimization flag '-fomit-frame-pointer' is not supported for target 'armv7k'
// WARN-OMIT-7K: "-mdisable-fp-elim"
// WARN-OMIT-7K-NOT: "-momit-leaf-frame-pointer"

// RUN: %clang -### -target armv7s-apple-ios8.0 -momit-leaf-frame-pointer %s 2>&1 | \
// RUN:   FileCheck --check-prefix=WARN-OMIT-LEAF-7S %s
// WARN-OMIT-LEAF-7S-NOT: warning: optimization flag '-momit-leaf-frame-pointer' is not supported for target 'armv7s'
// WARN-OMIT-LEAF-7S: "-mdisable-fp-elim"
// WARN-OMIT-LEAF-7S: "-momit-leaf-frame-pointer"

// On the PS4, we default to omitting the frame pointer on leaf functions
// RUN: %clang -### -target x86_64-scei-ps4 -S %s 2>&1 | \
// RUN:   FileCheck --check-prefix=KEEP-NON-LEAF %s
// RUN: %clang -### -target x86_64-scei-ps4 -S -O2 %s 2>&1 | \
// RUN:   FileCheck --check-prefix=KEEP-NON-LEAF %s

void f0() {}
void f1() { f0(); }
