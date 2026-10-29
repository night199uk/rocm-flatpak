kind: cmake
description: |
  ocl-clr

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-llvm.yml

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/libglvnd.bst
- freedesktop-sdk.bst:components/mesa-headers.bst
- freedesktop-sdk.bst:components/os-release.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/therock-simde.bst
- components/amd-comgr.bst
- components/amd-llvm.bst
- components/ocl-icd.bst
- components/rocm-cmake.bst
- components/rocm-core.bst
- components/rocminfo.bst
- components/rocprofiler-register.bst
- components/ROCR-Runtime.bst

depends:
- components/amd-comgr.bst
- components/amd-llvm.bst
- components/ocl-icd.bst
- components/rocm-core.bst
- components/rocminfo.bst
- components/rocprofiler-register.bst
- components/ROCR-Runtime.bst

variables:
  rocm-prefix: "%{rocm-runtime-prefix}"
  rocm-llvm-prefix: "%{rocm-sdk-llvm-prefix}"
  prefix: "%{rocm-runtime-prefix}"
  lib: "lib"
  conf-root: "rocm-systems/projects/clr"
  cmake-local: >-
    -DCMAKE_LIBRARY_PATH=/usr/lib/%{gcc_triplet}:/usr/lib
    -DCLR_BUILD_OCL=ON
    -DBUILD_TESTS=OFF
