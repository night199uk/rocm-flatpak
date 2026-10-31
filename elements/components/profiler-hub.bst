kind: cmake
description: |
  profiler-hub

build-depends:
- freedesktop-sdk.bst:components/sqlite.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/nlohmann-json.bst
- third-party/therock-fmt.bst
- third-party/therock-spdlog.bst

depends:
- freedesktop-sdk.bst:components/sqlite.bst
- third-party/nlohmann-json.bst
- third-party/therock-fmt.bst
- third-party/therock-spdlog.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "profiler-hub/profilers/profiler-hub"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DFMT_VERSION=11.1.3
    -DPROFILER_HUB_BUILD_TESTS=OFF
    -DPROFILER_HUB_BUILD_BENCHMARKS=OFF
    -DPROFILER_HUB_ENABLE_LOGGING=OFF

sources:
- kind: git_tag
  url: github:ROCm/rocm-systems.git
  directory: profiler-hub
  checkout-submodules: false
  full-clone: false
  ref: 0e57a383b016cfd75b02e83dfb2adcd55f395b42
- kind: patch
  path: patch/0001-profiler-hub-use-system-deps.patch
  strip-level: 1
