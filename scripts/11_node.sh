#!/bin/bash

set -euo pipefail

die() {
    echo "ERROR: $1" >&2
    exit 1
}

# Active LTS = the newest release line that has an LTS codename.
# (nodebrew's `stable` only means "newest even major", which can be a pre-LTS Current release.)
NODE_LTS=$(curl -fsSL https://nodejs.org/dist/index.json | jq -r '[.[] | select(.lts != false)][0].version')
case "$NODE_LTS" in
v[0-9]*) ;;
*) die "could not resolve the Node.js LTS version: $NODE_LTS" ;;
esac

nodebrew setup_dirs
# nodebrew exits 1 for "already installed", so check first
if ! nodebrew ls | grep -qxF "$NODE_LTS"; then
    nodebrew install-binary "$NODE_LTS"
fi
nodebrew use "$NODE_LTS"

export PATH="$HOME/.nodebrew/current/bin:$PATH"

# Global packages are per Node version
npm ls --global yarn >/dev/null 2>&1 || npm install --global yarn

node --version
