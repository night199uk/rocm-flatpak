kind: meson
description: |
  ROCm amd-mesa-fork

build-depends:
- freedesktop-sdk.bst:components/bison.bst
- freedesktop-sdk.bst:components/flex.bst
- freedesktop-sdk.bst:components/glslang.bst
- freedesktop-sdk.bst:components/llvm.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/python3-mako.bst
- freedesktop-sdk.bst:components/python3-packaging.bst
- freedesktop-sdk.bst:components/python3-ply.bst
- freedesktop-sdk.bst:components/python3-pycparser.bst
- freedesktop-sdk.bst:components/python3-pyyaml.bst
- freedesktop-sdk.bst:components/rust.bst
- freedesktop-sdk.bst:components/rust-bindgen.bst
- freedesktop-sdk.bst:components/rust-cbindgen.bst
- freedesktop-sdk.bst:components/spirv-llvm-translator.bst
- freedesktop-sdk.bst:components/spirv-tools.bst
- freedesktop-sdk.bst:components/vulkan-headers.bst
- freedesktop-sdk.bst:components/wayland-protocols.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst

depends:
- freedesktop-sdk.bst:components/libglvnd.bst
- freedesktop-sdk.bst:components/libpng.bst
- freedesktop-sdk.bst:components/libunwind.bst
- freedesktop-sdk.bst:components/libva.bst
- freedesktop-sdk.bst:components/libvdpau.bst
- freedesktop-sdk.bst:components/opencl.bst
- freedesktop-sdk.bst:components/vulkan-icd-loader.bst
- freedesktop-sdk.bst:components/wayland.bst
- freedesktop-sdk.bst:components/xorg-lib-x11.bst
- freedesktop-sdk.bst:components/xorg-lib-xfixes.bst
- freedesktop-sdk.bst:components/xorg-lib-xrandr.bst
- freedesktop-sdk.bst:components/xorg-lib-xshmfence.bst
- freedesktop-sdk.bst:components/xorg-lib-xxf86vm.bst
- freedesktop-sdk.bst:components/zstd.bst
- freedesktop-sdk.bst:extensions/mesa/libclc.bst
- freedesktop-sdk.bst:extensions/mesa/llvm.bst
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst
- components/rocm-libdrm.bst

environment:
  PKG_CONFIG_PATH: "%{libdir}/pkgconfig:%{datadir}/pkgconfig"
  CXXFLAGS: "%{target_flags} -std=gnu++17"

variables:
  prefix: "/usr/lib/%{gcc_triplet}/GL/ROCm"
  lib: "lib"
  debugdir: "/usr/lib/debug"
  debugdatadir: "%{debugdir}%{prefix}"
  optimize-debug: "false"

  meson-lto-flags: ''
  meson-local: >-
    -Db_ndebug=true
    -Degl=disabled
    -Dgallium-drivers=radeonsi
    -Dgallium-rusticl=false
    -Dgallium-va=enabled
    -Dgbm=disabled
    -Dgbm-backends-path="/usr/lib/%{gcc_triplet}/GL/lib/gbm"
    -Dgles1=disabled
    -Dgles2=disabled
    -Dglvnd=disabled
    -Dglx=auto
    -Dllvm=disabled
    -Dopengl=false
    -Dvideo-codecs=h264dec,h265dec,av1dec,vp9dec,jpegdec
    -Dlibva:with_glx=no
    -Dlibva:with_wayland=no
    -Dlibva:with_x11=no
    -Dvalgrind=disabled
    -Dvulkan-drivers=
    -Dvulkan-icd-dir="%{libdir}/vulkan/icd.d"
    -Dplatforms=
    -Dzlib=disabled
    -Dzstd=disabled
    -Dshader-cache=disabled
    -Dexpat=disabled

