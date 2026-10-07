#!/bin/bash

set -euo pipefail

# Install the latest stable CPython from prebuilt binaries (python-build-standalone).
# --default also links `python` / `python3` into ~/.local/bin; it is experimental, so opt in explicitly.
uv python install --default --preview-features python-install-default

"$HOME/.local/bin/python" --version
