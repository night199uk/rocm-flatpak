kind: cmake
description: |
  therock-catch2 - upstream project built directly from its release archive.

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  cmake-local: >-
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON
    -DCATCH_BUILD_TESTING=OFF

sources:
- kind: tar
  url: https://github.com/catchorg/Catch2/archive/refs/tags/v%{catch2-version}.tar.gz
  base-dir: "*"
  ref: 18b3f70ac80fccc340d8c6ff0f339b2ae64944782f8d2fca2bd705cf47cadb79
