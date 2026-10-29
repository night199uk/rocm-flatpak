kind: flatpak_image

build-depends:
- rocm-sdk.bst
- rocm-sdk-metainfo.bst

config:
  directory: "%{rocm-prefix}"
  exclude:
    - debug
    - locale

  metadata:
    Runtime:
      name: org.freedesktop.Platform.amd.ROCm
      runtime: org.freedesktop.Platform/%{flatpak_arch}/%{branch}
      sdk: org.freedesktop.Sdk/%{flatpak_arch}/%{branch}

    ExtensionOf:
      ref: runtime/org.freedesktop.Platform/%{flatpak_arch}/%{branch}
