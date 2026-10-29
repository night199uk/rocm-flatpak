kind: cmake
description: |
  rocBLAS

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-hip.yml

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/procps.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/python3-packaging.bst
- freedesktop-sdk.bst:components/python3-psutil.bst
- freedesktop-sdk.bst:components/python3-pyyaml.bst
- freedesktop-sdk.bst:components/python3-setuptools.bst
- freedesktop-sdk.bst:components/python3-wheel.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- freedesktop-sdk-extra.bst:components/boost.bst
- freedesktop-sdk-extra.bst:components/python-numpy.bst
- freedesktop-sdk-extra.bst:components/python3-joblib.bst
- freedesktop-sdk-extra.bst:components/python3-msgpack.bst
- third-party/therock-googletest.bst
- third-party/therock-msgpack-cxx.bst
- components/amd-llvm.bst
- components/hip-clr.bst
- components/hipBLAS-common.bst
- components/hipBLASLt.bst
- components/rocm-cmake.bst
- components/rocm_smi_lib.bst
- components/rocprofiler-sdk.bst
- components/roctracer.bst

depends:
- components/hip-clr.bst
- components/hipBLASLt.bst
- components/rocm_smi_lib.bst
- components/rocprofiler-sdk.bst
- components/roctracer.bst

environment:
  # The Tensile venv install must stay offline and use the system Python
  # packages staged by this element.
  PIP_NO_INDEX: "1"
  PIP_NO_BUILD_ISOLATION: "1"
  PIP_NO_DEPS: "1"
  PIP_DISABLE_PIP_VERSION_CHECK: "1"
  LD_LIBRARY_PATH: "%{rocm-llvm-prefix}/lib:%{rocm-prefix}/lib:%{rocm-gl-prefix}/lib"
  # TheRock's rocBLAS pre-hook prepends the ROCm and LLVM bin directories so
  # Tensile can find hipconfig and the compiler. ROCM_PATH is deliberately
  # left unset: clang then derives the device library location from its own
  # install path.
  PATH: "%{rocm-prefix}/bin:%{rocm-llvm-prefix}/bin:/usr/bin:/bin:/usr/sbin:/sbin"

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-libraries/projects/rocblas"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
    -DROCM_PATH=
    -DROCM_DIR=
    -Dhipblaslt_path=
    -DBUILD_WITH_TENSILE=ON
    -DBUILD_WITH_HIPBLASLT=ON
    -DTensile_TEST_LOCAL_PATH=%{build-root}/rocm-libraries/shared/tensile
    -DTENSILE_VERSION=
    -DBUILD_CLIENTS_TESTS=OFF
    -DBUILD_CLIENTS_SAMPLES=OFF
    -DBUILD_CLIENTS_BENCHMARKS=OFF
    -DLINK_BLIS=OFF

sources:
  (>):
  - kind: patch
    path: patch/0001-rocblas-offline-venv.patch
    strip-level: 1
  - kind: patch
    path: patch/0001-rocblas-no-stdcxxfs.patch
    strip-level: 1

config:
  # The install contains AMDGPU HSACO objects; the FDSDK stripper cannot
  # identify their ELF architecture and aborts.
  strip-commands: []
