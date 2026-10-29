kind: cmake
description: |
  hipkernelprovider

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-hip.yml

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/nlohmann-json.bst
- third-party/therock-flatbuffers.bst
- third-party/therock-googletest.bst
- components/amd-llvm.bst
- components/hip-clr.bst
- components/hipDNN.bst
- components/hipdnn_integration_tests.bst

depends:
- components/hip-clr.bst
- components/hipdnn_integration_tests.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-libraries/dnn-providers/hip-kernel-provider"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
    -DROCM_PATH=
    -DROCM_DIR=
    -DHIPKERNELPROVIDER_ENABLE_TESTS=OFF
    -DENABLE_CLANG_TIDY=OFF
    -DENABLE_CLANG_FORMAT=OFF
