kind: cmake
description: |
  rocprofiler-sdk

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-hip.yml

build-depends:
- freedesktop-sdk.bst:components/elfutils.bst
- freedesktop-sdk.bst:components/gawk.bst
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/grep.bst
- freedesktop-sdk.bst:components/make.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/sed.bst
- freedesktop-sdk.bst:components/sqlite.bst
- freedesktop-sdk.bst:components/which.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/therock-yaml-cpp.bst
- components/amd-llvm.bst
- components/aqlprofile.bst
- components/hip-clr.bst
- components/rocdecode.bst
- components/rocjpeg.bst
- components/rocm-libdrm.bst
- components/rocprof-trace-decoder.bst
- components/rocprofiler-register.bst

depends:
- freedesktop-sdk.bst:components/elfutils.bst
- freedesktop-sdk.bst:components/sqlite.bst
- third-party/therock-yaml-cpp.bst
- components/aqlprofile.bst
- components/hip-clr.bst
- components/rocm-libdrm.bst
- components/rocprof-trace-decoder.bst
- components/rocprofiler-register.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-systems/projects/rocprofiler-sdk"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
    -DROCPROFILER_BUILD_CI=ON
    -DROCPROFILER_BUILD_DEVELOPER=OFF
    -DROCPROFILER_BUILD_TESTS=OFF
    -DROCPROFILER_BUILD_INTEGRATION_TESTS=OFF
    -DROCPROFILER_BUILD_SAMPLES=OFF
    -DCMAKE_PREFIX_PATH=%{rocm-prefix}
    -DROCM_PATH=%{rocm-prefix}
    -DROCPROFILER_BUILD_YAML_CPP=OFF
    -DROCPROFILER_PYTHON_VERSIONS:STRING=
    -DFETCHCONTENT_SOURCE_DIR_OTF2-SOURCE=%{build-root}/deps/otf2-3.0.3

sources:
  (>):
    - kind: tar
      url: rocm-third-party-deps:otf2-%{otf2-version}.tar.gz
      directory: deps/
      base-dir: ""
      ref: 18a3905f7917340387e3edc8e5766f31ab1af41f4ecc5665da6c769ca21c4ee8
