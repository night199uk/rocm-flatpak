kind: cmake
description: |
  amd-llvm

(@):
- elements/rocm-therock.bst

build-depends:
- freedesktop-sdk.bst:components/bison.bst
- freedesktop-sdk.bst:components/elfutils.bst
- freedesktop-sdk.bst:components/flex.bst
- freedesktop-sdk.bst:components/gawk.bst
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/libffi.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/python3-jinja2.bst
- freedesktop-sdk.bst:components/python3-mako.bst
- freedesktop-sdk.bst:components/python3-psutil.bst
- freedesktop-sdk.bst:components/python3-pyelftools.bst
- freedesktop-sdk.bst:components/python3-pyyaml.bst
- freedesktop-sdk.bst:components/texinfo.bst
- freedesktop-sdk.bst:components/vim.bst
- freedesktop-sdk.bst:components/zlib.bst
- freedesktop-sdk.bst:components/zstd.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- freedesktop-sdk-extra.bst:components/numactl.bst
- components/rocm-cmake.bst
- components/rocm-libdrm.bst

depends:
- freedesktop-sdk.bst:components/elfutils.bst
- freedesktop-sdk.bst:components/zlib.bst
- freedesktop-sdk.bst:components/zstd.bst
- freedesktop-sdk-extra.bst:components/numactl.bst
- components/rocm-libdrm.bst

variables:
  prefix: "%{rocm-prefix}/lib/llvm"
  lib: "lib"
  conf-root: "compiler/amd-llvm/llvm"
  cmake-local: >-
    -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=%{build-root}/compiler/pre_hook_amd-llvm.cmake
    -DCMAKE_PREFIX_PATH="%{rocm-prefix};%{rocm-llvm-prefix};%{rocm-prefix}/lib/rocm_sysdeps;%{rocm-gl-prefix};/usr"
    -DTHEROCK_SOURCE_DIR=%{build-root}
    -DTHEROCK_ROCM_SYSTEMS_SOURCE_DIR=%{build-root}/rocm-systems
    -DTHEROCK_BUILD_LLVM_TESTS=OFF
    -DTHEROCK_BUILD_LLVM_TOOLS=OFF
    -DTHEROCK_BUILD_COMGR_TESTS=OFF
    -DFLANG_PARALLEL_COMPILE_JOBS=2
    -DLLVM_PARALLEL_LINK_JOBS=1
    -DLLVM_ENABLE_PEDANTIC=OFF
    -DLLVM_APPEND_VC_REV=ON
    -DLLVM_FORCE_VC_REPOSITORY=
    -DLLVM_FORCE_VC_REVISION=
    -DLIBCXX_ENABLE_SHARED=OFF
    -DLIBCXX_ENABLE_STATIC=ON
    -DLIBCXX_INSTALL_LIBRARY=OFF
    -DLIBCXX_INSTALL_HEADERS=OFF
    -DLIBCXXABI_ENABLE_SHARED=OFF
    -DLIBCXXABI_ENABLE_STATIC=ON
    -DLLVM_INCLUDE_TESTS=OFF
    -DLLVM_ENABLE_ZLIB=FORCE_ON
    -DLLVM_ENABLE_Z3_SOLVER=OFF
    -DLLVM_ENABLE_LIBXML2=OFF
    -DCLANG_DEFAULT_LINKER=lld
    -DCLANG_DEFAULT_RTLIB=compiler-rt
    -DCLANG_DEFAULT_UNWINDLIB=libgcc
    -DCLANG_ENABLE_AMDCLANG=ON
    -DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF
    -DLLVM_BUILD_LLVM_C_DYLIB=OFF
    -DLLVM_BUILD_EXAMPLES=OFF
    -DLLVM_INCLUDE_EXAMPLES=OFF
    -DLLVM_TOOL_LLVM_JITLINK_BUILD=OFF
    -DLLVM_TOOL_LLVM_COV_BUILD=ON
    -DLLVM_TOOL_LLVM_PROFDATA_BUILD=ON
    -DCLANG_ENABLE_ARCMT=OFF
    -DCLANG_ENABLE_STATIC_ANALYZER=OFF
    -DCLANG_ENABLE_CLANGD=OFF
    -DCLANG_TIDY_ENABLE_STATIC_ANALYZER=OFF
    -DCLANG_TOOL_CLANG_LINKER_WRAPPER_BUILD=ON
    -DSANITIZER_AMDGPU=ON
    -DSANITIZER_HSA_INCLUDE_PATH=%{build-root}/rocm-systems/projects/rocr-runtime/runtime/hsa-runtime/inc
    -DSANITIZER_COMGR_INCLUDE_PATH=%{build-root}/compiler/amd-llvm/amd/comgr/include
    -DCOMPILER_RT_DEBUG=OFF

config:
  strip-commands: []
