kind: cmake
description: |
  rocprofiler-systems

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-hip.yml

build-depends:
- freedesktop-sdk.bst:components/elfutils.bst
- freedesktop-sdk.bst:components/gawk.bst
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/grep.bst
- freedesktop-sdk.bst:components/libunwind.bst
- freedesktop-sdk.bst:components/make.bst
- freedesktop-sdk.bst:components/os-release.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/sed.bst
- freedesktop-sdk.bst:components/sqlite.bst
- freedesktop-sdk.bst:components/which.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/nlohmann-json.bst
- third-party/therock-fmt.bst
- third-party/therock-googletest.bst
- third-party/therock-spdlog.bst
- third-party/therock-yaml-cpp.bst
- components/amd-llvm.bst
- components/amdsmi.bst
- components/aqlprofile.bst
- components/hip-clr.bst
- components/rocm-libdrm.bst
- components/rocprofiler-register.bst
- components/rocprofiler-sdk.bst
- libiberty.bst
- onetbb.bst

depends:
- freedesktop-sdk.bst:components/elfutils.bst
- freedesktop-sdk.bst:components/sqlite.bst
- third-party/nlohmann-json.bst
- third-party/therock-googletest.bst
- components/amdsmi.bst
- components/aqlprofile.bst
- components/hip-clr.bst
- components/rocm-libdrm.bst
- components/rocprofiler-register.bst
- components/rocprofiler-sdk.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "rocm-systems/projects/rocprofiler-systems"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DHIP_PLATFORM=amd
    -DROCPROFSYS_BUILD_TBB=OFF
    -DROCPROFSYS_BUILD_LIBIBERTY=OFF
    -DROCPROFSYS_BUILD_DYNINST=ON
    -DROCPROFSYS_BUILD_FOR_THEROCK=ON
    -DROCPROFSYS_USE_PYTESTS=OFF
    -DROCPROFSYS_INSTALL_TESTING=OFF
    -DROCPROFSYS_BUILD_TESTING=OFF
    -DROCPROFSYS_BUILD_SPDLOG=OFF
    -DROCPROFSYS_BUILD_GTEST=OFF
    -DROCPROFSYS_BUILD_NLOHMANN_JSON=OFF
    -DROCPROFSYS_BUILD_LIBUNWIND=ON
    -DTIMEMORY_BUILD_YAML=OFF
    -DTIMEMORY_BUILD_LIBUNWIND=ON
    -DROCPROFSYS_BUILD_SQLITE3=OFF
    -DROCPROFSYS_USE_PYTHON=OFF
    -DROCPROFSYS_PYTHON_VERSIONS:STRING=
    -DROCPROFSYS_PYTHON_ROOT_DIRS:STRING=
    -DROCPROFSYS_USE_MPI=OFF
    -DTIMEMORY_BINUTILS_SOURCE_DIR=%{build-root}/timemory-binutils

sources:
  (>):
  - kind: patch
    path: patch/0001-papi-relax-warnings.patch
    strip-level: 1
  # timemory checks out this nested submodule during configure; stage it
  # offline instead of cloning from GitHub.
  - kind: git_module
    directory: rocm-systems/projects/rocprofiler-systems/external/timemory
    path: external/gotcha
    url: github:ROCm/GOTCHA
    full-clone: false
    ref: 6ef1232a0acc99f3340c2ca4c5d23890e9b8a459
  - kind: git_module
    directory: rocm-systems/projects/rocprofiler-systems/external/timemory
    path: external/libunwind
    url: github:libunwind/libunwind
    full-clone: false
    ref: 24947191d61dda869e039e0414fe97e9f594acd5
  - kind: patch
    path: patch/0001-timemory-local-binutils.patch
    strip-level: 1
  - kind: tar
    url: https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.xz
    ref: f6e4d41fd5fc778b06b7891457b3620da5ecea1006c6a4a41ae998109f85a800
    base-dir: "*"
    directory: timemory-binutils
  - kind: patch
    path: patch/0001-timemory-yaml-cpp-target.patch
    strip-level: 1
  - kind: patch
    path: patch/0001-dyninst-machregister-hash.patch
    strip-level: 1
