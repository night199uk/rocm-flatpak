kind: cmake
description: |
  rocgdb

(@):
- elements/rocm-therock.bst
- elements/include/toolchain-amd-llvm.yml

build-depends:
- freedesktop-sdk.bst:components/bzip2.bst
- freedesktop-sdk.bst:components/expat.bst
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/gmp.bst
- freedesktop-sdk.bst:components/mpfr.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/xz.bst
- freedesktop-sdk.bst:components/zlib.bst
- freedesktop-sdk.bst:components/zstd.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/therock-ncurses.bst
- components/amd-comgr.bst
- components/amd-dbgapi.bst
- components/amd-llvm.bst

depends:
- freedesktop-sdk.bst:components/bzip2.bst
- freedesktop-sdk.bst:components/expat.bst
- freedesktop-sdk.bst:components/gmp.bst
- freedesktop-sdk.bst:components/mpfr.bst
- freedesktop-sdk.bst:components/xz.bst
- freedesktop-sdk.bst:components/zlib.bst
- freedesktop-sdk.bst:components/zstd.bst
- third-party/therock-ncurses.bst
- components/amd-comgr.bst
- components/amd-dbgapi.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  conf-root: "debug-tools/rocgdb"
  cmake-local: >-
    -DCMAKE_PREFIX_PATH="%{rocm-runtime-prefix};%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DPATCHELF=/usr/bin/patchelf
    -DBUILD_TESTING=OFF
    -DROCM_VERSION=7.14.0
    -DSHARED_PYTHON_EXECUTABLES=
    -DTHEROCK_BUNDLE_SYSDEPS=ON
    -DROCGDB_SOURCE_DIR=%{build-root}/debug-tools/rocgdb
