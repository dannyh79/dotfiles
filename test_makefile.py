#!/usr/bin/env python3
import os
import shutil
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def make(directory: Path, home: Path, target: str) -> None:
    result = subprocess.run(
        ["make", target],
        cwd=directory,
        env={**os.environ, "HOME": str(home), "PWD": str(directory)},
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0, result.stderr

def make_from_config(home: Path, target: str) -> None:
    result = subprocess.run(
        ["/bin/sh", "-c", f'cd "$HOME/.config" && make {target}'],
        env={**os.environ, "HOME": str(home)},
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0, result.stderr


with tempfile.TemporaryDirectory() as temporary_directory:
    home = Path(temporary_directory) / "home"
    repo = home / ".config.bk"
    config = home / ".config"
    backup = home / ".config.orig"
    repo.mkdir(parents=True)
    config.mkdir()
    (config / "sentinel").write_text("preserve me")
    shutil.copy(ROOT / "Makefile", repo / "Makefile")

    make(repo, home, "init-config")
    assert config.is_symlink()
    assert config.resolve() == repo.resolve()
    assert (backup / "sentinel").read_text() == "preserve me"
    assert not (repo / ".config").exists()

    make_from_config(home, "init-config")
    assert config.is_symlink()
    assert config.resolve() == repo.resolve()
    assert (backup / "sentinel").read_text() == "preserve me"
    assert not (repo / ".config").exists()

    make(repo, home, "restore-config")
    assert config.is_dir()
    assert not config.is_symlink()
    assert (config / "sentinel").read_text() == "preserve me"

with tempfile.TemporaryDirectory() as temporary_directory:
    home = Path(temporary_directory) / "home"
    repo = home / ".config.bk"
    repo.mkdir(parents=True)
    shutil.copy(ROOT / "Makefile", repo / "Makefile")
    sources = {
        "git": repo / "git" / "gitconfig",
        "tmux": repo / "tmux" / "tmux.conf",
        "zsh": repo / "zsh" / "zshrc",
    }
    for source in sources.values():
        source.parent.mkdir(parents=True, exist_ok=True)
        source.write_text("true\n")
    installer = home / ".tmux" / "plugins" / "tpm" / "bin" / "install_plugins"
    installer.parent.mkdir(parents=True)
    installer.write_text("#!/bin/sh\n")
    installer.chmod(0o755)

    cases = [
        ("git", home / ".gitconfig", home / ".gitconfig.bk"),
        ("tmux", home / ".tmux.conf", home / ".tmux.conf.bk"),
        ("zsh", home / ".zshrc", home / ".zshrc.bk"),
    ]
    for name, target, backup in cases:
        original = f"{name} original\n"
        target.write_text(original)

        make(repo, home, f"init-{name}")
        assert target.is_symlink()
        assert target.resolve() == sources[name].resolve()
        assert backup.read_text() == original

        make(repo, home, f"init-{name}")
        assert target.resolve() == sources[name].resolve()
        assert backup.read_text() == original

        make(repo, home, f"restore-{name}")
        assert target.read_text() == original
