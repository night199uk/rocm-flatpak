kind: cmake
description: |
  rocSPARSE

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
- components/rocprofiler-sdk.bst
- components/roctracer.bst

depends:
- components/hip-clr.bst
- components/rocprofiler-sdk.bst
- components/roctracer.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-libraries/projects/rocsparse"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
    -DROCM_PATH=
    -DROCM_DIR=
    -DBUILD_WITH_ROCBLAS=ON
    -DBUILD_CLIENTS_TESTS=OFF
    -DBUILD_CLIENTS_BENCHMARKS=OFF
    -DBUILD_CLIENTS_SAMPLES=OFF
