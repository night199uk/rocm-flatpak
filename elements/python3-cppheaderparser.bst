kind: pip
description: |
  CppHeaderParser

variables:
  prefix: "/usr"

build-depends:
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/python3-pip.bst
- freedesktop-sdk.bst:components/python3-ply.bst
- freedesktop-sdk.bst:components/python3-setuptools.bst
- freedesktop-sdk.bst:components/stripper.bst

depends:
- freedesktop-sdk.bst:bootstrap/bash.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/python3-pip.bst
- freedesktop-sdk.bst:components/python3-ply.bst

sources:
- kind: tar
  url: 
    pypi:3c/ba/d8d168a4b54cae66eaf13d1d9197ca9349c94653815e061f79e7eed86c01/CppHeaderParser-2.7.4.tar.gz
  ref: 382b30416d95b0a5e8502b214810dcac2a56432917e2651447d3abe253e3cc42

#- kind: pip
#  packages:
#  - CppHeaderParser
#  ref: "CppHeaderParser==2.7.4"
