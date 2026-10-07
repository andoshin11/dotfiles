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

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# Client only: route keys through the 1Password SSH agent. The server needs ~/.ssh just for
# authorized_keys; GitHub access goes through gh (HTTPS) instead of an SSH key.
if [ "$ROLE" = "client" ]; then
    # Initial template only: copied once, never overwritten. Machine-local hosts are
    # written directly in ~/.ssh/config (outside this repo), and tools may append to it.
    if [ -e "$SSH_CONFIG" ]; then
        echo "$SSH_CONFIG already exists; skipped. Compare with: diff $SSH_TEMPLATE $SSH_CONFIG"
    else
        install -m 600 "$SSH_TEMPLATE" "$SSH_CONFIG"
        echo "Installed $SSH_CONFIG from $SSH_TEMPLATE"
    fi
fi
