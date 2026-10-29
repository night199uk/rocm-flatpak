kind: cmake
description: |
  rocWMMA

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

depends:
- components/hip-clr.bst
- components/rocBLAS.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-libraries/projects/rocwmma"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
    -DROCM_PATH=
    -DROCM_DIR=
    -DROCWMMA_BUILD_TESTS=OFF
    -DROCWMMA_VALIDATE_WITH_ROCBLAS=ON
    -DROCWMMA_BENCHMARK_WITH_ROCBLAS=OFF
    -DROCWMMA_BUILD_BENCHMARK_TESTS=OFF
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
    -DROCWMMA_USE_SYSTEM_GOOGLETEST=ON
