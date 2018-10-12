#!/bin/bash

DOTPATH=~/dev/dotfiles
GITHUB_URL=https://github.com/andoshin11/dotfiles
TARBALL="${GITHUB_URL}/archive/master.tar.gz"

# utils commands
# is_exists returns true if executable $1 exists in $PATH
is_exists() {
    which "$1" >/dev/null 2>&1
    return $?
}

# has is wrapper function
has() {
    is_exists "$@"
}

# die returns exit code error and echo error message
die() {
    e_error "$1" 1>&2
    exit "${2:-1}"
}

# use git when available
if has "git"; then
    echo $GITHUB_URL
    echo $TARBALL
    git clone --recursive "$GITHUB_URL" "$DOTPATH"

# use curl or wget as a fallback
elif has "curl" || has "wget"; then
    if has "curl"; then
        curl -L "$TARBALL"

    elif has "wget"; then
        wget -O - "$TARBALL"

    fi | tar xv -

    mv -f dotfiles-master "$DOTPATH"

else
    die "curl or wget required"
fi

cd $DOTPATH
if [ $? -ne 0]; then
    die "not found: $DOTPATH"
fi

make install

