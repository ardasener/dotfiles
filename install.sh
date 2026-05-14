#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$ROOT_DIR/.venv"
PYTHON_BIN="${PYTHON:-python3}"
STAMP_FILE="$VENV_DIR/.requirements.stamp"
LOCAL_BIN_DIR="$HOME/.local/bin"
WORKSPACE_BIN="$LOCAL_BIN_DIR/workspace"

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  echo "python3 is required" >&2
  exit 1
fi

printf '%s\n' "creating virtual environment: $VENV_DIR"
if [[ ! -d "$VENV_DIR" ]]; then
  "$PYTHON_BIN" -m venv "$VENV_DIR"
fi

if [[ ! -f "$STAMP_FILE" || "$ROOT_DIR/requirements.txt" -nt "$STAMP_FILE" ]]; then
  printf '%s\n' "upgrading pip"
  "$VENV_DIR/bin/python" -m pip install --upgrade pip >/dev/null
  printf '%s\n' "installing python dependencies from requirements.txt"
  "$VENV_DIR/bin/python" -m pip install -r "$ROOT_DIR/requirements.txt"
  touch "$STAMP_FILE"
fi

mkdir -p "$LOCAL_BIN_DIR"
printf '%s\n' "linking workspace helper: $WORKSPACE_BIN"
ln -sf "$ROOT_DIR/scripts/workspace" "$WORKSPACE_BIN"

printf '%s\n' "checking dependencies"
bash "$ROOT_DIR/check-dependencies.sh"

printf '%s\n' "running installer"
exec "$VENV_DIR/bin/python" "$ROOT_DIR/installer.py"
