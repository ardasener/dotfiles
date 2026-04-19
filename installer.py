#!/usr/bin/env python3

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from difflib import unified_diff
from enum import Enum
from pathlib import Path
from shutil import which
import os
import shutil
import tempfile
import urllib.request
import zipfile

from InquirerPy import inquirer
from rich.console import Console
from rich.panel import Panel
from rich import box
from rich.text import Text
import yaml


ROOT_DIR = Path(__file__).resolve().parent
CONFIG_DIR = ROOT_DIR / "configs"
LINKS_FILE = ROOT_DIR / "links.yaml"
console = Console()


class Platform(str, Enum):
    linux = "linux"
    darwin = "darwin"
    other = "other"


FONT_CHOICES = {
    "FiraCode": "FiraCode.zip",
    "JetBrainsMono": "JetBrainsMono.zip",
    "GoMono": "Go-Mono.zip",
}


@dataclass(frozen=True)
class LinkSpec:
    source: Path
    target: Path


def load_links() -> list[LinkSpec]:
    data = yaml.safe_load(LINKS_FILE.read_text()) or {}
    items = data.get("links", [])
    links: list[LinkSpec] = []

    for item in items:
        source = CONFIG_DIR / item["source"]
        target_raw = item["target"]
        target = Path(target_raw) if target_raw.startswith("/") else Path.home() / target_raw
        links.append(LinkSpec(source=source, target=target))

    return links


def detect_platform() -> Platform:
    if os.uname().sysname.lower() == "linux":
        return Platform.linux
    if os.uname().sysname.lower() == "darwin":
        return Platform.darwin
    return Platform.other


def show_diff(source: Path, target: Path) -> None:
    if source.is_file() and target.is_file():
        diff = unified_diff(
            target.read_text().splitlines(),
            source.read_text().splitlines(),
            fromfile=str(target),
            tofile=str(source),
            lineterm="",
        )
        console.print(Panel.fit(f"[bold]Diff[/bold] {target} -> {source}", box=box.ROUNDED))
        for line in diff:
            if line.startswith("---") or line.startswith("+++"):
                console.print(Text(line, style="bold cyan"))
            elif line.startswith("@@"):
                console.print(Text(line, style="bold magenta"))
            elif line.startswith("+"):
                console.print(Text(line, style="green"))
            elif line.startswith("-"):
                console.print(Text(line, style="red"))
            else:
                console.print(line)
    else:
        console.print(Panel.fit("No textual diff available.", style="yellow"))


def ensure_link(spec: LinkSpec, install_all: bool) -> bool:
    spec.target.parent.mkdir(parents=True, exist_ok=True)

    if spec.target.is_symlink() and spec.target.resolve(strict=False) == spec.source:
        console.print(f"ok  {spec.target}")
        return install_all

    if spec.target.exists() or spec.target.is_symlink():
        if not install_all:
            while True:
                console.print(Panel.fit(
                    f"[bold]{spec.target}[/bold]\nsource: {spec.source}\nstatus: exists",
                    box=box.ROUNDED,
                ))
                choice = inquirer.select(
                    message="Action",
                    choices=[
                        ("Install", "install"),
                        ("Show diff", "diff"),
                        ("Skip", "skip"),
                        ("Install all", "all"),
                        ("Quit", "quit"),
                    ],
                    default="install",
                ).execute()
                if choice == "diff":
                    show_diff(spec.source, spec.target)
                    continue
                if choice == "skip":
                    console.print(f"skip {spec.target}")
                    return install_all
                if choice == "quit":
                    raise SystemExit(0)
                if choice == "all":
                    install_all = True
                break

        backup = spec.target.with_name(f"{spec.target.name}.bak.{datetime.now().strftime('%Y%m%d%H%M%S')}")
        shutil.move(str(spec.target), str(backup))
        console.print(f"backup: {backup}")

    os.symlink(spec.source, spec.target)
    console.print(f"link {spec.target} -> {spec.source}")
    return install_all


def install_fonts() -> None:
    platform = detect_platform()
    if platform != Platform.linux:
        console.print(Panel.fit("Font install is only implemented for Linux right now.", style="yellow"))
        return

    selected = inquirer.checkbox(
        message="Select Nerd Fonts to install",
        choices=list(FONT_CHOICES.keys()),
        default=["FiraCode"],
    ).execute()

    if not selected:
        console.print("No fonts selected.")
        return

    font_root = Path.home() / ".local/share/fonts/NerdFonts"
    font_root.mkdir(parents=True, exist_ok=True)

    with tempfile.TemporaryDirectory() as tmpdir:
        tmp_path = Path(tmpdir)
        for name in selected:
            asset = FONT_CHOICES[name]
            url = f"https://github.com/ryanoasis/nerd-fonts/releases/latest/download/{asset}"
            archive = tmp_path / asset
            extract_dir = font_root / name
            extract_dir.mkdir(parents=True, exist_ok=True)

            console.print(Panel.fit(f"Downloading [bold]{name}[/bold]", box=box.ROUNDED))
            urllib.request.urlretrieve(url, archive)

            with zipfile.ZipFile(archive) as zipf:
                zipf.extractall(extract_dir)

            console.print(f"installed {name} -> {extract_dir}")

    if which("fc-cache"):
        os.system("fc-cache -fv >/dev/null")
        console.print("font cache refreshed")


def maybe_install_fonts() -> None:
    choice = inquirer.confirm(
        message="Install a Nerd Font now?",
        default=False,
    ).execute()
    if choice:
        install_fonts()


def main() -> int:
    maybe_install_fonts()
    install_all = False
    for spec in load_links():
        install_all = ensure_link(spec, install_all)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
