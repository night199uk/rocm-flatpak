kind: cmake
description: |
  hipSOLVER

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-hip.yml

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/therock-googletest.bst
- third-party/therock-SuiteSparse.bst
- components/amd-llvm.bst
- components/hip-clr.bst
- components/rocBLAS.bst
- components/rocm-cmake.bst
- components/rocSOLVER.bst
- components/rocSPARSE.bst

depends:
- third-party/therock-SuiteSparse.bst
- components/hip-clr.bst
- components/rocBLAS.bst
- components/rocSOLVER.bst
- components/rocSPARSE.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-libraries/projects/hipsolver"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
    -DROCM_PATH=
    -DROCM_DIR=
    -DBUILD_HIPSPARSE_TESTS=OFF
    -DBUILD_WITH_SPARSE=ON
    -DBUILD_CLIENTS_BENCHMARKS=OFF
    -DBUILD_CLIENTS_TESTS=OFF
    -DHIPSOLVER_FIND_PACKAGE_LAPACK_CONFIG=OFF
    -DHIPSOLVER_INTERNAL_LAPACK_BUILD=OFF
    -DLAPACK_LIBRARIES=openblas
    -DEXPORT_FORTRAN_BINDINGS=OFF

sources:
  (>):
  - kind: patch
    path: patch/0001-hipsolver-offline-lapack.patch
    strip-level: 1
