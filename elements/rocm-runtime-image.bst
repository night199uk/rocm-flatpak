kind: script
description: |
  Runtime-only parts of the ROCm stack.

build-depends:
- freedesktop-sdk.bst:bootstrap/bash.bst
- freedesktop-sdk.bst:bootstrap/coreutils.bst
- freedesktop-sdk.bst:components/findutils.bst
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst
- rocm-runtime.bst

config:
  commands:
  - |
    set -e
    src="/usr/lib/%{gcc_triplet}/GL/ROCm"
    dst="%{install-root}%{rocm-runtime-prefix}"
    mkdir -p "$dst"
    for d in bin etc lib share; do
      if [ -d "$src/$d" ]; then
        cp -a "$src/$d" "$dst/"
      fi
    done
    # The runtime core is built with the SDK's compiler, but only the LLVM
    # runtime libraries and device bitcode ship in the runtime extension.
    sdk_llvm="%{rocm-sdk-llvm-prefix}"
    mkdir -p "$dst/lib/llvm"
    for d in lib amdgcn; do
      if [ -d "$sdk_llvm/$d" ]; then
        cp -a "$sdk_llvm/$d" "$dst/lib/llvm/"
      fi
    done
    rm -rf \
      "$dst/include" \
      "$dst/libexec" \
      "$dst/lib/cmake" \
      "$dst/lib/pkgconfig" \
      "$dst/lib/llvm/bin" \
      "$dst/lib/llvm/include" \
      "$dst/lib/llvm/share" \
      "$dst/lib/llvm/lib/cmake" \
      "$dst/lib/llvm/libexec" \
      "$dst/lib/llvm/lib/pkgconfig" \
      "$dst/share/doc" \
      "$dst/share/man" \
      "$dst/share/info"
    find "$dst" -name '*.a' -delete
    # libnuma is not part of the base runtime but is required by HSA and
    # rocminfo. Keep it alongside the rest of the runtime libraries.
    for f in "/usr/lib/%{gcc_triplet}"/libnuma.so* \
             "/usr/lib/%{gcc_triplet}"/libelf.so* \
             "/usr/lib/%{gcc_triplet}"/libelf-*.so*; do
      [ -e "$f" ] && cp -a "$f" "$dst/lib/"
    done
    # The GL extension point adds only <prefix>/lib to LD_LIBRARY_PATH. Expose
    # the LLVM shared libraries required by libamd_comgr through that directory.
    for f in "$dst"/lib/llvm/lib/libLLVM.so.* "$dst"/lib/llvm/lib/libclang-cpp.so.*; do
      [ -e "$f" ] || continue
      ln -sf "llvm/lib/$(basename "$f")" "$dst/lib/"
    done
    # Flatpak's GL extension point merges OpenCL/vendors and the other
    # vendor directories relative to the extension root. rocm-amd-mesa
    # installs OpenCL under etc/OpenCL and the vendor library under
    # lib/opencl, so expose the layouts expected by the extension point.
    if [ -d "$dst/etc/OpenCL" ]; then
      ln -sfn etc/OpenCL "$dst/OpenCL"
    fi
    for f in "$dst"/lib/opencl/libamdocl64.so*; do
      [ -e "$f" ] || continue
      ln -sfn "opencl/$(basename "$f")" "$dst/lib/"
    done
    if [ -d "$dst/share/glvnd" ]; then
      ln -sfn share/glvnd "$dst/glvnd"
    fi
    if [ -d "$dst/lib/vdpau" ]; then
      ln -sfn lib/vdpau "$dst/vdpau"
    fi
    if [ -d "$dst/lib/vulkan" ]; then
      ln -sfn lib/vulkan "$dst/vulkan"
    elif [ -d "$dst/share/vulkan" ]; then
      ln -sfn share/vulkan "$dst/vulkan"
    fi
