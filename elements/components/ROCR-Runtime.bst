kind: cmake
description: |
  ROCR-Runtime

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-llvm.yml

build-depends:
- freedesktop-sdk.bst:components/elfutils.bst
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/vim.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- freedesktop-sdk-extra.bst:components/numactl.bst
- third-party/therock-simde.bst
- components/amd-llvm.bst
- components/rocm-libdrm.bst
- components/rocprofiler-register.bst

depends:
- freedesktop-sdk.bst:components/elfutils.bst
- freedesktop-sdk-extra.bst:components/numactl.bst
- components/rocm-libdrm.bst
- components/rocprofiler-register.bst

variables:
  rocm-prefix: "%{rocm-runtime-prefix}"
  rocm-llvm-prefix: "%{rocm-sdk-llvm-prefix}"
  prefix: "%{rocm-runtime-prefix}"
  lib: "lib"
  conf-root: "rocm-systems/projects/rocr-runtime"
  cmake-local: >-
    -DBUILD_SHARED_LIBS=ON
