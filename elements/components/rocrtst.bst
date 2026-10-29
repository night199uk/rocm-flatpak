kind: cmake
description: |
  rocrtst

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-llvm.yml

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/therock-yaml-cpp.bst
- components/amd-llvm.bst
- components/amdsmi.bst
- components/ocl-clr.bst

depends:
- freedesktop-sdk.bst:components/elfutils.bst
- freedesktop-sdk-extra.bst:components/numactl.bst
- third-party/therock-hwloc.bst
- components/ocl-clr.bst
- components/rocm-libdrm.bst
- components/rocprofiler-register.bst
- components/ROCR-Runtime.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-systems/projects/rocr-runtime/rocrtst/suites/test_common"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix}"
    -DOpenCL_INCLUDE_DIR=%{rocm-runtime-prefix}/include
    -DOpenCL_LIBRARY=%{rocm-runtime-prefix}/lib/libOpenCL.so
    -DLLVM_DIR=
    -DROCM_DIR=
