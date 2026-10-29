kind: cmake
description: |
  hipSPARSELt

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-hip.yml

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/python3-packaging.bst
- freedesktop-sdk.bst:components/python3-pyyaml.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- freedesktop-sdk-extra.bst:components/openblas.bst
- freedesktop-sdk-extra.bst:components/python-numpy.bst
- freedesktop-sdk-extra.bst:components/python3-joblib.bst
- freedesktop-sdk-extra.bst:components/python3-msgpack.bst
- third-party/therock-googletest.bst
- third-party/therock-msgpack-cxx.bst
- third-party/therock-robin-map.bst
- components/amd-llvm.bst
- components/amdsmi.bst
- components/hip-clr.bst
- components/hipSPARSE.bst
- components/rocm-cmake.bst
- components/rocm_smi_lib.bst
- components/rocprofiler-sdk.bst
- components/rocSPARSE.bst
- components/roctracer.bst

environment:
  # rocisa imports libclang-cpp at build time and Tensile needs hipconfig and
  # the compiler on PATH. Leave ROCM_PATH unset so clang infers device libs.
  LD_LIBRARY_PATH: "%{rocm-llvm-prefix}/lib:%{rocm-prefix}/lib:%{rocm-gl-prefix}/lib"
  PATH: "%{rocm-prefix}/bin:%{rocm-llvm-prefix}/bin:/usr/bin:/bin:/usr/sbin:/sbin"

depends:
- freedesktop-sdk-extra.bst:components/openblas.bst
- components/amdsmi.bst
- components/hip-clr.bst
- components/rocm_smi_lib.bst
- components/rocprofiler-sdk.bst
- components/roctracer.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-libraries/projects/hipsparselt"
  # hipSPARSELt only supports gfx942/gfx950/gfx1250; let it select its own
  # default ("all") instead of forcing gfx1100 through the toolchain.
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
    -DROCM_GPU_TARGETS=
    -DGPU_TARGETS=all
    -DHIPSPARSELT_BUILD_TESTING=OFF
    -DHIPSPARSELT_ENABLE_BENCHMARKS=OFF
    -DHIPSPARSELT_ENABLE_SAMPLES=OFF
    -DHIPSPARSELT_ENABLE_FETCH=OFF
    -DHIPSPARSELT_ENABLE_THEROCK=ON
    -DFETCHCONTENT_SOURCE_DIR_NANOBIND=%{build-root}/nanobind-src
    -DNB_USE_SUBMODULE_DEPS=OFF
    -DNB_TEST=OFF
    -Dcblas_DIR=%{build-root}/files/cmake

sources:
  (>):
  # rocisa uses FetchContent for nanobind unconditionally; keep it offline.
  - kind: tar
    url: https://github.com/wjakob/nanobind/archive/refs/tags/v%{nanobind-version}.tar.gz
    base-dir: "*"
    directory: nanobind-src
    ref: 01f1f0cd0398743c18f33d07ae36ad410bd7f4a1e90683b508504de897d6e629
  - kind: local
    path: files/cmake
    directory: files/cmake

config:
  # The Tensile library installs AMDGPU HSACO objects that the FDSDK
  # stripper cannot classify.
  strip-commands: []
