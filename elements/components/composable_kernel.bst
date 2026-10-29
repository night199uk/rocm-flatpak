kind: cmake
description: |
  composable_kernel

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-hip.yml

build-depends:
- freedesktop-sdk.bst:components/bzip2.bst
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- components/amd-llvm.bst
- components/hip-clr.bst
- components/rocm-cmake.bst
- components/rocm-half.bst
- components/rocprofiler-sdk.bst
- components/rocRAND.bst
- components/roctracer.bst

depends:
- freedesktop-sdk.bst:components/bzip2.bst
- components/hip-clr.bst
- components/rocm-half.bst
- components/rocprofiler-sdk.bst
- components/rocRAND.bst
- components/roctracer.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-libraries/projects/composablekernel"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
    -DROCM_PATH=
    -DROCM_DIR=
    -DBUILD_TESTING=OFF
    -DMIOPEN_REQ_LIBS_ONLY=ON
    -DHIPTENSOR_REQ_LIBS_ONLY=ON
