kind: cmake
description: |
  rocdecode

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
- components/rocm-amd-mesa.bst
- components/rocm-libdrm.bst
- components/rocprofiler-register.bst

depends:
- components/hip-clr.bst
- components/rocm-amd-mesa.bst
- components/rocm-libdrm.bst
- components/rocprofiler-register.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-systems/projects/rocdecode"
  cmake-local: >-
    -DROCM_PATH=
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DLIBDRM_AMDGPU_INCLUDE_DIR=%{rocm-gl-prefix}/include
    -DLIBDRM_AMDGPU_LIBRARY=%{rocm-gl-prefix}/lib/libdrm_amdgpu.so

sources:
  (>):
    - kind: patch
      path: patch/0001-Fix-std-experimental-filesystem.patch
      strip-level: 1
