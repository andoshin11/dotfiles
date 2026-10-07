#!/bin/bash

set -euo pipefail

die() {
    echo "ERROR: $1" >&2
    exit 1
}

FISH=/opt/homebrew/bin/fish
FISH_DIR="$HOME/.config/fish"
FISHER_URL=https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish

[ -x "$FISH" ] || die "$FISH not found. Install it via etc/Brewfile (05_brew.sh) first."

# Allow fish as a login shell
if ! grep -qxF "$FISH" /etc/shells; then
    echo "$FISH" | sudo tee -a /etc/shells >/dev/null
fi

# Change the login shell of the current user (not root)
if [ "$(dscl . -read "/Users/$USER" UserShell | awk '{print $2}')" != "$FISH" ]; then
    sudo chsh -s "$FISH" "$USER"
fi

mkdir -p "$FISH_DIR/conf.d"

# config.fish is machine-local (secrets, tool-appended lines) and must not point into this repo
if [ -L "$FISH_DIR/config.fish" ]; then
    die "$FISH_DIR/config.fish is a symlink. Replace it with a regular file copy, then re-run."
fi

# Link only our own file: fisher also writes plugin files into conf.d
ln -sfvn "$PWD/fish/conf.d/dotfiles.fish" "$FISH_DIR/conf.d/dotfiles.fish"

# fisher rewrites fish_plugins on install/remove, so copy it once instead of linking
if [ ! -e "$FISH_DIR/fish_plugins" ]; then
    install -m 644 "$PWD/fish/fish_plugins" "$FISH_DIR/fish_plugins"
fi

# Install fisher and plugins listed in fish_plugins (once; update later with `fisher update`)
if [ ! -f "$FISH_DIR/functions/fisher.fish" ]; then
    # fisher reads plugin names from stdin when it is not a TTY (e.g. `curl | bash`), so detach stdin
    "$FISH" -c "curl -fsSL $FISHER_URL | source && fisher update" </dev/null
else
    echo "fisher is already installed; run 'fisher update' to sync plugins with fish_plugins"
fi
