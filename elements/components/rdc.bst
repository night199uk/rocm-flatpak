kind: cmake
description: |
  rdc

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-llvm.yml

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/libcap.bst
- freedesktop-sdk.bst:components/os-release.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/zlib.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/therock-googletest.bst
- third-party/therock-grpc.bst
- components/amd-llvm.bst
- components/amdsmi.bst
- components/rocprofiler-sdk.bst
- components/ROCR-Runtime.bst

depends:
- freedesktop-sdk.bst:components/libcap.bst
- freedesktop-sdk.bst:components/zlib.bst
- third-party/therock-googletest.bst
- components/amdsmi.bst
- components/rocprofiler-sdk.bst
- components/ROCR-Runtime.bst

variables:
  prefix: "%{rocm-prefix}/portable-rdc"
  lib: "lib"
  conf-root: "rocm-systems/projects/rdc"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DBUILD_PROFILER=ON
    -DBUILD_STANDALONE=ON
    -DBUILD_RUNTIME=ON
    -DBUILD_RVS=OFF
    -DBUILD_TESTS=OFF
    -DHIP_PLATFORM=amd
    -DCMAKE_CXX_STANDARD=17
    -DGRPC_ROOT=/usr
    -DGRPC_DESIRED_VERSION=1.78.1
