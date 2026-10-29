kind: cmake
description: |
  rocprofiler-compute

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-hip.yml

build-depends:
- freedesktop-sdk.bst:components/elfutils.bst
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/sqlite.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- components/amd-llvm.bst
- components/aqlprofile.bst
- components/hip-clr.bst
- components/rocm-libdrm.bst
- components/rocprofiler-register.bst
- components/rocprofiler-sdk.bst

depends:
- freedesktop-sdk.bst:components/elfutils.bst
- freedesktop-sdk.bst:components/sqlite.bst
- components/aqlprofile.bst
- components/hip-clr.bst
- components/rocm-libdrm.bst
- components/rocprofiler-register.bst
- components/rocprofiler-sdk.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-systems/projects/rocprofiler-compute"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
    -DENABLE_TESTS=OFF
    -DINSTALL_TESTS=OFF
    -DTEST_FROM_INSTALL=OFF
    -DCHECK_PYTHON_DEPS=OFF
