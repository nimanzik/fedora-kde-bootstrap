# Fedora KDE laptop setup

This repo turns a fresh Fedora KDE Plasma setup into a repeatable bootstrap process.

## Use on a fresh laptop

```bash
git clone <repo-url>
cd fedora-kde-bootstrap
chmod +x bootstrap.sh
./bootstrap.sh
```

To run or rerun one step, pass its function name, for example:

```bash
./bootstrap.sh install_uv_tools
```

After the script finishes:

1. Restart the terminal.
2. Reboot if Flatpak apps or shell changes do not show up.
3. Follow [`docs/post-install.md`](docs/post-install.md).

## Add or remove software

Edit the package list files under `packages/` and rerun:

```bash
./bootstrap.sh
```

The script is intended to be safe to rerun. It skips or updates tools where possible.

It also installs a few Nerd Fonts (e.g. Fira Code, JetBrains Mono, IBMPlexMono) under `~/.local/share/fonts/nerd-fonts`, plus the latest Font Awesome Free Desktop release under `~/.local/share/fonts/fontawesome`.

Installers fetched with `curl` track their upstream latest version, so their results are not version-pinned.

## Check the scripts

```bash
./scripts/check.sh
```
