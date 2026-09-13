

rocm-flatpak
============

This repo is an initial cut of building the AMD ROCm stack for
Flatpak 23.08.  It currently builds OpenCL. The ROCm Runtime
Extension it builds sits on top of the Mesa in Freedesktop SDK
org.freedesktop.Platform.GL.default; so you will need to use both to
get working OpenGL+OpenCL.

Installation
--------
1. Download the latest release from the Release section, already packaged as a .flatpak.
flatpak install <x>.flatpak

If you want to build yourself, see below.

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


Building
--------

23.08 is based on BuildStream2.

Install Buildstream2 and plugins:

1. Install BuildStream2:
```
sudo dnf install bubblewrap fuse3 git lzip patch python3 python3-pip python3-devel
sudo pip3 install dulwich==0.24.10 click requests
pip3 install buildstream buildstream-external buildstream-plugins bst-plugins-experimental
```
2. Build this repo, and export to a Flatpak repo:
```
bst build rocm-flatpak.bst
bst artifact checkout --directory ~/rocm-repo rocm-flatpak.bst
flatpak remote-add --user rocm-repo ~/rocm-repo --no-gpg-verify
flatpak install --user org.freedesktop.Platform.GL.ROCm
```

2. 1. (optional) Export the build product to a single-file bundle
```
flatpak build-bundle --runtime ~/rocm-repo rocm.flatpak org.freedesktop.Platform.GL.ROCm 23.08
```


Issues, Workarounds and Caveats
--------------------------------
1. /dev/kfd
Currently the --device=dri flag doesn't enable access to /dev/kfd, which
is required for ROCm to function. You'll need to pass --device=all to
any apps to allow ROCm to see /dev/kfd.  You can use Flatseal to add
this to apps and make it permanent.
https://github.com/flatpak/flatpak/issues/5383
UPDATE: This is no longer required as Flatpak 1.18 now allows access
to /dev/kfd just by enabling "GPU" access.

3. Freedesktop Bug
There is also a bug in the Freedesktop SDK provided Mesa OpenCL with
(?) some AMD cards (?) which stops ROCm OpenCL device being used even
when hard coded in the app.  This happens with e.g. the Radeon 5500M in
the MacbookPro16,4.
https://gitlab.freedesktop.org/mesa/mesa/-/issues/4189
In this case, you can force apps to only "see" the ROCm OpenCL
implementation by setting the following environment variable into the
app using e.g. Flatseal:

```
OCL_ICD_VENDORS=/usr/lib/x86_64-linux-gnu/GL/ROCm/OpenCL/vendors
```

3. Old Cards
Older cards (RX580, etc) will require additional variables. You can
set these into the app with Flatseal, or add them to /etc/environment
or similar.
```
ROC_ENABLE_PRE_VEGA=1
```

