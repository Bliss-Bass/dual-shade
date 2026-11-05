# Licensing

dual-shade is dual-licensed by Navotpala Tech (Bliss Co-Labs Inc.):

- **GNU Affero General Public License v3.0** (`LICENSE`). Free for everyone who meets its terms,
  which is the normal case for open-source ROMs and projects: if you distribute dual-shade, or a
  build that contains it, you provide the complete corresponding source code under the same
  license.
- **Commercial license** (`LICENSE_COMMERCIAL`). For companies that want to ship dual-shade
  without the AGPL's obligations, for example in devices or distributions whose source they don't
  publish. Contact info@navotpala.tech.

SPDX: `AGPL-3.0-only OR LicenseRef-Navotpala-Commercial`.

## What the dual license covers

Everything in this repo that Navotpala Tech wrote: the overlay's resources and manifest, the
aconfig values and release config, the build files, the tools, the docs, and the changes the
patches make.

## What stays under the Apache License 2.0

The `frameworks/base` files the patches change come from the Android Open Source Project (see
`NOTICE`). Each changed file keeps its Apache header; the changes themselves are under the dual
license.

## Building it into a ROM

A ROM that includes dual-shade under the AGPL must offer the complete corresponding source of
what it ships: dual-shade itself plus the patched `frameworks/base` (SystemUI). Publishing the
ROM's source trees (as open-source ROMs do) satisfies this.

## Contributing

dual-shade can only stay dual-licensed if Navotpala Tech may offer every part under both
licenses. By submitting a contribution you agree that it may be distributed under the GNU Affero
General Public License v3.0 and under Navotpala Tech's commercial license.
