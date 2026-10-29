kind: meson
description: |
  ROCm libdrm

build-depends:
- freedesktop-sdk.bst:components/python3-docutils.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst

depends:
- freedesktop-sdk.bst:components/xorg-lib-pciaccess.bst
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst

variables:
  prefix: "/usr/lib/%{gcc_triplet}/GL/ROCm"
  meson-local: >-
    -Dintel=disabled
    -Dradeon=disabled
    -Damdgpu=enabled
    -Dnouveau=disabled
    -Dvmwgfx=disabled
    -Domap=disabled
    -Dexynos=disabled
    -Dfreedreno=disabled
    -Dtegra=disabled
    -Dvc4=disabled
    -Detnaviv=disabled
    -Dcairo-tests=disabled
    -Dvalgrind=disabled
    -Dudev=false

public:
  bst:
    split-rules:
      devel:
        (>):
        - '%{libdir}/libdrm.so'

sources:
- kind: git_repo
  url: freedesktop:mesa/drm.git
  # On release branches, we need to lock it to a specific version.
  track: libdrm-*
  ref: e984d448b8b17aab853369e6c203e53719f46de1
