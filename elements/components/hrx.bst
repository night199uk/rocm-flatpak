kind: cmake
description: |
  hrx

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-llvm.yml

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/therock-catch2.bst
- components/amd-llvm.bst

depends:
- components/ROCR-Runtime.bst

variables:
  prefix: "%{rocm-prefix}/lib/hrx"
  lib: "lib"
  conf-root: "optional-sources/hrx"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DBUILD_SHARED_LIBS=ON
    -DHRX_BUILD_CTS=ON
    -DIREE_BUILD_TESTS=OFF
