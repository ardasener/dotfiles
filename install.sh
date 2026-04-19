#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$ROOT_DIR/.venv"
PYTHON_BIN="${PYTHON:-python3}"
STAMP_FILE="$VENV_DIR/.requirements.stamp"

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  echo "python3 is required" >&2
  exit 1
fi

if [[ ! -d "$VENV_DIR" ]]; then
  "$PYTHON_BIN" -m venv "$VENV_DIR"
fi

if [[ ! -f "$STAMP_FILE" || "$ROOT_DIR/requirements.txt" -nt "$STAMP_FILE" ]]; then
  "$VENV_DIR/bin/python" -m pip install --upgrade pip >/dev/null
  "$VENV_DIR/bin/python" -m pip install -r "$ROOT_DIR/requirements.txt"
  touch "$STAMP_FILE"
fi
exec "$VENV_DIR/bin/python" "$ROOT_DIR/installer.py"
