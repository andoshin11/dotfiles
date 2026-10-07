#!/bin/bash

set -eu

die() {
    echo "ERROR: $1" >&2
    exit 1
}

# Homebrew officially supports Apple Silicon only (prefix /opt/homebrew)
[ "$(uname -m)" = "arm64" ] || die "Apple Silicon (arm64) is required"

BREW_PREFIX=/opt/homebrew
BREWFILE="$PWD/etc/Brewfile"

if [ ! -x "$BREW_PREFIX/bin/brew" ]; then
    # install.sh runs via `curl | bash`, so stdin is not a TTY and the Homebrew
    # installer runs non-interactively with `sudo -n`. Cache sudo credentials first
    # (sudo prompts via /dev/tty) so that the installer can use them.
    sudo -v
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$("$BREW_PREFIX/bin/brew" shellenv)"

# Ensure presence only; upgrades are done deliberately with `brew upgrade`
brew bundle install --no-upgrade --file="$BREWFILE"
