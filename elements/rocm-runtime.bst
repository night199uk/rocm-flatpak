kind: stack
description: |
  Runtime component for the Flatpak GL.ROCm extension.

depends:
- components/amd-comgr.bst
- components/amd-llvm.bst
- components/ocl-clr.bst
- components/ocl-icd.bst
- components/rocm-amd-mesa.bst
- components/rocm-core.bst
- components/rocm-libdrm.bst
- components/rocminfo.bst
- components/rocprofiler-register.bst
- components/ROCR-Runtime.bst
