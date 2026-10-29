kind: cmake
description: |
  rocm_smi_lib

(@):
- elements/rocm-therock.bst

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- components/rocm-libdrm.bst

depends:
- components/rocm-libdrm.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-systems/projects/rocm-smi-lib"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DTHEROCK_HAS_BUNDLED_LIBDRM=OFF
    -DCMAKE_C_FLAGS=-I%{rocm-gl-prefix}/include
    -DCMAKE_CXX_FLAGS=-I%{rocm-gl-prefix}/include
