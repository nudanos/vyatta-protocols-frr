#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-only
# FRR 10's watchfrr starts every daemon itself ("restart all") and kills a
# restart that runs past its restart timeout (90 s). On a slow machine
# (emulation, a loaded host) starting all daemons takes longer; watchfrr
# killed the start, restarted daemons one by one while they were still
# coming up, and the boot commit's FRR step never returned. daemons.danos
# must give restarts time to finish.
set -eu
opts=$(sed -n 's/^watchfrr_options="\(.*\)"$/\1/p' etc/frr/daemons.danos)
t=$(printf '%s\n' "$opts" | grep -oE '(-T|--restart-timeout)[ =][0-9]+' | grep -oE '[0-9]+$' | head -1 || true)
if [ -z "$t" ] || [ "$t" -lt 300 ]; then
    echo "watchfrr-restart-timeout: daemons.danos must set watchfrr_options \"-T <seconds>\" of at least 300 (have: '$opts')" >&2
    exit 1
fi
echo "watchfrr-restart-timeout: OK (-T $t)"
