#!/bin/sh
set -e

# install pre-commit if not present (attempt using pip)
if ! command -v pre-commit >/dev/null 2>&1; then
  echo "pre-commit not found. Attempting to install with pip..."
  pip install --user pre-commit || echo "Please install pre-commit manually (pip install pre-commit)"
fi

# set repository hooks path to tracked .githooks (optional)
git config core.hooksPath .githooks || echo "Failed to set core.hooksPath"

# install pre-commit hooks for this repo
pre-commit install || echo "pre-commit install failed. Run: pre-commit install"
echo "Bootstrap complete."
