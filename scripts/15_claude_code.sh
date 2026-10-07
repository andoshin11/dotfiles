#!/bin/bash

set -euo pipefail

# Native installer: installs to ~/.local/bin/claude and auto-updates in the background.
# Not managed by Homebrew because Homebrew installs do not auto-update.
CLAUDE_BIN="$HOME/.local/bin/claude"

if [ -x "$CLAUDE_BIN" ]; then
    echo "Claude Code is already installed; it keeps itself up to date"
else
    curl -fsSL https://claude.ai/install.sh | bash
fi

"$CLAUDE_BIN" --version
