kind: cmake
description: |
  therock-FunctionalPlus - upstream project built directly from its release archive.

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
    -DBUILD_TESTING=OFF

sources:
- kind: tar
  url: https://github.com/Dobiasd/FunctionalPlus/archive/refs/tags/v%{functionalplus-version}.tar.gz
  base-dir: "*"
  ref: 9b5e24bbc92f43b977dc83efbc173bcf07dbe07f8718fc2670093655b56fcee3
