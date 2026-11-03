# Fedora KDE laptop setup

This repo turns a fresh Fedora KDE Plasma setup into a repeatable bootstrap process.

## Use on a fresh laptop

```bash
git clone <repo-url>
cd fedora-kde-bootstrap
chmod +x bootstrap.sh
./bootstrap.sh --all-steps
```

To show usage or list available steps without running setup:

```bash
./bootstrap.sh --help
./bootstrap.sh list-steps
```

Running without arguments also shows help and does not run setup. You can also
use `-h` for help. Steps are listed in execution order.

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
./bootstrap.sh --all-steps
```

The script is intended to be safe to rerun. It skips or updates tools where possible.

It also installs a few Nerd Fonts (e.g. Fira Code, JetBrains Mono, IBMPlexMono)
under `~/.local/share/fonts/nerd-fonts`, plus the latest Font Awesome Free Desktop
release under `~/.local/share/fonts/fontawesome`.

Installers fetched with `curl` track their upstream latest version, so their
results are not version-pinned.

## Update installed software

Bootstrap links `scripts/update_all.sh` into `~/bin/update-all`. To install only
the command, run:

```bash
./bootstrap.sh link_update_all
```

An existing script is backed up as `~/bin/update-all.bak`. Earlier backups are
kept with numbered suffixes. Keep the repo in place because the command links
to its copy here, and repo edits affect the installed command immediately.

Run `update-all` as your normal user, not with sudo. It updates DNF packages,
Flatpaks, uv, uv tools, global npm packages, Hunk, and Herdr. Only DNF uses sudo.
It continues after failures and reports them at the end with a nonzero exit.
It does not update every tool bootstrap installs, such as Cargo tools.

## Check the scripts

```bash
./scripts/check.sh
```
