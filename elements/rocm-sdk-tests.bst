kind: stack
description: |
  Optional tests and samples for the SDK. Not part of the production
  SDK image.

depends:
- components/hip-tests.bst
- components/hipDNN_samples.bst
- components/hipInfo.bst
- components/rccl-tests.bst
- components/rocPRIM_tests.bst
- components/rocprofiler-systems-examples.bst
