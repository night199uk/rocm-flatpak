kind: autotools
description: |
  therock-hwloc - upstream hwloc built from TheRock's bundled archive.

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst

variables:
  prefix: "%{rocm-prefix}"
  conf-local: >-
    --disable-static
    --enable-shared

sources:
- kind: tar
  url: rocm-third-party-deps:hwloc-%{hwloc-version}.tar.bz2
  base-dir: "*"
  ref: a4494b7765f517c0990d1c7f09d98cb87755bb6b841e4e2cbfebca1b14bac9c8
