kind: cmake
description: |
  rocFFT

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-hip.yml

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/sqlite.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- freedesktop-sdk-extra.bst:components/boost.bst
- third-party/therock-fftw3.bst
- third-party/therock-fftw3f.bst
- third-party/therock-googletest.bst
- components/amd-llvm.bst
- components/hip-clr.bst
- components/hipRAND.bst
- components/rocm-cmake.bst

depends:
- components/hip-clr.bst
- components/hipRAND.bst

environment:
  # rocfft_aot_helper loads libhiprtc, which links libclang-cpp from the
  # amd-llvm tree; build-time executables do not inherit the install RPATH.
  LD_LIBRARY_PATH: "%{rocm-llvm-prefix}/lib:%{rocm-prefix}/lib:%{rocm-gl-prefix}/lib"

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-libraries/projects/rocfft"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
    -DROCM_PATH=
    -DROCM_DIR=
    -DBUILD_CLIENTS=OFF
    -DBUILD_SHARED_LIBS=ON
    -DUSE_HIPRAND=ON
    -DROCFFT_KERNEL_CACHE_ENABLE=ON
    -DBUILD_CLIENTS_TESTS=OFF
    -DBUILD_CLIENTS_BENCH=OFF
    -DSQLITE_USE_SYSTEM_PACKAGE=ON

sources:
  (>):
    - kind: patch
      path: patch/0001-fix-sqlite-version.patch
      strip-level: 1
