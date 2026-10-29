kind: flatpak_repo

build-depends:
- freedesktop-sdk.bst:bootstrap/bash.bst
- freedesktop-sdk.bst:bootstrap/coreutils.bst
- freedesktop-sdk.bst:components/flatpak-minimal.bst
- filename: rocm-runtime-extension.bst
  config:
    flatpak-image: True

config:
  branch: "%{branch}"
