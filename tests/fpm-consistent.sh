#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-only
# zebra understands "fpm ..." only with the dplane_fpm_nl module loaded.
# Kernel forwarding does not load it (etc/frr/daemons.danos), so the
# generated frr.conf must not configure FPM: zebra rejects the lines and
# frr-reload.py reports failure on every routing commit.
set -eu
if grep -q fpm scripts/frr/configs/steps.json && ! grep -Eq '^zebra_options=.*dplane_fpm_nl' etc/frr/daemons.danos; then
    echo "fpm-consistent: steps.json configures fpm but daemons.danos does not load dplane_fpm_nl" >&2
    exit 1
fi
echo "fpm-consistent: OK"
