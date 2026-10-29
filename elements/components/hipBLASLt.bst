kind: cmake
description: |
  hipBLASLt

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
- freedesktop-sdk-extra.bst:components/boost.bst
- freedesktop-sdk-extra.bst:components/openblas.bst
- freedesktop-sdk-extra.bst:components/python-numpy.bst
- freedesktop-sdk-extra.bst:components/python3-joblib.bst
- freedesktop-sdk-extra.bst:components/python3-msgpack.bst
- third-party/therock-fmt.bst
- third-party/therock-googletest.bst
- third-party/therock-libdivide.bst
- third-party/therock-msgpack-cxx.bst
- third-party/therock-nanobind.bst
- third-party/therock-robin-map.bst
- third-party/therock-spdlog.bst
- third-party/therock-yaml-cpp.bst
- components/amd-llvm.bst
- components/amdsmi.bst
- components/hip-clr.bst
- components/hipBLAS-common.bst
- components/mxDataGenerator.bst
- components/rocm-cmake.bst
- components/rocm_smi_lib.bst
- components/rocprofiler-sdk.bst
- components/rocRoller.bst
- components/roctracer.bst

depends:
- freedesktop-sdk-extra.bst:components/openblas.bst
- components/amdsmi.bst
- components/hip-clr.bst
- components/rocm_smi_lib.bst
- components/rocprofiler-sdk.bst
- components/rocRoller.bst
- components/roctracer.bst

environment:
  # TensileLite imports rocisa._rocisa, which links libclang-cpp from the
  # amd-llvm tree. Build-time imports do not inherit the install RPATH.
  LD_LIBRARY_PATH: "%{rocm-llvm-prefix}/lib:%{rocm-prefix}/lib:%{rocm-gl-prefix}/lib"
  # TheRock's rocBLAS/hipBLASLt pre-hooks prepend the ROCm and LLVM bin
  # directories so Tensile can find hipconfig and the compiler. ROCM_PATH is
  # deliberately left unset: clang then derives the device library location
  # from its own install path.
  PATH: "%{rocm-prefix}/bin:%{rocm-llvm-prefix}/bin:/usr/bin:/bin:/usr/sbin:/sbin"

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-libraries/projects/hipblaslt"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
    -DHIPBLASLT_ENABLE_BLIS=OFF
    -DHIPBLASLT_ENABLE_CLIENT=OFF
    -DHIPBLASLT_ENABLE_SAMPLES=OFF
    -DTENSILELITE_BUILD_TESTING=OFF
    -DTENSILELITE_ENABLE_CLIENT=OFF
    -DHIPBLASLT_BUILD_TESTING=OFF
    -DHIPBLASLT_INSTALL_TENSILELITE_TEST_ARTIFACTS=OFF
    -DROCISA_USE_STABLE_ABI=ON
    -DROCISA_STANDALONE=ON
    -DHIPBLASLT_ENABLE_ROCROLLER=ON
    -DHIPBLASLT_ENABLE_FETCH=OFF
    -DHIPBLASLT_ENABLE_THEROCK=ON
    -DFETCHCONTENT_SOURCE_DIR_NANOBIND=%{build-root}/nanobind-src
    -DNB_USE_SUBMODULE_DEPS=OFF
    -DNB_TEST=OFF

sources:
  (>):
  # rocisa uses FetchContent for nanobind unconditionally in subdirectory
  # builds; provide the archive locally so the configure step stays offline.
  - kind: tar
    url: https://github.com/wjakob/nanobind/archive/refs/tags/v%{nanobind-version}.tar.gz
    base-dir: "*"
    directory: nanobind-src
    ref: 01f1f0cd0398743c18f33d07ae36ad410bd7f4a1e90683b508504de897d6e629

config:
  # The install contains AMDGPU HSACO objects; the FDSDK stripper cannot
  # identify their ELF architecture and aborts.
  strip-commands: []
