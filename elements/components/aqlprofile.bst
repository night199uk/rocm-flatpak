kind: cmake
description: |
  aqlprofile

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
- components/ROCR-Runtime.bst

depends:
- components/amd-llvm.bst
- components/hip-clr.bst
- components/ROCR-Runtime.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-systems/projects/aqlprofile"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DAQLPROFILE_BUILD_TESTS=OFF
    -DHIP_PLATFORM=amd
