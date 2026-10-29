kind: cmake
description: |
  therock-yaml-cpp - upstream project built directly from its release archive.

  Carries TheRock's GCC 15 <cstdint> source patch.

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/therock-fmt.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  cmake-local: >-
    -DYAML_BUILD_SHARED_LIBS=OFF
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    -DYAML_CPP_BUILD_TESTS=OFF
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON

sources:
- kind: tar
  url: https://github.com/jbeder/yaml-cpp/archive/refs/tags/%{yaml-cpp-version}.tar.gz
  base-dir: "*"
  ref: fbe74bbdcee21d656715688706da3c8becfd946d92cd44705cc6098bb23b3a16
- kind: patch
  path: patch/0001-yaml-cpp-cstdint.patch
  strip-level: 1
