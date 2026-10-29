kind: cmake

# Define any system dependencies needed to build it
build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/llvm.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst

sources:
- kind: git_tag
  url: https://github.com/uxlfoundation/oneTBB.git
  track: v2022.3.0
  ref: f1862f38f83568d96e814e469ab61f88336cc595


variables:
  cmake-local: >-
    -DTBB_TEST=OFF
    -DTBB_STRICT=OFF
