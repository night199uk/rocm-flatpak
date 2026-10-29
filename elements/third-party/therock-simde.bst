kind: meson
description: |
  therock-simde - upstream project built directly from its release archive.

build-depends:
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patchelf.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst

variables:
  prefix: "%{rocm-prefix}"
  lib: "lib"
  meson-local: >-
    -Dtests=false

sources:
- kind: tar
  url: https://github.com/simd-everywhere/simde/archive/refs/tags/v%{simde-version}.tar.gz
  base-dir: "*"
  ref: ed2a3268658f2f2a9b5367628a85ccd4cf9516460ed8604eed369653d49b25fb
- kind: local
  path: files/simde/simde.pc
  directory: files/simde

config:
  install-commands:
    (>):
      - |
        install -Dm0644 files/simde/simde.pc "%{install-root}%{prefix}/lib/pkgconfig/simde.pc"
