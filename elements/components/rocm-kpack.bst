kind: cmake
description: |
  rocm-kpack

(@):
- elements/rocm-therock.bst

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/zstd.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/therock-msgpack-cxx.bst

depends:
- freedesktop-sdk.bst:components/zstd.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-systems/shared/kpack"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DBUILD_TESTING=OFF
    -DBUILD_SHARED_LIBS=ON
    -DCMAKE_MODULE_PATH=%{build-root}/files/cmake

sources:
  (>):
    - kind: local
      path: files/cmake
      directory: files/cmake
