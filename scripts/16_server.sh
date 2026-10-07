#!/bin/bash

set -euo pipefail

die() {
    echo "ERROR: $1" >&2
    exit 1
}

if [ "${ROLE:-}" != "server" ]; then
    echo "ROLE is not server; skipped"
    exit 0
fi

# FileVault blocks unattended reboots (password prompt at startup) and automatic login
if [ "$(fdesetup status)" != "FileVault is Off." ]; then
    die "FileVault is on. Turn it off with 'sudo fdesetup disable', wait for decryption to finish, then re-run."
fi

# Never sleep (remote access), only turn the display off, and power on after a power failure
sudo pmset -a sleep 0 disksleep 0 displaysleep 10 powernap 0 womp 1 autorestart 1

# Key-only SSH. Refuse to disable passwords until a key is in place, to avoid a lockout.
AUTHORIZED_KEYS="$HOME/.ssh/authorized_keys"
SSHD_DROPIN=/etc/ssh/sshd_config.d/050-dotfiles.conf

if [ ! -s "$AUTHORIZED_KEYS" ]; then
    die "$AUTHORIZED_KEYS is missing or empty. Add your public key there, then re-run."
fi

sudo install -m 644 "$PWD/etc/ssh/sshd_config.d/050-dotfiles.conf" "$SSHD_DROPIN"
if ! sudo sshd -t; then
    sudo rm -f "$SSHD_DROPIN"
    die "sshd config test failed; removed $SSHD_DROPIN"
fi

# sshd runs per connection (inetd-style), so new connections pick this up without a restart
echo "==> Server settings applied. Password login over SSH is disabled."
