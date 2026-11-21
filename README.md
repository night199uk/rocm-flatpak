

rocm-flatpak
============

The AMD ROCm stack built from TheRock 10.0 sources for Flatpak 26.08.
This builds two artifacts: ROCm Runtime and ROCm SDK.

The ROCm Runtime provides the ROCm userspace stack together with a full
AMD Mesa build for OpenGL, EGL, GLX, GBM, Vulkan, VA-API and OpenCL. The
runtime extension is published on the Flatpak GL ABI branch `1.4`, so it
can bind to Freedesktop/KDE runtimes that use a different base branch.

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

If the ROCm runtime does not appear to load, see
[Troubleshooting ROCm Runtime binding](#troubleshooting-rocm-runtime-binding).

Usage
-----

1. Using ROCm for OpenCL and graphics:
Currently the Freedesktop SDK doesn't know how to autoload the AMD ROCm
extension. Until it does you'll need to update the FLATPAK_GL_DRIVERS
environment variable to run ROCm apps. Example:

```
❯ export FLATPAK_GL_DRIVERS=ROCm
```

Use `ROCm` alone, not `ROCm:default`. The runtime includes its own Mesa
stack, so loading the Freedesktop `default` driver as well would duplicate
the GL drivers and can cause conflicts.

If you previously used `ROCm:default`, remove `default` from the list.

If you use systemd, you can use the following to set this permanently
into your environment:
```
mkdir -p ~/.config/environment.d
echo FLATPAK_GL_DRIVERS=ROCm | tee ~/.config/environment.d/60-flatpak_gl_drivers.conf
```
After a logout and login, or reboot you should see FLATPAK_GL_DRIVERS
set in the environment.

If you upgraded from a ROCm 7.14 Flatpak release, you can remove any
`OCL_ICD_VENDORS` override. The bundled loader now searches Flatpak's merged
`/usr/lib/<triplet>/GL/OpenCL/vendors/` directory automatically.

```
❯ flatpak override --user --unset-env=OCL_ICD_VENDORS <app-id>
```

For a system-wide override, use `sudo flatpak override --system
--unset-env=OCL_ICD_VENDORS <app-id>`.

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


Troubleshooting ROCm Runtime binding
------------------------------------

Flatpak silently ignores a GL extension when its extension point, branch,
installation, or environment does not match. The checks below identify which
part is missing. Replace `<app-id>` with the application you are testing, for
example `com.blackmagic.Resolve`.

Start with the runtime branch check in section 2. The GL extension is
published on ABI branch `1.4`; it can bind to Freedesktop/KDE runtimes whose
GL extension point advertises that version.

### 1. Check the host Flatpak environment

`FLATPAK_GL_DRIVERS` is read by the `flatpak` process on the host before the
sandbox is created. It is not enough to set it inside the app with Flatseal.

```bash
flatpak --version
echo "FLATPAK_GL_DRIVERS=${FLATPAK_GL_DRIVERS:-<unset>}"
flatpak --gl-drivers
```

`flatpak --gl-drivers` should include `ROCm`, for example:

```
ROCm
```

With the full-Mesa runtime, `default` should not be present. If it is, remove
it from `FLATPAK_GL_DRIVERS`.

If `ROCm` is missing, Flatpak is not seeing the variable. Test it inline:

```bash
FLATPAK_GL_DRIVERS=ROCm flatpak --gl-drivers
```

If `ROCm` appears only with the inline form, make it persistent for the
desktop session:

```bash
mkdir -p ~/.config/environment.d
echo 'FLATPAK_GL_DRIVERS=ROCm' > ~/.config/environment.d/60-flatpak_gl_drivers.conf
systemctl --user set-environment FLATPAK_GL_DRIVERS=ROCm
```

Then log out and back in. A plain `export` only affects apps started from that
terminal. To confirm the variable is the only problem, try running the app with
it set inline:

```bash
FLATPAK_GL_DRIVERS=ROCm flatpak run <app-id>
```

Avoid running the app with `sudo`; sudo normally drops the variable.

### 2. Check the runtime branch

The ROCm GL runtime extension is published on Flatpak ABI branch `1.4` and
declares:

```
[ExtensionOf]
ref = runtime/org.freedesktop.Platform/x86_64/26.08
```

Branch `1.4` is the stable GL-driver ABI version advertised by Freedesktop
and KDE runtimes, so it is not tied to the app's base branch. A KDE runtime
such as `org.kde.Platform/x86_64/6.11` or a Freedesktop runtime on `25.08`
can load it as long as its GL extension point includes `1.4`.

```bash
flatpak info --show-runtime <app-id>
flatpak info -m org.freedesktop.Platform.GL.ROCm//1.4 | sed -n '/\[ExtensionOf\]/,+2p'
```

Only a runtime whose GL extension point predates `1.4` cannot load it.

### 3. Check the installation and dependencies

The app, the ROCm extension, and the Freedesktop runtime/SDK must be visible
to the same Flatpak installation. Mixing a system app with a user-installed
extension is a common cause of silent failure.

```bash
flatpak list --columns=ref,origin,branch,installation | grep -E 'org.freedesktop.Platform|ROCm'
flatpak list --system --columns=ref,branch | grep -E 'org.freedesktop.Platform|ROCm'
flatpak list --user --columns=ref,branch | grep -E 'org.freedesktop.Platform|ROCm'
```

The following refs should be present in the same installation:

```
runtime/org.freedesktop.Platform/x86_64/26.08
runtime/org.freedesktop.Sdk/x86_64/26.08
runtime/org.freedesktop.Platform.GL.ROCm/x86_64/1.4
```

Confirm that the runtime exposes the GL extension point:

```bash
flatpak info --show-extensions org.freedesktop.Platform//26.08
```

The output should include the `org.freedesktop.Platform.GL` extension point.
Install anything missing:

```bash
flatpak install --system org.freedesktop.Platform/x86_64/26.08
flatpak install --system org.freedesktop.Sdk/x86_64/26.08
```

Reinstall the ROCm runtime into the same installation as the app if needed:

```bash
flatpak install --system --reinstall ./rocm-runtime.flatpak
```

### 4. Check whether Flatpak is actually binding the extension

Run the app with verbose output and look for the ROCm bind mount:

```bash
flatpak run -vv --devel --command=/bin/bash <app-id> 2>&1 | grep -E 'GL/ROCm|ro-bind'
```

A working mount looks similar to:

```
F: --ro-bind
F: /var/lib/flatpak/runtime/org.freedesktop.Platform.GL.ROCm/x86_64/1.4/<commit>/files
F: /usr/lib/x86_64-linux-gnu/GL/ROCm
```

If this is absent, the extension is not being mounted and the next checks will
not help until that is fixed.

### 5. Inspect the sandbox

Start a shell inside the app sandbox:

```bash
flatpak run --devel --command=/bin/bash <app-id>
```

Then run:

```bash
cat /.flatpak-info | grep -E '^(runtime|app)-extensions='
ls -l /usr/lib/x86_64-linux-gnu/GL
ls -l /usr/lib/x86_64-linux-gnu/GL/ROCm/bin/rocminfo
/usr/lib/x86_64-linux-gnu/GL/ROCm/bin/rocminfo
clinfo
ls -l /dev/kfd /dev/dri
```

Expected results:

- `runtime-extensions` or `app-extensions` contains
  `org.freedesktop.Platform.GL.ROCm`.
- `/usr/lib/x86_64-linux-gnu/GL/ROCm` exists.
- `rocminfo` runs and reports the GPU.
- `/dev/kfd` exists when the app has GPU or all-devices permission.

If `GL/ROCm` is missing, Flatpak is not binding the extension. `OCL_ICD_VENDORS`
cannot fix this; it only affects OpenCL once the extension is mounted. If
`GL/ROCm` exists but `rocminfo` fails, the problem is lower-level device or
runtime access, not extension selection.

Check the app permissions as well:

```bash
flatpak override --user --show <app-id>
flatpak override --system --show <app-id>
```

For Flatpak 1.18 and newer, enabling GPU access should pass through
`/dev/kfd`. For older versions use `--device=all`:

```bash
flatpak override --user --device=all <app-id>
```

### 6. Common causes

- The app runtime's GL extension point does not include `1.4`.
- `FLATPAK_GL_DRIVERS` still includes `default`, loading a second Mesa stack.
- `FLATPAK_GL_DRIVERS` is set inside the app or in Flatseal, not in the host
  session that launches `flatpak`.
- `FLATPAK_GL_DRIVERS` was set with `flatpak override --env`; that affects the
  app environment, not Flatpak's driver selection.
- The variable was exported in a shell but the app was started from the desktop.
- `sudo flatpak run` dropped the variable.
- The ROCm extension is installed in the user installation while the app is
  installed system-wide, or vice versa.
- The Freedesktop `26.08` runtime or SDK is missing.
- The ROCm runtime was not reinstalled after changing branches.
- The app does not have GPU or all-devices permission, so `/dev/kfd` is absent.

### 7. What to include in a bug report

Please include the output of these commands, plus your distribution, kernel,
and GPU model:

```bash
flatpak --version
echo "FLATPAK_GL_DRIVERS=${FLATPAK_GL_DRIVERS:-<unset>}"
flatpak --gl-drivers
flatpak list --columns=ref,origin,branch,installation | grep -E 'ROCm|org.freedesktop|org.kde'
flatpak info --show-runtime <app-id>
flatpak info -m org.freedesktop.Platform.GL.ROCm//1.4
flatpak run -vv --devel --command=/bin/bash <app-id> 2>&1 | grep -E 'GL/ROCm|ro-bind|extensions'
```

Also include the `runtime-extensions` / `app-extensions` lines from
`/.flatpak-info`, and the output of `rocminfo` and `clinfo` from inside the app
sandbox.

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
