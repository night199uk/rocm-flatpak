

rocm-flatpak
============

The AMD ROCm stack built from TheRock 7.14 sources for Flatpak 26.08.  
This builds two artifacts: ROCm Runtime and ROCm SDK.

The ROCm Runtime provides all of the runtime components most users
need: OpenCL, with AMD mesa and AMD libdrm. As of this version, AMD
Mesa is not built to cover all uses cases and sits atop of the full
Mesa in the Freedesktop SDK. Thus, you need to use ROCm & default GL
extensions together. This may change in future.

The ROCm SDK provides amd-llvm, hipcc, and all of the tools AMD ship
for building ROCm accelerated code. This is largely untested as yet
as I don't have a use case for this. However it successfully builds
the AMD runtimes we ship here.

Installation
--------
1. Download the latest release from the Release section, already packaged as a .flatpak.
```
flatpak install <x>.flatpak
```

Usage
-----

1. Using ROCm for OpenCL:
Currently the Freedesktop SDK doesn't know how to autoload the AMD ROCm
extension. Until it does you'll need to update the FLATPAK_GL_DRIVERS
environment variable to run OpenCL apps. Example:

```
❯ export FLATPAK_GL_DRIVERS=ROCm:default
```

If you use systemd, you can use the following to set this permanently
into your environment:
```
mkdir -p ~/.config/environment.d
echo FLATPAK_GL_DRIVERS=ROCm:default | tee ~/.config/environment.d/60-flatpak_gl_drivers.conf
```
After a logout and login, or reboot you should see FLATPAK_GL_DRIVERS
set in the environment.

You also need to set OCL_ICD_VENDORS for the Flatpak application that
wants to use due to a bug (this should be fixed soon). The critical part
is the trailing slash on the end of vendors/; so please don't remove it.

```
❯ flatpak override --user --env=OCL_ICD_VENDORS=/usr/lib/x86_64-linux-gnu/GL/OpenCL/vendors/ <component ID>
```

ClInfo:
```
❯ flatpak run --device=all --command=/bin/bash --devel org.freedesktop.Platform.ClInfo
[📦 org.freedesktop.Platform.ClInfo ~]$ clinfo
Number of platforms                               2
  Platform Name                                   Clover
  Platform Vendor                                 Mesa
  Platform Version                                OpenCL 1.1 Mesa 23.0.2 (git-4d5e73870e)
  Platform Profile                                FULL_PROFILE
  Platform Extensions                             cl_khr_icd
  Platform Extensions function suffix             MESA

  Platform Name                                   AMD Accelerated Parallel Processing
  Platform Vendor                                 Advanced Micro Devices, Inc.
  Platform Version                                OpenCL 2.1 AMD-APP (3513.0)
  Platform Profile                                FULL_PROFILE
  Platform Extensions                             cl_khr_icd cl_amd_event_callback
  Platform Extensions function suffix             AMD
  Platform Host timer resolution                  1ns
```


Issues, Workarounds and Caveats
--------------------------------
1. /dev/kfd

If you use Flatpak < 1.18
: the --device=dri flag doesn't enable access to /dev/kfd, which is
required for ROCm to function.  You'll need to pass --device=all to any
apps to allow ROCm to see /dev/kfd.  You can use Flatseal to add this
to apps and make it permanent.  

Flatpak > 1.18: enabling GPU permissions for a Flatpak app will pass
through /dev/kfd.
