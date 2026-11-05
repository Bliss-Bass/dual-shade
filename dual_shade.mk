# Copyright (C) 2026 Navotpala Tech (Bliss Co-Labs Inc.)
# SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Navotpala-Commercial

#
# vendor/dual-shade: SystemUI's Dual Shade (separate floating Notifications and Quick Settings
# panels) for large-screen Android 16 / LineageOS 23.2 builds.
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
    DualShadeSystemUI

# The two SystemUI aconfig flags Dual Shade needs, set at build time (config/aconfig/).
PRODUCT_RELEASE_CONFIG_MAPS += \
    $(DUAL_SHADE_DIR)/config/aconfig/release_config_map.textproto
