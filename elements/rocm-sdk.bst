kind: stack
description: |
  ROCm SDK. Installs the compiler, HIP runtime, profiling tools,
  math/ML/media/communication/storage libraries, and headers under
  /usr/lib/<triplet>/dri/amd/ROCm.

depends:
# Compiler and core SDK
- components/amd-llvm.bst
- components/amdsmi.bst
- components/hip-clr.bst
- components/hipcc.bst
- components/hipify.bst
- components/rocm-kpack.bst
- components/rocm_smi_lib.bst

# Profiling
- components/aqlprofile.bst
- components/rdc.bst
- components/rocprof-trace-decoder.bst
- components/rocprofiler-compute.bst
- components/rocprofiler-sdk.bst
- components/rocprofiler-systems.bst
- components/roctracer.bst

# Math libraries
- components/composable_kernel.bst
- components/hipBLAS.bst
- components/hipBLAS-common.bst
- components/hipBLASLt.bst
- components/hipCUB.bst
- components/hipFFT.bst
- components/hipRAND.bst
- components/hipSOLVER.bst
- components/hipSPARSE.bst
- components/hipSPARSELt.bst
- components/hipTensor.bst
- components/libhipcxx.bst
- components/mxDataGenerator.bst
- components/rocALUTION.bst
- components/rocBLAS.bst
- components/rocFFT.bst
- components/rocPRIM.bst
- components/rocRAND.bst
- components/rocRoller.bst
- components/rocSOLVER.bst
- components/rocSPARSE.bst
- components/rocThrust.bst
- components/rocWMMA.bst

# Machine learning
- components/hipblasltprovider.bst
- components/hipDNN.bst
- components/hipkernelprovider.bst
- components/MIOpen.bst
- components/miopenprovider.bst

# Media, communication, and storage
- components/hipfile.bst
- components/rccl.bst
- components/rocdecode.bst
- components/rocjpeg.bst
- components/rocshmem.bst
