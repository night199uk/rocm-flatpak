kind: cmake
description: |
  therock-fmt - upstream project built directly from its release archive.

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  cmake-local: >-
    -DFMT_DOC=OFF
    -DFMT_TEST=OFF
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON

sources:
- kind: zip
  url: https://github.com/fmtlib/fmt/releases/download/%{fmt-version}/fmt-%{fmt-version}.zip
  base-dir: "*"
  ref: 7df2fd3426b18d552840c071c977dc891efe274051d2e7c47e2c83c3918ba6df
