#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import subprocess
import sys
from pathlib import Path

COLORS = [
    "#5e315b", "#8c3f5d", "#ba6156", "#f2a65e", "#ffe478",
    "#cfff70", "#8fde5d", "#3ca370", "#3d6e70", "#323e4f",
    "#322947", "#473b78", "#4b5bab", "#4da6ff", "#66ffe3",
    "#c2c2d1", "#7e7e8f", "#606070", "#43434f", "#3e2347",
    "#57294b", "#964253", "#e36956", "#ffb570", "#ff9166",
    "#eb564b", "#b0305c", "#73275c", "#422445", "#5a265e",
    "#80366b", "#bd4882", "#ff6b97", "#ffb5b5",
]

FG_LIGHT = "#cdd6f4"
FG_DARK = "#1e1e2e"


def hex_to_rgb(hex_color: str) -> tuple[float, float, float]:
    h = hex_color.lstrip("#")
    r = int(h[0:2], 16) / 255.0
    g = int(h[2:4], 16) / 255.0
    b = int(h[4:6], 16) / 255.0
    return r, g, b


def relative_luminance(r: float, g: float, b: float) -> float:
    def linearize(c: float) -> float:
        return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4
    return 0.2126 * linearize(r) + 0.7152 * linearize(g) + 0.0722 * linearize(b)


def session_name_for(path: Path) -> str:
    raw = str(path.resolve())
    h = hashlib.md5(raw.encode()).hexdigest()[:8]
    return f"ws-{h}"


def color_for(path: Path) -> tuple[str, str]:
    raw = str(path.resolve())
    idx = int(hashlib.md5(raw.encode()).hexdigest(), 16) % len(COLORS)
    bg = COLORS[idx]
    r, g, b = hex_to_rgb(bg)
    lum = relative_luminance(r, g, b)
    fg = FG_LIGHT if lum < 0.4 else FG_DARK
    return bg, fg


def build_status_format(bg: str, fg: str, dim_fg: str, active_fg: str, label: str) -> str:
    return (
        "#[align=left range=left]"
        "#[list=on align=left]"
        "#[list=left-marker]<#[list=right-marker]>"
        "#[list=on]"
        "{{W:"
        "#[range=window|#{{window_index}} bg={bg},fg={dim_fg}]"
        "#[push-default] #{{window_name}} #[pop-default]"
        "#[norange default]"
        ","
        "#[range=window|#{{window_index}} list=focus bg={bg},fg={active_fg},bold]"
        "#[push-default] #{{window_name}} #[pop-default]"
        "#[norange list=on default]"
        "}}"
        "#[nolist align=right range=right bg={bg},fg={fg}]"
        "#[push-default] {label} #[pop-default]"
        "#[norange default]"
    ).format(bg=bg, dim_fg=dim_fg, active_fg=active_fg, fg=fg, label=label)


def launch_session(target_dir: Path, session_name: str, bg: str, fg: str) -> None:
    windows = [
        ("AI", ["opencode"]),
        ("Editor", ["nvim", "."]),
        ("Git", ["lazygit"]),
        ("Monitor", ["btop"]),
    ]

    tmux_cmd = [
        "tmux", "new-session", "-d", "-s", session_name, "-c", str(target_dir),
        "-n", windows[0][0], *windows[0][1],
    ]
    for name, cmd in windows[1:]:
        tmux_cmd += [";", "new-window", "-t", session_name, "-c", str(target_dir), "-n", name, *cmd]

    tmux_cmd += [
        ";", "new-window", "-d", "-t", session_name, "-c", str(target_dir), "-n", "Terminal",
        ";", "select-window", "-t", f"{session_name}:1",
    ]

    subprocess.run(tmux_cmd, check=True)

    if fg == FG_LIGHT:
        dim_fg = "#6c7086"
        active_fg = "#ffffff"
    else:
        dim_fg = "#585b70"
        active_fg = "#000000"

    project_label = target_dir.name if target_dir != Path.home() else ""

    status_fmt = build_status_format(bg, fg, dim_fg, active_fg, project_label)
    subprocess.run([
        "tmux", "set", "-t", session_name, 'status-format[0]', status_fmt
    ], check=True)


def main(argv: list[str] | None = None) -> int:
    if argv is None:
        argv = sys.argv[1:]

    command = "start"
    path = "."

    if argv and argv[0] in ("start", "reset"):
        command = argv[0]
        if len(argv) > 1:
            path = argv[1]
    elif argv:
        path = argv[0]

    target_dir = Path(path).expanduser()
    if not target_dir.is_dir():
        print(f"workspace: not a directory: {target_dir}", file=sys.stderr)
        return 1

    target_dir = target_dir.resolve()
    name = session_name_for(target_dir)

    if command == "reset":
        subprocess.run(
            ["tmux", "kill-session", "-t", name],
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
        )
        return 0

    has_session = (
        subprocess.run(
            ["tmux", "has-session", "-t", name],
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
        ).returncode == 0
    )

    if has_session:
        raise SystemExit(subprocess.call(["tmux", "attach", "-t", name]))

    bg, fg = color_for(target_dir)
    launch_session(target_dir, name, bg, fg)
    raise SystemExit(subprocess.call(["tmux", "attach", "-t", name]))


if __name__ == "__main__":
    raise SystemExit(main())
