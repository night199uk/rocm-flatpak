kind: cmake
description: |
  therock-flatbuffers - upstream project built directly from its release archive.

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  cmake-local: >-
    -DFLATBUFFERS_BUILD_TESTS=OFF
    -DFLATBUFFERS_BUILD_FLATC=ON
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON

sources:
- kind: tar
  url: https://github.com/google/flatbuffers/archive/refs/tags/v%{flatbuffers-version}.tar.gz
  base-dir: "*"
  ref: 9102253214dea6ae10c2ac966ea1ed2155d22202390b532d1dea64935c518ada
