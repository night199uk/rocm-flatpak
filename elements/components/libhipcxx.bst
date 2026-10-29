kind: cmake
description: |
  libhipcxx

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
- components/hipcc.bst
- components/rocm-cmake.bst

depends:
- components/amd-llvm.bst
- components/hip-clr.bst
- components/hipcc.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "math-libs/libhipcxx"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DLIBHIPCXX_COPY_TO_BUILD=ON
    -DHIP_PLATFORM=amd
    -DROCM_PATH=
    -DROCM_DIR=
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
    -DCMAKE_CXX_STANDARD=17
    -DROCM_GPU_TARGETS=
    -DGPU_TARGETS=gfx942
    -DBUILD_TESTING=OFF
    -DLIBCUDACXX_ENABLE_LIBCUDACXX_TESTS=OFF
