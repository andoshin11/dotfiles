#!/bin/bash

set -euo pipefail

DOTPATH=~/dev/dotfiles
GITHUB_URL=https://github.com/andoshin11/dotfiles
TARBALL="${GITHUB_URL}/archive/master.tar.gz"

# utils commands
# is_exists returns true if executable $1 exists in $PATH
is_exists() {
    command -v "$1" >/dev/null 2>&1
}

# has is wrapper function
has() {
    is_exists "$@"
}

# die prints an error message to stderr and exits with the given code
die() {
    echo "ERROR: $1" >&2
    exit "${2:-1}"
}

case "${ROLE:-}" in
client | server) ;;
*) die "ROLE must be client or server (e.g. ROLE=server bash install.sh)" ;;
esac

# use git when available
if has "git"; then
    echo "$GITHUB_URL"
    git clone --recursive "$GITHUB_URL" "$DOTPATH" || die "git clone failed: $GITHUB_URL"

# use curl or wget as a fallback
elif has "curl" || has "wget"; then
    echo "$TARBALL"
    if has "curl"; then
        curl -fsSL "$TARBALL"
    else
        wget -O - "$TARBALL"
    fi | tar xzf -

    mkdir -p "$(dirname "$DOTPATH")"
    mv -f dotfiles-master "$DOTPATH"

else
    die "git, curl or wget required"
fi

cd "$DOTPATH" || die "not found: $DOTPATH"

make install ROLE="$ROLE"
