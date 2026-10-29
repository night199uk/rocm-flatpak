kind: cmake
description: |
  rocshmem

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-hip.yml

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- freedesktop-sdk-extra.bst:components/numactl.bst
- third-party/therock-fmt.bst
- third-party/therock-googletest.bst
- components/amd-llvm.bst
- components/amdsmi.bst
- components/hip-clr.bst
- components/rocm-cmake.bst
- components/ROCR-Runtime.bst

depends:
- freedesktop-sdk-extra.bst:components/numactl.bst
- components/amdsmi.bst
- components/hip-clr.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-systems/projects/rocshmem"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DCMAKE_CXX_FLAGS_INIT="-I%{rocm-runtime-prefix}/include"
    -DHSA_INCLUDE_DIR=%{rocm-runtime-prefix}/include
    -DCMAKE_VERBOSE_MAKEFILE=OFF
    -DUSE_RO=ON
    -DUSE_IPC=ON
    -DUSE_GDA=ON
    -DGDA_MLX5=ON
    -DGDA_BNXT=ON
    -DGDA_IONIC=ON
    -DUSE_EXTERNAL_MPI=OFF
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON
    -DHIP_PLATFORM=amd
    -DROCM_PATH=
    -DROCM_DIR=
    -DEXPLICIT_ROCM_VERSION=7.14.0
    -DBUILD_FUNCTIONAL_TESTS=OFF
    -DBUILD_UNIT_TESTS=OFF
    -DSOURCE_DIR=SOURCE_DIR
    -DPATCHELF=patchelf
    -DPython3_EXECUTABLE=python3

sources:
  (>):
  - kind: patch
    path: patch/0001-rocshmem-hsa-include.patch
    strip-level: 1
