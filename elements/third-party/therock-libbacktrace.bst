kind: autotools
description: |
  therock-libbacktrace - upstream libbacktrace built from TheRock's archive.

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst

variables:
  prefix: "%{rocm-prefix}"
  conf-local: >-
    --enable-shared
    --disable-static

sources:
- kind: zip
  url: rocm-third-party-deps:libbacktrace-b9e40069c0b47a722286b94eb5231f7f05c08713.zip
  base-dir: "*"
  ref: d2162ff65da45db62e0a1d5fa7662d04b72247cc0ccedad8257cf00e801bb15e
