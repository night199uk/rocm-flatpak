kind: cmake
description: |
  therock-nanobind - upstream project built directly from its release archive.

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/therock-robin-map.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  cmake-local: >-
    -DNB_TEST=OFF
    -DNB_USE_SUBMODULE_DEPS=OFF
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON

sources:
- kind: tar
  url: https://github.com/wjakob/nanobind/archive/refs/tags/v%{nanobind-version}.tar.gz
  base-dir: "*"
  ref: 01f1f0cd0398743c18f33d07ae36ad410bd7f4a1e90683b508504de897d6e629
