kind: cmake
description: |
  MIOpen

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-hip.yml

build-depends:
- freedesktop-sdk.bst:components/bzip2.bst
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/sqlite.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/nlohmann-json.bst
- third-party/therock-eigen.bst
- third-party/therock-frugally-deep.bst
- third-party/therock-FunctionalPlus.bst
- third-party/therock-googletest.bst
- components/amd-llvm.bst
- components/composable_kernel.bst
- components/hip-clr.bst
- components/hipBLAS.bst
- components/hipBLAS-common.bst
- components/hipBLASLt.bst
- components/rocBLAS.bst
- components/rocm-cmake.bst
- components/rocm-half.bst
- components/rocprofiler-sdk.bst
- components/rocRAND.bst
- components/roctracer.bst

depends:
- freedesktop-sdk.bst:components/bzip2.bst
- freedesktop-sdk.bst:components/sqlite.bst
- components/hip-clr.bst
- components/hipBLAS.bst
- components/hipBLAS-common.bst
- components/hipBLASLt.bst
- components/rocBLAS.bst
- components/rocm-half.bst
- components/rocprofiler-sdk.bst
- components/rocRAND.bst
- components/roctracer.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-libraries/projects/miopen"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
    -DROCM_PATH=
    -DROCM_DIR=
    -DBUILD_TESTING=OFF
    -DMIOPEN_USE_COMPOSABLEKERNEL=ON
    -DMIOPEN_USE_MLIR=OFF
    -DMIOPEN_TEST_DISCRETE=OFF
    -DMIOPEN_INSTALL_GPU_DATABASES="%{rocm-gpu-targets}"

sources:
  (>):
  - kind: patch
    path: patch/0001-miopen-no-error-ciso646.patch
    strip-level: 1
