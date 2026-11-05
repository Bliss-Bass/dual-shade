# dual-shade

SystemUI's Dual Shade for large-screen Android 16 builds (LineageOS 23.2), packaged as one
`vendor/dual-shade` repo you can drop into a source tree.

Dual Shade splits the pull-down shade into two floating panels: Notifications and Quick Settings,
each opened from its own corner of the status bar. Android 16 has it, but it's switched off in
release builds and has a few bugs once switched on. This repo switches it on and fixes them:

- the two SystemUI feature flags Dual Shade needs, set at build time;
- a SystemUI overlay that makes Dual Shade the default, puts both panels on the right under a
  desktop status bar, and adds a volume slider to Quick Settings;
- five small SystemUI patches: four bug fixes and the setting default.

It is meant for large screens (tablets, desktops, x86 PCs). [vendor/retro-style](../retro-style)
builds on it, and so can any other component that wants the floating panels.

## Requirements

- A LineageOS 23.2 tree (Android 16 QPR2, release `bp4a`). Other AOSP-based Android 16 trees work
  too if their `frameworks/base` matches closely enough for the patches.
- A large-screen device (smallest width 600dp or more).

## Install

1. **Get the repo** into `vendor/dual-shade`. The path matters: the makefile and the release
   config map refer to it.

   ```sh
   git clone <dual-shade repo URL> vendor/dual-shade
   ```

   Or add it to `.repo/local_manifests/dual-shade.xml` and `repo sync vendor/dual-shade`.

2. **Apply the patches** to `frameworks/base`:

   ```sh
   repo start dual-shade frameworks/base       # optional: keeps your commits on a topic branch
   vendor/dual-shade/tools/apply-patches.sh status
   vendor/dual-shade/tools/apply-patches.sh check
   vendor/dual-shade/tools/apply-patches.sh apply
   ```

   `status` lists what's applied, `check` tries the missing patches in a throwaway worktree, and
   `apply` runs `git am` on them.

3. **Inherit the makefile** in your device or product makefile:

   ```make
   $(call inherit-product, vendor/dual-shade/dual_shade.mk)
   ```

4. **Build** as usual (`breakfast <device> && m bacon`).

**Check on the device:** pull down from the status bar. Notifications and Quick Settings open as
separate floating panels, and `adb shell dumpsys activity service SystemUIService | grep
shadeMode=` prints `shadeMode=Dual`. Users can switch back to the single shade on the Shade
panels page in Settings.

### If your tree doesn't build the bp4a release

LineageOS 23.2 builds release `bp4a` (`breakfast` reads it from
`vendor/lineage/vars/aosp_target_release`). The flag values are attached to that release in
`config/aconfig/release_configs/bp4a.textproto`. For another release, copy that file to
`release_configs/<release>.textproto` and change its `name`.

## How it works

### 1. Feature flags set at build time

Dual Shade is built on SystemUI's "scene container", behind two aconfig flags that are off in
`bp4a`: `com.android.systemui.scene_container` and `status_bar_for_desktop`.

aconfig flags get their values from the release config. `config/aconfig/` sets both:

- `*_flag_values.textproto`: one value per flag
- `Android.bp`: an `aconfig_values` module with them, and an `aconfig_value_set` that groups it
- `release_config_map.textproto` and `release_configs/bp4a.textproto`: add the value set to the
  `bp4a` release
- `dual_shade.mk`: `PRODUCT_RELEASE_CONFIG_MAPS` adds the map to your product

Values set at build time work everywhere. On-device overrides (`aflags`, `device_config`) need
the `aconfigd` service and a `/metadata` partition, which not every device has (x86 images don't).

### 2. The overlay

`overlay/` is a static runtime resource overlay (always on) for SystemUI:

| Resource | Effect |
|---|---|
| `config_dualShadeEnabledByDefault` | Dual Shade until the user picks a layout (needs patch 0005) |
| `config_notificationShadeOnTopEnd` | Notifications open on the right, next to Quick Settings |
| `config_useDesktopStatusBar` | Desktop status bar: clock left, panel chips right |
| `config_enableDesktopAudioTileDetailsView` | Volume slider in Quick Settings (needs patch 0003) |

It's installed to `/product/overlay`. SystemUI declares no `<overlayable>` resources, so overlays
built into the image may replace any of them.

### 3. The patches

Turning the scene container on exposes a few unfinished parts of AOSP. The patches are
`git format-patch` files in `patches/frameworks/base/`:

| # | Patch | What it fixes |
|---|---|---|
| 0001 | Leave the boot lockscreen state when idle off Lockscreen | When SystemUI starts on a scene other than the lockscreen (no lockscreen, or during setup), the keyguard state stayed "lockscreen" forever, so heads-up notifications never timed out. |
| 0002 | Keep the desktop shade window untouchable over Gone | With the desktop status bar, a heads-up made the whole screen below the status bar touchable, so taps never reached apps until it went away. |
| 0003 | Show the Quick Settings volume slider without tile details | The volume slider only appeared with the unfinished tile-details flag on. It now shows whenever `config_enableDesktopAudioTileDetailsView` is true. |
| 0004 | Keep a slot for missing lockscreen elements | The lockscreen layout expects six elements, but AOSP has no provider for the ambient indication area, so SystemUI crashed whenever the lockscreen showed. |
| 0005 | Let a config overlay turn Dual Shade on by default | While the `dual_shade` setting is unset, SystemUI used the single shade but Settings showed "Separate panels" as selected. The default now comes from `config_dualShadeEnabledByDefault` (false in AOSP, true in this overlay), so both agree without writing the setting at boot. |

The series applies to the LineageOS `lineage-23.2` branch and is independent of other patch
series (retro-style's applies before or after it).

**Updating a patch:** change the code in `frameworks/base`, amend or add a commit, then export
it again with `git format-patch` into `patches/frameworks/base/`, keeping the numbering. Never
edit a `.patch` file by hand.

**After a `repo sync`:** if upstream changed code a patch touches, `apply-patches.sh check`
fails. Apply that patch with `git am --3way`, resolve the conflict, and export it again.

## License

Copyright (C) 2026 Navotpala Tech (Bliss Co-Labs Inc.). dual-shade is dual-licensed:

- **GNU Affero General Public License v3.0** (`LICENSE`): free for open-source ROMs and projects
  that meet its terms, such as publishing the source of what they ship.
- **Commercial license** (`LICENSE_COMMERCIAL`): for companies that want to ship it without the
  AGPL's obligations. Contact info@navotpala.tech.

The AOSP files the patches change stay under the Apache License 2.0. [LICENSING.md](LICENSING.md)
says which parts are which, and `NOTICE` holds the attributions.
