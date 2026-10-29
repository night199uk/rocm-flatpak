kind: cmake
description: |
  therock-SuiteSparse - upstream project built directly from its release archive.

  TheRock installed this under lib/host-math; this element installs it into the shared ROCm prefix.

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- freedesktop-sdk-extra.bst:components/openblas.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  cmake-local: >-
    -DSUITESPARSE_ENABLE_PROJECTS="suitesparse_config;cholmod"
    -DBLA_VENDOR=OpenBLAS
    -DBUILD_STATIC_LIBS=OFF
    -DSUITESPARSE_USE_CUDA=OFF
    -DSUITESPARSE_USE_OPENMP=OFF
    -DSUITESPARSE_USE_FORTRAN=OFF
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON

sources:
- kind: tar
  url: https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v%{suitesparse-version}.tar.gz
  base-dir: "*"
  ref: ce39b28d4038a09c14f21e02c664401be73c0cb96a9198418d6a98a7db73a259