config:
  install-commands:
    (>):
    - |
      mkdir -p "%{install-root}%{libdir}"
      # mv "%{install-root}%{sysconfdir}/OpenCL" "%{install-root}%{libdir}/"
      ln -s libEGL_mesa.so.0 %{install-root}%{libdir}/libEGL_indirect.so.0
      ln -s libGLX_mesa.so.0 %{install-root}%{libdir}/libGLX_indirect.so.0
      rm -f "%{install-root}%{libdir}"/libGLESv2*
      rm -f "%{install-root}%{libdir}/libGLX_mesa.so"
      rm -f "%{install-root}%{libdir}/libEGL_mesa.so"
      rm -f "%{install-root}%{libdir}/libglapi.so"

    - |
      if [ -f "%{install-root}%{includedir}/vulkan/vulkan_intel.h" ]; then
        mkdir -p "%{install-root}%{includedir}/%{gcc_triplet}/vulkan"
        mv "%{install-root}%{includedir}/vulkan/vulkan_intel.h" "%{install-root}%{includedir}/%{gcc_triplet}/vulkan/"
      fi

    - |
      ln -sr '%{install-root}%{datadir}/glvnd' '%{install-root}%{prefix}/glvnd'
      mkdir -p '%{install-root}%{prefix}/vulkan'
      ln -sr '%{install-root}%{libdir}/vulkan/icd.d' '%{install-root}%{prefix}/vulkan/icd.d'
      ln -sr '%{install-root}%{datadir}/vulkan/explicit_layer.d' '%{install-root}%{prefix}/vulkan/explicit_layer.d'
      ln -sr '%{install-root}%{datadir}/vulkan/implicit_layer.d' '%{install-root}%{prefix}/vulkan/implicit_layer.d'
      ln -sr '%{install-root}%{libdir}/OpenCL' '%{install-root}%{prefix}/OpenCL'
      ln -sr '%{install-root}%{libdir}/vdpau' '%{install-root}%{prefix}/vdpau'

    - |
      DIR="%{install-root}%{project_licensedir}/mesa"
      mkdir -p "$DIR"
      cp -rv licenses/* "$DIR"

public:
  bst:
    split-rules:
      devel:
        (>):
        - '%{libdir}/libgbm.so'
        - '%{libdir}/libglapi.so'
        - '%{libdir}/libwayland-egl.so'
        - '%{libdir}/libMesaOpenCL.so'
        - '%{libdir}/d3d/d3dadapter9.so'
  cpe:
    product: mesa
    vendor: mesa3d

sources:
- kind: git_repo
  url: github:ROCm/mesa-fork.git
  track: therock-7.14
  ref: 22abfc06d7cf4c115ca2e368505d75ba4af174b4
- kind: tar
  directory: subprojects/packagecache/syn-2.0.87
  url: crates:crates/syn/syn-2.0.87.crate
  ref: 25aa4ce346d03a6dcd68dd8b4010bcb74e54e62c90c573f394c46eae99aba32d
- kind: tar
  directory: subprojects/packagecache/unicode-ident-1.0.12
  url: crates:crates/unicode-ident/unicode-ident-1.0.12.crate
  ref: 3354b9ac3fae1ff6755cb6db53683adb661634f67557942dea4facebec0fee4b
- kind: tar
  directory: subprojects/packagecache/quote-1.0.35
  url: crates:crates/quote/quote-1.0.35.crate
  ref: 291ec9ab5efd934aaf503a6466c5d5251535d108ee747472c3977cc5acc868ef
- kind: tar
  directory: subprojects/packagecache/syn-2.0.87
  url: crates:crates/syn/syn-2.0.87.crate
  ref: 25aa4ce346d03a6dcd68dd8b4010bcb74e54e62c90c573f394c46eae99aba32d
- kind: tar
  directory: subprojects/packagecache/unicode-ident-1.0.12
  url: crates:crates/unicode-ident/unicode-ident-1.0.12.crate
  ref: 3354b9ac3fae1ff6755cb6db53683adb661634f67557942dea4facebec0fee4b
- kind: tar
  directory: subprojects/packagecache/proc-macro2-1.0.86
  url: crates:crates/proc-macro2/proc-macro2-1.0.86.crate
  ref: 5e719e8df665df0d1c8fbfd238015744736151d4445ec0836b8e628aae103b77
- kind: tar
  directory: subprojects/packagecache/quote-1.0.35
  url: crates:crates/quote/quote-1.0.35.crate
  ref: 291ec9ab5efd934aaf503a6466c5d5251535d108ee747472c3977cc5acc868ef
- kind: tar
  directory: subprojects/packagecache/paste-1.0.14
  url: crates:crates/paste/paste-1.0.14.crate
  ref: de3145af08024dea9fa9914f381a17b8fc6034dfb00f3a84013f7ff43f29ed4c
- kind: tar
  directory: subprojects/packagecache/roxmltree-0.20.0
  url: crates:crates/roxmltree/roxmltree-0.20.0.crate
  ref: 6c20b6793b5c2fa6553b250154b78d6d0db37e72700ae35fad9387a46f487c97
- kind: tar
  directory: subprojects/packagecache/equivalent-1.0.1
  url: crates:crates/equivalent/equivalent-1.0.1.crate
  ref: 5443807d6dff69373d433ab9ef5378ad8df50ca6298caf15de6e52e24aaf54d5
- kind: tar
  directory: subprojects/packagecache/hashbrown-0.14.1
  url: crates:crates/hashbrown/hashbrown-0.14.1.crate
  ref: 7dfda62a12f55daeae5015f81b0baea145391cb4520f86c248fc615d72640d12
- kind: tar
  directory: subprojects/packagecache/indexmap-2.2.6
  url: crates:crates/indexmap/indexmap-2.2.6.crate
  ref: 168fb715dda47215e360912c096649d23d58bf392ac62f73919e831745e40f26
- kind: tar
  directory: subprojects/packagecache/once_cell-1.8.0
  url: crates:crates/once_cell/once_cell-1.8.0.crate
  ref: 692fcb63b64b1758029e0a96ee63e049ce8c5948587f2f7208df04625e5f6b56
- kind: tar
  directory: subprojects/packagecache/pest-2.8.0
  url: crates:crates/pest/pest-2.8.0.crate
  ref: 198db74531d58c70a361c42201efde7e2591e976d518caf7662a47dc5720e7b6
- kind: tar
  directory: subprojects/packagecache/pest_derive-2.8.0
  url: crates:crates/pest_derive/pest_derive-2.8.0.crate
  ref: d725d9cfd79e87dccc9341a2ef39d1b6f6353d68c4b33c177febbe1a402c97c5
- kind: tar
  directory: subprojects/packagecache/pest_generator-2.8.0
  url: crates:crates/pest_generator/pest_generator-2.8.0.crate
  ref: db7d01726be8ab66ab32f9df467ae8b1148906685bbe75c82d1e65d7f5b3f841
- kind: tar
  directory: subprojects/packagecache/pest_meta-2.8.0
  url: crates:crates/pest_meta/pest_meta-2.8.0.crate
  ref: 7f9f832470494906d1fca5329f8ab5791cc60beb230c74815dff541cbd2b5ca0
- kind: tar
  directory: subprojects/packagecache/ucd-trie-0.1.6
  url: crates:crates/ucd-trie/ucd-trie-0.1.6.crate
  ref: ed646292ffc8188ef8ea4d1e0e0150fb15a5c2e12ad9b8fc191ae7a8a7f3c4b9
- kind: tar
  directory: subprojects/packagecache/rustc-hash-2.1.1
  url: crates:crates/rustc-hash/rustc-hash-2.1.1.crate
  ref: 357703d41365b4b27c590e3ed91eabb1b663f07c4c084095e60cbed4362dff0d
