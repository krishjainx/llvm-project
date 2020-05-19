// RUN: mlir-cuda-runner %s --print-ir-after-all --shared-libs=%cuda_wrapper_library_dir/libcuda-runtime-wrappers%shlibext,%linalg_test_lib_dir/libmlir_runner_utils%shlibext --entry-point-result=void | FileCheck %s --dump-input=always

// CHECK: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
func @main() {
  %arg = alloc() : memref<13xi32>
  %dst = memref_cast %arg : memref<13xi32> to memref<?xi32>
  %one = constant 1 : index
  %sx = dim %dst, 0 : memref<?xi32>
  %cast_dst = memref_cast %dst : memref<?xi32> to memref<*xi32>
  call @mcuMemHostRegisterInt32(%cast_dst) : (memref<*xi32>) -> ()
  gpu.launch blocks(%bx, %by, %bz) in (%grid_x = %one, %grid_y = %one, %grid_z = %one)
             threads(%tx, %ty, %tz) in (%block_x = %sx, %block_y = %one, %block_z = %one) {
    %t0 = index_cast %tx : index to i32
    store %t0, %dst[%tx] : memref<?xi32>
    gpu.terminator
  }
  gpu.launch blocks(%bx, %by, %bz) in (%grid_x = %one, %grid_y = %one, %grid_z = %one)
             threads(%tx, %ty, %tz) in (%block_x = %sx, %block_y = %one, %block_z = %one) {
    %t0 = index_cast %tx : index to i32
    store %t0, %dst[%tx] : memref<?xi32>
    gpu.terminator
  }
  call @print_memref_i32(%cast_dst) : (memref<*xi32>) -> ()
  return
}

func @mcuMemHostRegisterInt32(%memref : memref<*xi32>)
func @print_memref_i32(%memref : memref<*xi32>)
