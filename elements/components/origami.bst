kind: cmake
description: |
  origami

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-hip.yml

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/therock-catch2.bst
- components/rocm-cmake.bst

depends:
- components/hip-clr.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-libraries/shared/origami"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
    -DORIGAMI_BUILD_SHARED_LIBS=ON
    -DORIGAMI_BUILD_TESTING=OFF
    -DORIGAMI_ENABLE_PYTHON=OFF
    -DORIGAMI_ENABLE_FETCH=OFF
