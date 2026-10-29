kind: cmake
description: |
  therock-grpc - upstream project built directly from its release archive.

  Carries TheRock's post-install relocatable-config patch.

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/sed.bst
- freedesktop-sdk.bst:components/zlib.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  cmake-local: >-
    -DBUILD_SHARED_LIBS=OFF
    -DgRPC_BUILD_SHARED_LIBS=OFF
    -DgRPC_PREFER_STATIC_LIBS=ON
    -Dprotobuf_BUILD_SHARED_LIBS=OFF
    -DgRPC_ZLIB_PROVIDER=package
    -DgRPC_ABSL_PROVIDER=module
    -DgRPC_CARES_PROVIDER=module
    -DgRPC_RE2_PROVIDER=module
    -DgRPC_SSL_PROVIDER=module
    -DgRPC_PROTOBUF_PROVIDER=module
    -DgRPC_BUILD_TESTS=OFF
    -DgRPC_BUILD_CSHARP_EXT=OFF
    -DgRPC_BUILD_GRPC_CSHARP_PLUGIN=OFF
    -DgRPC_BUILD_GRPC_NODE_PLUGIN=OFF
    -DgRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN=OFF
    -DgRPC_BUILD_GRPC_PHP_PLUGIN=OFF
    -DgRPC_BUILD_GRPC_PYTHON_PLUGIN=OFF
    -DgRPC_BUILD_GRPC_RUBY_PLUGIN=OFF
    -DgRPC_INSTALL=ON
    -DCMAKE_INSTALL_LIBDIR=lib
    -DCMAKE_BUILD_RPATH_USE_ORIGIN=ON
    -DCMAKE_SKIP_BUILD_RPATH=OFF
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON
    -DCMAKE_CXX_STANDARD=17
    -DCMAKE_CXX_VISIBILITY_PRESET=hidden
    -DCMAKE_C_VISIBILITY_PRESET=hidden
    -DCMAKE_VISIBILITY_INLINES_HIDDEN=ON

sources:
- kind: git
  url: https://github.com/grpc/grpc.git
  track: v%{grpc-version}
  ref: 5b6492ea90b2b867a6adad1b10a6edda28e860d1
  checkout-submodules: true
- kind: local
  path: files/grpc/patch_install_linux.sh
  directory: files/grpc

config:
  install-commands:
    (>):
      - |
        THEROCK_SOURCE_DIR="%{build-root}" bash files/grpc/patch_install_linux.sh "%{install-root}%{prefix}"
