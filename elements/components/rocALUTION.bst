kind: cmake
description: |
  rocALUTION

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-hip.yml

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/therock-googletest.bst
- components/amd-llvm.bst
- components/hip-clr.bst
- components/rocBLAS.bst
- components/rocm-cmake.bst
- components/rocPRIM.bst
- components/rocRAND.bst
- components/rocSPARSE.bst

depends:
- components/hip-clr.bst
- components/rocBLAS.bst
- components/rocRAND.bst
- components/rocSPARSE.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-libraries/projects/rocalution"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
    -DROCM_PATH=
    -DROCM_DIR=
    -DSUPPORT_HIP=ON
    -DSUPPORT_MPI=OFF
    -DBUILD_CLIENTS_TESTS=OFF
    -DBUILD_CLIENTS_BENCHMARKS=OFF
    -DBUILD_CLIENTS_SAMPLES=OFF
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
