#!/usr/bin/env python3

from __future__ import annotations

import argparse
import subprocess
from pathlib import Path
import sys

from InquirerPy import inquirer


def session_name_for(path: Path) -> str:
    raw = str(path.resolve())
    cleaned = ''.join(ch if ch.isalnum() or ch in '_-' else '-' for ch in raw)
    return f"workspace-{cleaned.strip('-') or 'home'}"


def launch_workspace(target_dir: Path, session_name: str) -> None:
    commands = [
        ("AI", ["opencode"]),
        ("Editor", ["nvim", "."]),
        ("Files", ["mc"]),
        ("Git", ["lazygit"]),
        ("System", ["btop"]),
    ]

    tmux_cmd: list[str] = [
        "tmux",
        "new-session",
        "-d",
        "-s",
        session_name,
        "-c",
        str(target_dir),
        "-n",
        commands[0][0],
        *commands[0][1],
    ]

    for window_name, command in commands[1:]:
        tmux_cmd += [
            ";",
            "new-window",
            "-t",
            session_name,
            "-c",
            str(target_dir),
            "-n",
            window_name,
            *command,
        ]

    tmux_cmd += [
        ";",
        "new-window",
        "-d",
        "-t",
        session_name,
        "-c",
        str(target_dir),
        "-n",
        "Shell",
        ";",
        "select-window",
        "-t",
        f"{session_name}:Shell",
        ";",
        "split-window",
        "-h",
        "-t",
        f"{session_name}:Shell",
        "-c",
        str(target_dir),
        ";",
        "select-window",
        "-t",
        f"{session_name}:1",
    ]

    subprocess.run(tmux_cmd, check=True)


def prompt_existing_workspace(session_name: str) -> str:
    return inquirer.select(
        message=f"Workspace {session_name} exists. What do you want to do?",
        choices=["attach", "recreate", "delete", "none"],
        default="attach",
    ).execute()


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Open a tmux-backed workspace")
    parser.add_argument("path", nargs="?", default=".", help="Directory to open")
    args = parser.parse_args(argv)

    target_dir = Path(args.path).expanduser()
    if not target_dir.is_dir():
        print(f"workspace: not a directory: {target_dir}", file=sys.stderr)
        return 1

    target_dir = target_dir.resolve()
    session_name = session_name_for(target_dir)

    has_session = subprocess.run(
        ["tmux", "has-session", "-t", session_name],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    ).returncode == 0

    if has_session:
        choice = prompt_existing_workspace(session_name)
        if choice == "attach":
            raise SystemExit(subprocess.call(["tmux", "attach", "-t", session_name]))
        if choice == "recreate":
            subprocess.run(["tmux", "kill-session", "-t", session_name], check=True)
            launch_workspace(target_dir, session_name)
            raise SystemExit(subprocess.call(["tmux", "attach", "-t", session_name]))
        if choice == "delete":
            subprocess.run(["tmux", "kill-session", "-t", session_name], check=True)
            return 0
        return 0

    launch_workspace(target_dir, session_name)
    raise SystemExit(subprocess.call(["tmux", "attach", "-t", session_name]))


if __name__ == "__main__":
    raise SystemExit(main())
