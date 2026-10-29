kind: cmake
description: |
  therock-fftw3f - upstream project built directly from its release archive.

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  cmake-local: >-
    -DENABLE_FLOAT=ON
    -DBUILD_SHARED_LIBS=ON
    -DENABLE_THREADS=ON
    -DCMAKE_BUILD_TYPE=Release
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON

sources:
- kind: tar
  url: https://fftw.org/fftw-%{fftw-version}.tar.gz
  base-dir: "*"
  ref: 56c932549852cddcfafdab3820b0200c7742675be92179e59e6215b340e26467
