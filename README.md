# Dotfiles

This repository stores the tracked config files and an installer that links them into place.

## Install dependencies

`install.sh` creates a local virtual environment and installs the Python dependencies from `requirements.txt`:

- `PyYAML`
- `rich`
- `InquirerPy`

Run it from the repo root:

```bash
bash install.sh
```

## Apply configs

`install.sh` also runs the installer that reads `links.yaml` and creates symlinks from `configs/` into your home directory.

It will:

1. Create or reuse `.venv/`
2. Install/update Python dependencies when needed
3. Link helper scripts into `~/.local/bin`
4. Prompt before replacing existing target files
5. Back up existing targets before relinking them

The OpenCode and agent configs are included in the same link map, so running the installer applies them too.

## OpenCode init command

The repo includes a custom OpenCode init command under `configs/opencode/commands/`.
It initializes the current project with OpenSpec for Codex and OpenCode.

## Related files

- `install.sh` — bootstrap script
- `installer.py` — interactive symlink installer
- `links.yaml` — source-to-target link definitions
- `configs/` — tracked config sources
