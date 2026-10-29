kind: cmake
description: |
  therock-frugally-deep - upstream project built directly from its release archive.

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- third-party/nlohmann-json.bst
- third-party/therock-eigen.bst
- third-party/therock-FunctionalPlus.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  cmake-local: >-
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    -DFDEEP_BUILD_UNITTESTS=OFF
    -DFDEEP_BUILD_EXAMPLES=OFF
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON

sources:
- kind: tar
  url: https://github.com/Dobiasd/frugally-deep/archive/refs/tags/v%{frugally-deep-version}.tar.gz
  base-dir: "*"
  ref: 49bf5e30ad2d33e464433afbc8b6fe8536fc959474004a1ce2ac03d7c54bc8ba
