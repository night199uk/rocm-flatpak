kind: junction

config:
  options:
    bootstrap_build_arch: '%{arch}'
    target_arch: '%{arch}'

sources:
- kind: git
  url: 'gitlab:freedesktop-sdk/freedesktop-sdk.git'
  track: 'freedesktop-sdk-26.08.4'
  ref: 114ae909ec9881958bd507c8b4414aa33f758d2b
