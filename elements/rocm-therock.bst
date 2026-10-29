kind: manual
description: |
  TheRock source bundle shared by the per-component elements.

sources:
- kind: git_tag
  url: rocm:TheRock
  checkout-submodules: false
  track: "%{rocmtag}"
  ref: therock-7.14-0-g418cd5f63abb7a604bad5874cd7b2e29334e640f

- kind: git_module
  path: base/half
  url: github:ROCm/half.git
  ref: 207ee58595a64b5c4a70df221f1e6e704b807811

- kind: git_module
  path: base/rocm-cmake
  url: github:ROCm/rocm-cmake.git
  ref: 10155d7272ea1bf79f6b5a9dbc339657af1aa372

- kind: git_module
  path: compiler/amd-llvm
  url: github:ROCm/llvm-project.git
  full-clone: false
  ref: therock-7.14-0-g46fcb339fb61119b337f973c7ca9e710a319fdd0

- kind: git_module
  path: compiler/hipify
  url: github:ROCm/HIPIFY.git
  ref: 6acec7751d2b2bfe162dba9efdcf7c16efb27bd8

- kind: git_module
  path: compiler/spirv-llvm-translator
  url: github:ROCm/SPIRV-LLVM-Translator.git
  ref: fb08e83ae872775acfeaee53fda3ccf99a04ba53

- kind: git_tag
  directory: compiler/spirv-llvm-translator
  url: github:KhronosGroup/SPIRV-Headers.git
  track: "%{spirv_headers_tag}"
  ref: vulkan-sdk-1.4.350.0-1-gb8a32968473ce852a809b9de5f04f02a5a9dfa78

- kind: git_module
  path: debug-tools/rocgdb/source
  url: github:ROCm/rocgdb.git
  ref: 36d878807f07f08e94f87b7d701de53ae2c4f207

- kind: git_module
  path: math-libs/libhipcxx
  url: github:ROCm/libhipcxx.git
  ref: fa4ccc6beb77bfaa59a6fbeeebc94a4f18678945

- kind: git_module
  path: rocm-libraries
  url: github:ROCm/rocm-libraries
  full-clone: false
  ref: therock-7.14-0-gcd9574023093742434e8c992d13b89ab9a6c1cf8

