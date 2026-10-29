kind: cmake
description: |
  hip-tests

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-hip.yml

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- freedesktop-sdk-extra.bst:components/boost.bst
- freedesktop-sdk-extra.bst:components/numactl.bst
- third-party/therock-catch2.bst
- components/amd-llvm.bst
- components/hip-clr.bst
- components/rocm-cmake.bst

depends:
- freedesktop-sdk-extra.bst:components/numactl.bst
- components/hip-clr.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-systems/projects/hip-tests/catch"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
