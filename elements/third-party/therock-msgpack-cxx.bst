kind: cmake
description: |
  therock-msgpack-cxx - upstream project built directly from its release archive.

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  cmake-local: >-
    -DMSGPACK_USE_BOOST=OFF
    -DMSGPACK_BUILD_TESTS=OFF
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON

sources:
- kind: tar
  url: https://github.com/msgpack/msgpack-c/releases/download/cpp-%{msgpack-cxx-version}/msgpack-cxx-%{msgpack-cxx-version}.tar.gz
  base-dir: "*"
  ref: 7504b7af7e7b9002ce529d4f941e1b7fb1fb435768780ce7da4abaac79bb156f