- kind: git_module
  path: rocm-systems
  url: github:ROCm/rocm-systems.git
  full-clone: false
  ref: therock-7.14-0-g2b22ab0195cc1461cd9abf3b969e9dd7c10af350

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-sdk/external/googletest
  url: github:google/googletest.git
  full-clone: false
  ref: 46db91ef6ffcc128b2d5f31118ae1108109e3400

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-register/external/glog
  url: github:google/glog.git
  full-clone: false
  ref: 7b134a5c82c0c0b5698bb6bf7a835b230c5638e4

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-sdk/external/fmt
  url: github:fmtlib/fmt.git
  full-clone: false
  ref: 407c905e45ad75fc29bf0f9bb7c5c2fd3475976f

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-register/external/fmt
  url: github:fmtlib/fmt.git
  full-clone: false
  ref: 123913715afeb8a437e6388b4473fcc4753e1c9a

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-sdk/external/ptl
  url: github:jrmadsen/PTL
  full-clone: false
  ref: 48df41625430d27ce43cf197fd467a8dda87cb45

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-sdk/external/cereal
  url: github:jrmadsen/cereal.git
  full-clone: false
  ref: 40a30defcb8874270a04836d316502b08904b2bc

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-sdk/external/filesystem
  url: github:gulrak/filesystem.git
  full-clone: false
  ref: 8a2edd6d92ed820521d42c94d179462bf06b5ed3

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-sdk/external/perfetto
  url: github:google/perfetto
  full-clone: false
  ref: eb5ef24c58d13cec289d733d03f0f3f0ed321b12

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-sdk/external/elfio
  url: github:serge1/ELFIO.git
  full-clone: false
  ref: 575bfdb12cd90fa8913660295103549f151d116a

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-sdk/external/yaml-cpp
  url: github:jbeder/yaml-cpp.git
  full-clone: false
  ref: 7b469b4220f96fb3d036cf68cd7bd30bd39e61d2

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-sdk/external/json
  url: github:nlohmann/json.git
  full-clone: false
  ref: e41905fcb0938a7502d25ea5242c6b41396e21b0

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-sdk/external/sqlite
  url: github:sqlite/sqlite
  full-clone: false
  ref: f5fb820c0f4781337faf02ed871be68d13a83d94

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-sdk/external/pybind11
  url: github:pybind/pybind11.git
  full-clone: false
  ref: 914c06fb252b6cc3727d0eedab6736e88a3fcb01

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-sdk/external/gotcha
  url: github:ROCm/GOTCHA
  full-clone: false
  ref: b944da10ff9b3364ef2e4b12e02cb2464e05dd48

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-systems/external/timemory
  url: github:ROCm/timemory.git
  full-clone: false
  ref: 54ae9d214a63132da22c7cab21c5fb4b7b5049f8

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-systems/external/perfetto
  url: github:google/perfetto.git
  full-clone: false
  ref: 35b3d9845c2f4017865c4dc93fafcf6d202f1651

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-systems/external/elfio
  url: github:jrmadsen/ELFIO.git
  full-clone: false
  ref: d00cc32f8b1ed85d22309fac10576a1baf8a4736

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-systems/external/dyninst
  url: github:ROCm/dyninst.git
  full-clone: false
  ref: 8d6f2bf3043f4307dc59d2b3e66514aac9a44160

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-systems/external/papi
  url: github:icl-utk-edu/papi.git
  full-clone: false
  ref: c27003e1642f1c151c9b18ef9e7610072b3c852d

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-systems/external/pybind11
  url: github:jrmadsen/pybind11.git
  full-clone: false
  ref: 1a917f1852eb7819b671fc3fa862840f4c491a07

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-systems/external/sqlite
  url: github:sqlite/sqlite.git
  full-clone: false
  ref: a5333afb9ad1aa473f8963b92caeaa955f47dc74

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-systems/external/googletest
  url: github:google/googletest.git
  full-clone: false
  ref: 6ec14dfd8c409d05fba94e18e3a02df35b874353

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-systems/external/filesystem
  url: github:gulrak/filesystem.git
  full-clone: false
  ref: 8a2edd6d92ed820521d42c94d179462bf06b5ed3

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-systems/external/spdlog
  url: github:gabime/spdlog.git
  full-clone: false
  ref: 79524ddd08a4ec981b7fea76afd08ee05f83755d

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-systems/external/json
  url: github:nlohmann/json.git
  full-clone: false
  ref: 55f93686c01528224f448c19128836e7df245f72

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-compute/src/vendored/pyyaml
  url: github:yaml/pyyaml.git
  full-clone: false
  ref: 49790e73684bebad1df05ef8d828fa12f685bffb

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-systems/external/onetbb
  url: github:uxlfoundation/oneTBB.git
  full-clone: false
  ref: f1862f38f83568d96e814e469ab61f88336cc595

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-sdk/external/abseil-cpp
  url: github:abseil/abseil-cpp.git
  full-clone: false
  ref: 255c84dadd029fd8ad25c5efb5933e47beaa00c7

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-compute/src/lib/external/fmt
  url: github:fmtlib/fmt.git
  full-clone: false
  ref: 407c905e45ad75fc29bf0f9bb7c5c2fd3475976f

- kind: git_module
  directory: rocm-systems
  path: projects/rocprofiler-compute/src/lib/external/json
  url: github:nlohmann/json.git
  full-clone: false
  ref: 98386eb08b609c172f9f4bf3e74c8d18c5ad583c

- kind: git_module
  path: optional-sources/hrx
  url: github:ROCm/hrx.git
  ref: 56e60cfdc8df89edd43f5ae507cd3fd7f5aafd03

- kind: git_tag
  directory: rocm-systems/projects/amdsmi/esmi_ib_library
  url: github:amd/esmi_ib_library.git
  track: "%{esmitag}"
  ref: esmi_pkg_ver-5.2.1.1-0-gd494a3194ceb4cc4dbb2debf9fcbe8773c6d3bef

- kind: git_lfs
  ref: f2e60b3a57672f9039c501c0bf6e2167bdfd26ddb352e401d432f1b0fddd6233

- kind: dvc
  ref: 970888b55fea95ae927366e800c0592a7594025ddb15a7a65f09843f90bde488

# NOTE: the third-party archives live in their owning elements; those wrappers
# still need the offline URL rewrite or replacement with real upstream elements.

# Shared CMake toolchain files used by elements/include/toolchain-*.yml.
- kind: local
  path: files/toolchain
  directory: files/toolchain
