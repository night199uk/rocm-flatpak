kind: cmake
description: |
  rocRoller

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-hip.yml

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- freedesktop-sdk-extra.bst:components/boost.bst
- freedesktop-sdk-extra.bst:components/openblas.bst
- third-party/therock-catch2.bst
- third-party/therock-fmt.bst
- third-party/therock-googletest.bst
- third-party/therock-libdivide.bst
- third-party/therock-msgpack-cxx.bst
- third-party/therock-spdlog.bst
- third-party/therock-yaml-cpp.bst
- components/amd-llvm.bst
- components/hip-clr.bst
- components/mxDataGenerator.bst
- components/rocm-cmake.bst
- components/rocm-libdrm.bst
- components/rocprofiler-sdk.bst
- components/roctracer.bst

depends:
- freedesktop-sdk-extra.bst:components/openblas.bst
- components/hip-clr.bst
- components/rocm-libdrm.bst
- components/rocprofiler-sdk.bst
- components/roctracer.bst

environment:
  # GPUArchitectureGenerator links libraries from the amd-llvm and GL trees,
  # which are not on its RPATH when run from the build directory.
  LD_LIBRARY_PATH: "%{rocm-llvm-prefix}/lib:%{rocm-prefix}/lib:%{rocm-gl-prefix}/lib"

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-libraries/shared/rocroller"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
    -DROCROLLER_ENABLE_YAML_CPP=ON
    -DROCROLLER_ENABLE_CLIENT=OFF
    -DROCROLLER_BUILD_TESTING=OFF
    -DROCROLLER_BUILD_SHARED_LIBS=ON
