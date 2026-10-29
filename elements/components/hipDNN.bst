kind: cmake
description: |
  hipDNN

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
- third-party/therock-fmt.bst
- third-party/therock-googletest.bst
- third-party/therock-nanobind.bst
- third-party/therock-robin-map.bst
- third-party/therock-spdlog.bst
- components/amd-llvm.bst
- components/hip-clr.bst

depends:
- third-party/nlohmann-json.bst
- third-party/therock-flatbuffers.bst
- components/hip-clr.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-libraries/projects/hipdnn"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
    -DROCM_PATH=
    -DROCM_DIR=
    -DHIP_DNN_SKIP_TESTS=ON
    -DHIP_DNN_BUILD_PLUGINS=OFF
    -DHIP_DNN_GENERATE_SDK_HEADERS=OFF
    -DHIPDNN_BUILD_PYTHON_BINDINGS=ON
    -DENABLE_CLANG_TIDY=OFF
    -DENABLE_CLANG_FORMAT=OFF
