# Copyright (C) 2026 Navotpala Tech (Bliss Co-Labs Inc.)
# SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Navotpala-Commercial

#
# vendor/dual-shade: SystemUI's Dual Shade (separate floating Notifications and Quick Settings
# panels) for large-screen Android 16 / LineageOS 23.2 and Android 17 / LineageOS 24.0 builds.
#
# Use it from your device (or product) makefile:
#
#   $(call inherit-product, vendor/dual-shade/dual_shade.mk)
#
# The frameworks/base patches must be applied too: see README.md. Other components that need
# Dual Shade (vendor/retro-style, for one) inherit this file themselves. That's fine: the build
# imports each product makefile once, however many makefiles inherit it.
#

DUAL_SHADE_DIR := vendor/dual-shade

# SystemUI config: Dual Shade on by default, desktop status bar, panels on the right, Quick
# Settings volume slider (overlay/).
PRODUCT_PACKAGES += \
    DualShadeSystemUI \
    DualShadeSettings

# The SystemUI aconfig flags Dual Shade needs, set at build time (config/aconfig/). Android 17
# trees (cp2a release) also need dual_shade itself; they get the cp2a set instead of the bp4a
# one. TARGET_RELEASE is unset while maps are collected, so check for the release directly.
ifneq ($(wildcard build/release/aconfig/cp2a),)
PRODUCT_RELEASE_CONFIG_MAPS += \
    $(DUAL_SHADE_DIR)/config/aconfig/cp2a/release_config_map.textproto
else
PRODUCT_RELEASE_CONFIG_MAPS += \
    $(DUAL_SHADE_DIR)/config/aconfig/release_config_map.textproto
endif
