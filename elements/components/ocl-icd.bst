kind: cmake
description: |
  ocl-icd

(@):
- elements/rocm-therock.bst

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst

variables:
  rocm-prefix: "%{rocm-runtime-prefix}"
  rocm-llvm-prefix: "%{rocm-sdk-llvm-prefix}"
  prefix: "%{rocm-runtime-prefix}"
  lib: "lib"
  conf-root: "rocm-systems/projects/clr/opencl/khronos/icd"
  cmake-local: >-
    -DOPENCL_ICD_LOADER_REQUIRE_WDK=OFF
    -DOPENCL_ICD_LOADER_HEADERS_DIR=%{build-root}/rocm-systems/projects/clr/opencl/khronos/headers/opencl2.2
