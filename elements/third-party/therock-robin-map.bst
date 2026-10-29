kind: cmake
description: |
  therock-robin-map - upstream project built directly from its release archive.

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  cmake-local: >-
    -DBUILD_TESTING=OFF
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON

sources:
- kind: tar
  url: https://github.com/Tessil/robin-map/archive/refs/tags/v%{robin-map-version}.tar.gz
  base-dir: "*"
  ref: 0e3f53a377fdcdc5f9fed7a4c0d4f99e82bbb64175233bd13427fef9a771f4a1
