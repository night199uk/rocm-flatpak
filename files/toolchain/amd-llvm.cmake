# amd-llvm CMake toolchain, reproducing TheRock's COMPILER_TOOLCHAIN=amd-llvm.
#
# Inputs (passed as -D cache variables by the referencing element):
#   ROCM_LLVM_PREFIX  Install prefix of the amd-llvm element
#                     (${ROCM_ROCM_PREFIX}/lib/llvm by default).
#   ROCM_ROCM_PREFIX  The unified ROCm install prefix.
#   ROCM_GPU_TARGETS  ;-separated GPU targets, e.g. "gfx1100;gfx1101".

if(NOT DEFINED ROCM_LLVM_PREFIX OR ROCM_LLVM_PREFIX STREQUAL "")
  message(FATAL_ERROR "amd-llvm toolchain: ROCM_LLVM_PREFIX is not set")
endif()
if(NOT DEFINED ROCM_ROCM_PREFIX OR ROCM_ROCM_PREFIX STREQUAL "")
  message(FATAL_ERROR "amd-llvm toolchain: ROCM_ROCM_PREFIX is not set")
endif()

# TheRock sets THEROCK_TOOLCHAIN_ROOT to the dist tree so that legacy projects
# can find the compiler. Keep the same contract.
set(THEROCK_TOOLCHAIN_ROOT "${ROCM_ROCM_PREFIX}")

set(CMAKE_C_COMPILER   "${ROCM_LLVM_PREFIX}/bin/clang")
set(CMAKE_CXX_COMPILER "${ROCM_LLVM_PREFIX}/bin/clang++")
set(CMAKE_LINKER       "${ROCM_LLVM_PREFIX}/bin/lld")
set(CMAKE_AR           "${ROCM_LLVM_PREFIX}/bin/llvm-ar")
set(CMAKE_RANLIB       "${ROCM_LLVM_PREFIX}/bin/llvm-ranlib")

# Pin clang's resource directory rather than relying on auto-detection. This is
# what TheRock does to keep paths stable (and ccache-friendly).
file(GLOB _rocm_clang_resource_dirs "${ROCM_LLVM_PREFIX}/lib/clang/*")
if(_rocm_clang_resource_dirs)
  list(GET _rocm_clang_resource_dirs 0 _rocm_clang_resource_dir)
  string(APPEND CMAKE_C_FLAGS_INIT   " -resource-dir ${_rocm_clang_resource_dir}")
  string(APPEND CMAKE_CXX_FLAGS_INIT " -resource-dir ${_rocm_clang_resource_dir}")
endif()

# THEROCK_AMD_LLVM_DEFAULT_CXX_FLAGS from TheRock.
string(APPEND CMAKE_CXX_FLAGS_INIT
  " -Wno-documentation-unknown-command"
  " -Wno-documentation-pedantic"
  " -Wno-unused-command-line-argument"
  " -Wno-explicit-specialization-storage-class")

# GPU targets. TheRock writes these into its generated toolchain file with
# FORCE so that projects which try to auto-detect cannot override them.
if(DEFINED ROCM_GPU_TARGETS AND NOT ROCM_GPU_TARGETS STREQUAL "")
  set(AMDGPU_TARGETS "${ROCM_GPU_TARGETS}" CACHE STRING "From BuildStream" FORCE)
  set(GPU_TARGETS "${ROCM_GPU_TARGETS}" CACHE STRING "From BuildStream" FORCE)
  set(CMAKE_HIP_ARCHITECTURES "${ROCM_GPU_TARGETS}" CACHE STRING "From BuildStream" FORCE)
endif()

# Make components installed into the shared ROCm prefix discoverable, and use
# TheRock's in-tree find modules (Findbenchmark, FindBLAS, FindLAPACK).
if(DEFINED ROCM_SOURCE_ROOT AND NOT ROCM_SOURCE_ROOT STREQUAL "")
  list(PREPEND CMAKE_MODULE_PATH "${ROCM_SOURCE_ROOT}/cmake/finders")
endif()
list(PREPEND CMAKE_PREFIX_PATH "${ROCM_LLVM_PREFIX}")
list(APPEND CMAKE_PREFIX_PATH "${ROCM_ROCM_PREFIX}")
list(APPEND CMAKE_PREFIX_PATH "${ROCM_ROCM_PREFIX}/lib/rocm_sysdeps")
list(APPEND CMAKE_PREFIX_PATH "/usr")
