#!/bin/bash

set -euo pipefail

# Keep versions outside the Homebrew Cellar so `brew upgrade tfenv` does not drop them.
# Must match TFENV_CONFIG_DIR in fish/conf.d/dotfiles.fish.
export TFENV_CONFIG_DIR="$HOME/.tfenv"
mkdir -p "$TFENV_CONFIG_DIR"

# `latest` alone matches stable releases only
tfenv install latest
tfenv use latest

terraform version
