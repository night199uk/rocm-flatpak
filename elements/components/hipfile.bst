kind: cmake
description: |
  hipfile

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-hip.yml

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/util-linux.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/therock-googletest.bst
- components/amd-llvm.bst
- components/hip-clr.bst
- components/rocm-cmake.bst

depends:
- freedesktop-sdk.bst:components/util-linux.bst
- components/hip-clr.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-systems/projects/hipfile"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DCMAKE_VERBOSE_MAKEFILE=OFF
    -DAIS_CXX_STANDARD=20
    -DROCM_PATH=
    -DROCM_DIR=
    -DHIP_PLATFORM=amd
    -DBUILD_TESTING=OFF
    -DAIS_INSTALL_TESTS=OFF
    -DCMAKE_GTEST_DISCOVER_TESTS_DISCOVERY_MODE=PRE_TEST
    -DROCM_VERSION=7.14.0
