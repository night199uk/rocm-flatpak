kind: cmake
description: |
  hipify

(@):
- elements/rocm-therock.bst

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- components/amd-llvm.bst
- components/rocm-cmake.bst

depends:
- components/amd-llvm.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "compiler/hipify"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIPIFY_INSTALL_CLANG_HEADERS=OFF
