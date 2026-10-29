kind: autotools
description: libiberty static library (from GNU binutils)

sources:
- kind: tar
  url: https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.xz
  ref: f6e4d41fd5fc778b06b7891457b3620da5ecea1006c6a4a41ae998109f85a800

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst

environment:
  # Forcefully injects CFLAGS directly into the build execution sandbox
  CFLAGS: "-fPIC"

variables:
  cflags: "-fPIC"
  conf-local: "--enable-install-libiberty"
  command-subdir: libiberty
