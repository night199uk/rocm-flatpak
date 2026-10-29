# amd-hip CMake toolchain, reproducing TheRock's COMPILER_TOOLCHAIN=amd-hip.
#
# This is the amd-llvm toolchain plus HIP discovery flags. Additional input:
#   ROCM_HIP_PREFIX  Install prefix of the hip-clr element.

include("${CMAKE_CURRENT_LIST_DIR}/amd-llvm.cmake")

if(NOT DEFINED ROCM_HIP_PREFIX OR ROCM_HIP_PREFIX STREQUAL "")
  message(FATAL_ERROR "amd-hip toolchain: ROCM_HIP_PREFIX is not set")
endif()

# GCC 16 libstdc++ uses a __gnu__ attribute that HIP's __noinline__ macro
# would otherwise rewrite while parsing <format>.
string(APPEND CMAKE_CXX_FLAGS " -include ${CMAKE_CURRENT_LIST_DIR}/preinclude.h")

string(APPEND CMAKE_CXX_FLAGS_INIT " --hip-path=${ROCM_HIP_PREFIX}")
string(APPEND CMAKE_CXX_FLAGS_INIT
  " --hip-device-lib-path=${ROCM_LLVM_PREFIX}/amdgcn/bitcode")

list(PREPEND CMAKE_PREFIX_PATH "${ROCM_HIP_PREFIX}")
