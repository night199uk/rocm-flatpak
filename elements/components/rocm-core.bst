kind: cmake
description: |
  rocm-core

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
  conf-root: "rocm-systems/projects/rocm-core"
  cmake-local: >-
    -DBUILD_SHARED_LIBS=ON
    -DROCM_VERSION=7.14.0
