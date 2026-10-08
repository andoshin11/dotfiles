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

# Login public keys come from the server's dedicated 1Password vault (note "authorized-keys").
# The service account can see exactly that one vault; private keys stay in the client's vault.
AUTHORIZED_KEYS="$HOME/.ssh/authorized_keys"
SSHD_DROPIN=/etc/ssh/sshd_config.d/050-dotfiles.conf
OP_TOKEN_FILE="$HOME/.config/op/service-account-token"

[ -s "$OP_TOKEN_FILE" ] || die "$OP_TOKEN_FILE is missing. Place the 1Password service account token there, then re-run."
OP_SERVICE_ACCOUNT_TOKEN=$(cat "$OP_TOKEN_FILE")
export OP_SERVICE_ACCOUNT_TOKEN

VAULTS=$(op vault list --format json | jq -r '.[].name')
[ "$(printf '%s\n' "$VAULTS" | grep -c .)" -eq 1 ] || die "the service account must see exactly one vault, got: $(printf '%s' "$VAULTS" | tr '\n' ' ')"

PUBLIC_KEYS=$(op read "op://$VAULTS/authorized-keys/notesPlain")
printf '%s\n' "$PUBLIC_KEYS" | grep -q '^ssh-' || die "no public key found in op://$VAULTS/authorized-keys"
unset OP_SERVICE_ACCOUNT_TOKEN

(umask 077; touch "$AUTHORIZED_KEYS")
printf '%s\n' "$PUBLIC_KEYS" | grep '^ssh-' | while IFS= read -r key; do
    grep -qxF "$key" "$AUTHORIZED_KEYS" || echo "$key" >> "$AUTHORIZED_KEYS"
done

# Refuse to disable passwords until a key is in place, to avoid a lockout
[ -s "$AUTHORIZED_KEYS" ] || die "$AUTHORIZED_KEYS is empty"

# macOS only creates host keys on the first SSH connection, and sshd -t fails without them.
# -A generates just the missing key types and leaves existing ones alone.
sudo ssh-keygen -A

sudo install -m 644 "$PWD/etc/ssh/sshd_config.d/050-dotfiles.conf" "$SSHD_DROPIN"
if ! sudo sshd -t; then
    sudo rm -f "$SSHD_DROPIN"
    die "sshd config test failed; removed $SSHD_DROPIN"
fi

# sshd runs per connection (inetd-style), so new connections pick this up without a restart
echo "==> Server settings applied. Password login over SSH is disabled."
