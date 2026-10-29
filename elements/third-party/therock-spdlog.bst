kind: cmake
description: |
  therock-spdlog - upstream project built directly from its release archive.

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/therock-fmt.bst
- components/amd-llvm.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  cmake-local: >-
    -DSPDLOG_BUILD_EXAMPLE=OFF
    -DSPDLOG_INSTALL=ON
    -DSPDLOG_FMT_EXTERNAL=ON
    -DSPDLOG_BUILD_PIC=ON

sources:
- kind: tar
  url: https://github.com/gabime/spdlog/archive/refs/tags/v%{spdlog-version}.tar.gz
  base-dir: "*"
  ref: 15a04e69c222eb6c01094b5c7ff8a249b36bb22788d72519646fb85feb267e67
