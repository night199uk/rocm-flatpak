kind: cmake
description: |
  rocPRIM tests

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-hip.yml

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/therock-googletest.bst
- components/amd-llvm.bst
- components/amdsmi.bst
- components/hip-clr.bst
- components/rocm-cmake.bst
- components/rocPRIM.bst

depends:
- components/hip-clr.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-libraries/projects/rocprim"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
    -DROCM_PATH=
    -DROCM_DIR=
    -DBUILD_TEST=ON
    -DBUILD_BENCHMARK=ON
    -DUSE_SYSTEM_LIB=ON
