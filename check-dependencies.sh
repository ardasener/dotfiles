#!/usr/bin/env bash

set -euo pipefail

os="$(uname -s | tr '[:upper:]' '[:lower:]')"
missing=()

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    missing+=("$cmd")
  fi
}

require_cmd git
require_cmd python3
require_cmd node
require_cmd npm
require_cmd tmux
require_cmd nvim
require_cmd mc
require_cmd lazygit
require_cmd btop
require_cmd cmus
require_cmd opencode

if ((${#missing[@]} == 0)); then
  echo "All runtime dependencies look available."
  exit 0
fi

echo "Missing dependencies: ${missing[*]}"
echo

if command -v python3 >/dev/null 2>&1; then
  if ! python3 - <<'PY' >/dev/null 2>&1
import importlib.util
missing = [name for name in ("pynvim",) if importlib.util.find_spec(name) is None]
raise SystemExit(1 if missing else 0)
PY
  then
    echo "Python support for Neovim: install pynvim"
  fi
fi

if command -v node >/dev/null 2>&1; then
  if ! npm list -g --depth=0 neovim >/dev/null 2>&1; then
    echo "Node support for Neovim: install neovim npm package if you use Node-based providers or integrations"
  fi
fi

if command -v nvim >/dev/null 2>&1; then
  if ! nvim --headless "+lua local ok = pcall(require, 'nvim-treesitter.configs'); if not ok then vim.cmd('cquit 1') end" +q >/dev/null 2>&1; then
    echo "Neovim Treesitter support: run :Lazy sync or install nvim-treesitter"
  fi
  if ! command -v tree-sitter >/dev/null 2>&1; then
    echo "Neovim Treesitter parser builds: install tree-sitter CLI"
  fi
  if ! nvim --headless "+lua local ok = pcall(require, 'codecompanion'); if not ok then vim.cmd('cquit 1') end" +q >/dev/null 2>&1; then
    echo "Neovim CodeCompanion support: run :Lazy sync or install codecompanion.nvim"
  fi
fi

case "$os" in
  linux)
    if command -v apt >/dev/null 2>&1; then
      echo "Ubuntu/Debian: sudo apt install ${missing[*]}"
      echo "Python for Neovim: python3 -m pip install --user pynvim"
      echo "Node for Neovim: npm install -g neovim"
    fi
    if command -v dnf >/dev/null 2>&1; then
      echo "Fedora: sudo dnf install ${missing[*]}"
      echo "Python for Neovim: python3 -m pip install --user pynvim"
      echo "Node for Neovim: npm install -g neovim"
    fi
    if command -v pacman >/dev/null 2>&1; then
      echo "Arch: sudo pacman -S ${missing[*]}"
      echo "Python for Neovim: python3 -m pip install --user pynvim"
      echo "Node for Neovim: npm install -g neovim"
    fi
    if command -v zypper >/dev/null 2>&1; then
      echo "openSUSE: sudo zypper install ${missing[*]}"
      echo "Python for Neovim: python3 -m pip install --user pynvim"
      echo "Node for Neovim: npm install -g neovim"
    fi
    ;;
  darwin)
    echo "macOS: brew install ${missing[*]}"
    echo "Python for Neovim: python3 -m pip install --user pynvim"
    echo "Node for Neovim: npm install -g neovim"
    ;;
  *)
    echo "Install the missing commands using your platform package manager."
    echo "Python for Neovim: python3 -m pip install --user pynvim"
    echo "Node for Neovim: npm install -g neovim"
    ;;
esac

exit 1
