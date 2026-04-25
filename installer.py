#!/usr/bin/env python3

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from enum import Enum
from pathlib import Path
import os
import shutil
import tempfile
import urllib.request
import zipfile

from rich.console import Console
from rich.panel import Panel
from rich import box
import yaml


ROOT_DIR = Path(__file__).resolve().parent
CONFIG_DIR = ROOT_DIR / "configs"
LINKS_FILE = ROOT_DIR / "links.yaml"
BACKUP_DIR = ROOT_DIR / ".backup"
console = Console()


class Platform(str, Enum):
    linux = "linux"
    darwin = "darwin"
    other = "other"


FONT_CHOICES = {
    "FiraCode": "FiraCode.zip",
    "JetBrainsMono": "JetBrainsMono.zip",
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


def backup_target(target: Path) -> Path:
    try:
        relative_target = target.relative_to(Path.home())
    except ValueError:
        relative_target = Path(target.name)

    timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    backup_path = BACKUP_DIR / relative_target.parent / f"{relative_target.name}.{timestamp}"
    backup_path.parent.mkdir(parents=True, exist_ok=True)
    shutil.move(str(target), str(backup_path))
    return backup_path


def ensure_link(spec: LinkSpec) -> None:
    spec.target.parent.mkdir(parents=True, exist_ok=True)

    if spec.target.is_symlink() and spec.target.resolve(strict=False) == spec.source:
        console.print(f"ok  {spec.target}")
        return

    if spec.target.exists() or spec.target.is_symlink():
        backup = backup_target(spec.target)
        console.print(f"backup: {backup}")

    os.symlink(spec.source, spec.target)
    console.print(f"link {spec.target} -> {spec.source}")


def font_root_for_platform(platform: Platform) -> Path | None:
    if platform == Platform.linux:
        return Path.home() / ".local/share/fonts/NerdFonts"
    if platform == Platform.darwin:
        return Path.home() / "Library/Fonts/NerdFonts"
    return None


def install_fonts() -> None:
    platform = detect_platform()
    font_root = font_root_for_platform(platform)
    if font_root is None:
        console.print(Panel.fit("Font install is only implemented for Linux and macOS right now.", style="yellow"))
        return

    font_root.mkdir(parents=True, exist_ok=True)

    with tempfile.TemporaryDirectory() as tmpdir:
        tmp_path = Path(tmpdir)
        installed_any = False
        for name in FONT_CHOICES:
            asset = FONT_CHOICES[name]
            url = f"https://github.com/ryanoasis/nerd-fonts/releases/latest/download/{asset}"
            archive = tmp_path / asset
            extract_dir = font_root / name

            if extract_dir.exists() and any(extract_dir.rglob("*.ttf")):
                console.print(f"skip  {name} (already installed)")
                continue

            extract_dir.mkdir(parents=True, exist_ok=True)

            console.print(Panel.fit(f"Downloading [bold]{name}[/bold]", box=box.ROUNDED))
            urllib.request.urlretrieve(url, archive)

            with zipfile.ZipFile(archive) as zipf:
                zipf.extractall(extract_dir)

            console.print(f"installed {name} -> {extract_dir}")
            installed_any = True

        if not installed_any:
            console.print("No missing Nerd Fonts found.")


def main() -> int:
    install_fonts()
    for spec in load_links():
        ensure_link(spec)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
