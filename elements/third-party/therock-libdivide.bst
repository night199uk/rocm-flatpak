kind: cmake
description: |
  therock-libdivide - upstream project built directly from its release archive.

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  cmake-local: >-
    -DLIBDIVIDE_BUILD_TESTS=OFF
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON

sources:
- kind: tar
  url: https://github.com/ridiculousfish/libdivide/archive/refs/tags/v%{libdivide-version}.tar.gz
  base-dir: "*"
  ref: 73ae910c4cdbda823b7df2c1e0e1e7427464ebc43fc770b1a30bb598cb703f49
