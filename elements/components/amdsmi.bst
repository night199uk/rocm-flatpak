kind: cmake
description: |
  amdsmi

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-llvm.yml

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/libmnl.bst
- freedesktop-sdk.bst:components/libnl.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/therock-googletest.bst
- components/amd-llvm.bst
- components/rocm-core.bst
- components/rocm-libdrm.bst

depends:
- freedesktop-sdk.bst:components/libmnl.bst
- freedesktop-sdk.bst:components/libnl.bst
- components/rocm-core.bst
- components/rocm-libdrm.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-systems/projects/amdsmi"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DCMAKE_VERBOSE_MAKEFILE=OFF
    -DBUILD_TESTS=OFF
