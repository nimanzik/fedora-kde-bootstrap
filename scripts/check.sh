#!/usr/bin/env bash

# Check the bootstrap script and shell, editor, and Git configuration for errors.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash -n "$ROOT_DIR/bootstrap.sh"

if command -v shellcheck >/dev/null; then
    shellcheck "$ROOT_DIR/bootstrap.sh" "$ROOT_DIR/scripts/check.sh"
else
    printf 'ShellCheck is not installed, so linting was skipped. Run: ./bootstrap.sh install_dnf_packages\n' >&2
fi

for file in "$ROOT_DIR/dotfiles/.zshrc" "$ROOT_DIR"/dotfiles/zsh-custom/*.zsh; do
    zsh -n "$file"
done

vimx -Nu "$ROOT_DIR/dotfiles/.vimrc" -n -es -i NONE -c 'quit'
git config --file "$ROOT_DIR/dotfiles/.gitconfig" --list >/dev/null

printf 'All available checks passed.\n'
