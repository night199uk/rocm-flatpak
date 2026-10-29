kind: cmake
description: |
  hip-clr

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-llvm.yml

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/libglvnd.bst
- freedesktop-sdk.bst:components/mesa-headers.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/therock-simde.bst
- components/amd-comgr.bst
- components/amd-llvm.bst
- components/hipcc.bst
- components/rocm-cmake.bst
- components/rocm-core.bst
- components/rocm-kpack.bst
- components/rocminfo.bst
- components/rocprofiler-register.bst
- components/ROCR-Runtime.bst
- python3-cppheaderparser.bst

depends:
- components/amd-comgr.bst
- components/amd-llvm.bst
- components/hipcc.bst
- components/rocm-core.bst
- components/rocm-kpack.bst
- components/rocminfo.bst
- components/rocprofiler-register.bst
- components/ROCR-Runtime.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-systems/projects/clr"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
    -DCMAKE_LIBRARY_PATH=/usr/lib/%{gcc_triplet}:/usr/lib
    -DHIP_COMMON_DIR=%{build-root}/rocm-systems/projects/hip
    -DCLR_BUILD_HIP=ON
    -DROCM_KPACK_ENABLED=ON
    -DHIPCC_BIN_DIR=
