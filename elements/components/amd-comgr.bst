kind: cmake
description: |
  amd-comgr

(@):
- elements/rocm-therock.bst

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/zstd.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- components/amd-llvm.bst
- components/rocm-cmake.bst

depends:
- freedesktop-sdk.bst:components/zstd.bst
- components/amd-llvm.bst

variables:
  rocm-prefix: "%{rocm-runtime-prefix}"
  rocm-llvm-prefix: "%{rocm-sdk-llvm-prefix}"
  prefix: "%{rocm-runtime-prefix}"
  lib: "lib"
  conf-root: "compiler/amd-llvm/amd/comgr"
  cmake-local: >-
    -DCOMGR_STATIC_LLVM=ON
    -DTHEROCK_BUILD_COMGR_TESTS=OFF
    -DLLVM_VERSION_SUFFIX=-rocm7
    -DLLVM_ENABLE_SYMBOL_VERSIONING=ON
    -DCOMGR_ENABLE_HOTSWAP_TRANSPILE=ON
    -DHOTSWAP_BUILD_TOOL=ON
    -DHOTSWAP_TOOL_HSA_INCLUDE_ROOT=%{build-root}/rocm-systems/projects/rocr-runtime/runtime/hsa-runtime
