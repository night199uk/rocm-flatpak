kind: cmake
description: |
  therock-googletest - upstream project built directly from its release archive.

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  cmake-local: >-
    -Dgtest_force_shared_crt=ON
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON

sources:
- kind: tar
  url: https://github.com/google/googletest/releases/download/v%{googletest-version}/googletest-%{googletest-version}.tar.gz
  base-dir: "*"
  ref: 65fab701d9829d38cb77c14acdc431d2108bfdbf8979e40eb8ae567edf10b27c
