kind: autotools
description: |
  therock-ncurses - upstream ncurses built from TheRock's bundled archive.

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst

variables:
  prefix: "%{rocm-prefix}"
  conf-local: >-
    --with-shared
    --without-debug
    --without-ada
    --enable-overwrite
    --disable-static

sources:
- kind: tar
  url: rocm-third-party-deps:ncurses-%{ncurses-version}.tar.gz
  base-dir: "*"
  ref: 355b4cbbed880b0381a04c46617b7656e362585d52e9cf84a67e2009b749ff11
