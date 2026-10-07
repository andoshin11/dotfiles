#!/bin/bash

set -eu

die() {
    echo "ERROR: $1" >&2
    exit 1
}

case "${ROLE:-}" in
client | server) ;;
*) die "ROLE must be client or server" ;;
esac

SSH_DIR="$HOME/.ssh"
SSH_CONFIG="$SSH_DIR/config"
SSH_TEMPLATE="$PWD/etc/ssh/config.$ROLE"
GITHUB_KEY="$SSH_DIR/id_ed25519_github"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# Initial template only: copied once, never overwritten. Machine-local hosts are
# written directly in ~/.ssh/config (outside this repo), and tools may append to it.
if [ -e "$SSH_CONFIG" ]; then
    echo "$SSH_CONFIG already exists; skipped. Compare with: diff $SSH_TEMPLATE $SSH_CONFIG"
else
    install -m 600 "$SSH_TEMPLATE" "$SSH_CONFIG"
    echo "Installed $SSH_CONFIG from $SSH_TEMPLATE"
fi

if [ "$ROLE" = "server" ]; then
    # Unattended use: no passphrase, protected by file permissions
    if [ ! -f "$GITHUB_KEY" ]; then
        ssh-keygen -t ed25519 -N "" -C "github-$(scutil --get LocalHostName)" -f "$GITHUB_KEY"
    fi
    echo "==> Register $GITHUB_KEY.pub on GitHub (Settings > SSH and GPG keys), then verify with: ssh -T git@github.com"
else
    echo "==> In 1Password: Settings > Developer > enable SSH agent, then verify with: ssh -T git@github.com"
fi
