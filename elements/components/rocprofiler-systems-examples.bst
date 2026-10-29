kind: cmake
description: |
  rocprofiler-systems examples

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
- components/rccl.bst
- components/rocprofiler-systems.bst
- components/rocshmem.bst

depends:
- components/rocprofiler-systems.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-systems/projects/rocprofiler-systems/examples"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DROCPROFSYS_GFX_TARGETS=%{rocm-gpu-targets}
    -DROCPROFSYS_DISABLE_EXAMPLES="lulesh;openmp-target;causal"
    -DROCPROFSYS_USE_MPI=OFF
