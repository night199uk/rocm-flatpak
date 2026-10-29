kind: cmake
description: |
  rccl

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-hip.yml

build-depends:
- freedesktop-sdk.bst:components/gawk.bst
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/grep.bst
- freedesktop-sdk.bst:components/os-release.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/sed.bst
- freedesktop-sdk.bst:components/which.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/therock-fmt.bst
- third-party/therock-googletest.bst
- components/amd-llvm.bst
- components/amdsmi.bst
- components/hip-clr.bst
- components/hipify.bst
- components/rocm-cmake.bst
- components/rocm_smi_lib.bst
- components/rocprofiler-register.bst
- components/rocprofiler-sdk.bst
- components/roctracer.bst

depends:
- components/amdsmi.bst
- components/hip-clr.bst
- components/hipify.bst
- components/rocm_smi_lib.bst
- components/rocprofiler-register.bst
- components/rocprofiler-sdk.bst
- components/roctracer.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-systems/projects/rccl"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
    -DROCM_PATH=
    -DCMAKE_SHARED_LINKER_FLAGS="-L%{rocm-runtime-prefix}/lib"
    -DCMAKE_EXE_LINKER_FLAGS="-L%{rocm-runtime-prefix}/lib"
    -DROCM_DIR=
    -DEXPLICIT_ROCM_VERSION=7.14.0
    -DENABLE_MSCCLPP=OFF
    -DENABLE_MSCCL_KERNEL=OFF
    -DBUILD_TESTS=OFF
