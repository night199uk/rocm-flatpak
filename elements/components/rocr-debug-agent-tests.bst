kind: cmake
description: |
  rocr-debug-agent-tests

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-hip.yml

build-depends:
- freedesktop-sdk.bst:components/elfutils.bst
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- components/amd-dbgapi.bst
- components/amd-llvm.bst
- components/hip-clr.bst
- components/rocr-debug-agent.bst
- components/ROCR-Runtime.bst

depends:
- freedesktop-sdk.bst:components/elfutils.bst
- components/amd-dbgapi.bst
- components/hip-clr.bst
- components/rocr-debug-agent.bst
- components/ROCR-Runtime.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-systems/projects/rocr-debug-agent/test"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
