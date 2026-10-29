kind: cmake
description: |
  roctracer

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-hip.yml

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- components/amd-llvm.bst
- components/hip-clr.bst
- components/ROCR-Runtime.bst
- python3-cppheaderparser.bst

depends:
- components/hip-clr.bst
- components/ROCR-Runtime.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-systems/projects/roctracer"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DROCM_PATH=%{rocm-prefix}
    -DHIP_PLATFORM=amd

sources:
  (>):
    - kind: patch
      path: patch/0001-Fix-std-experimental-filesystem.patch
      strip-level: 1
