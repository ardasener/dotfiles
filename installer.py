#!/usr/bin/env python3

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from enum import Enum
from pathlib import Path
import os
import shutil
import subprocess
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
SKILLS_DIR = Path.home() / ".agents" / "skills"
OPENCODE_CONFIG = Path.home() / ".config" / "opencode" / "opencode.json"
console = Console()

REQUIRED_SKILLS = [
    "godot-master",
    "find-skills",
]

REQUIRED_PLUGINS = [
    "superpowers",
]

SKILL_INSTALL_HINTS = {
    "godot-master": "npx skills add thedivergentai/gd-agentic-skills/skills/godot-master",
}

# Pinned godot-master skill revision. Full SHA so it can never move.
# 6cb0843 = GDSkills v0.0.7, last release targeting Godot 4.6.
# Bump only when intentionally upgrading past 4.6.
GODOT_MASTER_REF = "6cb08431f1a7b394a9647b4f12d7d49376c02f74"

PLUGIN_INSTALL_HINTS = {
    "superpowers": 'Add "superpowers@git+https://github.com/obra/superpowers.git" to the plugin array in opencode.json',
}


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


def link_kind(spec: LinkSpec) -> str:
    source_parts = spec.source.parts
    if "agents" in source_parts:
        return "agent"
    if "commands" in source_parts:
        return "command"
    return "file"


def load_links() -> list[LinkSpec]:
    data = yaml.safe_load(LINKS_FILE.read_text()) or {}
    items = data.get("links", [])
    links: list[LinkSpec] = []

    for item in items:
        source = CONFIG_DIR / item["source"]
        target_raw = item["target"]
        target = Path(target_raw) if target_raw.startswith("/") else Path.home() / target_raw
        links.append(LinkSpec(source=source, target=target))

    console.print(f"loaded {len(links)} link(s) from {LINKS_FILE.name}")
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
    kind = link_kind(spec)

    if spec.target.is_symlink() and spec.target.resolve(strict=False) == spec.source:
        console.print(f"ok  {kind}: {spec.target}")
        return

    if spec.target.exists() or spec.target.is_symlink():
        backup = backup_target(spec.target)
        console.print(f"backup: {backup}")

    console.print(f"install {kind}: {spec.target} <- {spec.source}")
    os.symlink(spec.source, spec.target)
    console.print(f"linked {kind}: {spec.target} -> {spec.source}")


def font_root_for_platform(platform: Platform) -> Path | None:
    if platform == Platform.linux:
        return Path.home() / ".local/share/fonts/NerdFonts"
    if platform == Platform.darwin:
        return Path.home() / "Library/Fonts/NerdFonts"
    return None


def check_required_skills() -> None:
    missing = []
    for skill in REQUIRED_SKILLS:
        skill_path = SKILLS_DIR / skill
        if not skill_path.exists():
            missing.append(skill)

    if missing:
        console.print(Panel.fit(
            "[yellow]Missing recommended skills:[/yellow]\n" +
            "\n".join(f"  - {s}" for s in missing) +
            "\n\n[yellow]To install:[/yellow]\n" +
            "\n".join(f"  - {SKILL_INSTALL_HINTS.get(s, 'Unknown')}" for s in missing),
            title="[red]Skill Check[/red]",
            style="yellow"
        ))


def check_required_plugins() -> None:
    missing = []
    if OPENCODE_CONFIG.exists():
        import json
        try:
            config = json.loads(OPENCODE_CONFIG.read_text())
            plugins = config.get("plugin", [])
            for required in REQUIRED_PLUGINS:
                if not any(required in str(p) for p in plugins):
                    missing.append(required)
        except (json.JSONDecodeError, IOError):
            missing = list(REQUIRED_PLUGINS)
    else:
        missing = list(REQUIRED_PLUGINS)

    if missing:
        console.print(Panel.fit(
            "[yellow]Missing recommended plugins:[/yellow]\n" +
            "\n".join(f"  - {p}" for p in missing) +
            "\n\n[yellow]To install:[/yellow]\n" +
            "\n".join(f"  - {PLUGIN_INSTALL_HINTS.get(p, 'Unknown')}" for p in missing),
            title="[red]Plugin Check[/red]",
            style="yellow"
        ))


def sync_godot_master_skill() -> None:
    godot_skill_target = CONFIG_DIR / "agents" / "godot-master"

    console.print("[yellow]Syncing godot-master skill from external repository...[/yellow]")
    try:
        with tempfile.TemporaryDirectory() as tmpdir:
            tmp_path = Path(tmpdir)
            subprocess.run(
                ["git", "clone", "--depth", "1",
                 "https://github.com/thedivergentai/GD-Agentic-Skills.git",
                 str(tmp_path / "gd-agentic-skills")],
                check=True,
                capture_output=True
            )
            # --depth 1 clone has no history; unshallow just enough to reach the pin.
            subprocess.run(
                ["git", "-C", str(tmp_path / "gd-agentic-skills"),
                 "fetch", "--quiet", "--depth", "1", "origin", GODOT_MASTER_REF],
                check=True,
                capture_output=True
            )
            subprocess.run(
                ["git", "-C", str(tmp_path / "gd-agentic-skills"),
                 "checkout", "--quiet", GODOT_MASTER_REF],
                check=True,
                capture_output=True
            )
            source_skill = tmp_path / "gd-agentic-skills" / "skills" / "godot-master"
            if source_skill.exists():
                if godot_skill_target.exists():
                    shutil.rmtree(godot_skill_target)
                shutil.copytree(source_skill, godot_skill_target)
                console.print("[green]godot-master skill synced successfully[/green]")
            else:
                console.print("[red]godot-master skill not found in repository[/red]")
    except Exception as e:
        console.print(f"[red]Failed to sync godot-master skill: {e}[/red]")


def install_fzf() -> None:
    if shutil.which("fzf"):
        console.print("ok  fzf (already installed)")
        return

    platform = detect_platform()
    if platform == Platform.darwin:
        console.print("[yellow]Installing fzf via brew...[/yellow]")
        subprocess.run(["brew", "install", "fzf"], check=True)
        console.print("[green]fzf installed[/green]")
    else:
        console.print("[yellow]fzf not found. Install via your package manager: apt install fzf / pacman -S fzf[/yellow]")


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
    console.print("starting config installation")
    install_fonts()
    install_fzf()
    sync_godot_master_skill()
    for spec in load_links():
        ensure_link(spec)
    check_required_skills()
    check_required_plugins()
    console.print("installation complete")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
