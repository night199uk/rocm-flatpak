kind: cmake
description: |
  therock-eigen - upstream project built directly from its release archive.

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
  url: https://gitlab.com/libeigen/eigen/-/archive/%{eigen-version}/eigen-%{eigen-version}.tar.bz2
  base-dir: "*"
  ref: b4c198460eba6f28d34894e3a5710998818515104d6e74e5cc331ce31e46e626
