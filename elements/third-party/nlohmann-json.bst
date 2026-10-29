kind: cmake

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst

depends:
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst

variables:
  cmake-local: >-
    -DBUILD_TESTING=OFF
    -DJSON_BuildTests=OFF

sources:
- kind: git_repo
  url: github:nlohmann/json.git
  track: v*
  ref: v3.12.0-0-g55f93686c01528224f448c19128836e7df245f72
