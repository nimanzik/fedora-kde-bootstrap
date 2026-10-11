#!/usr/bin/env bash

# Check the bootstrap script and shell, editor, and Git configuration for errors.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash -n "$ROOT_DIR/bootstrap.sh"

help_output="$(bash "$ROOT_DIR/bootstrap.sh" --help)"
[[ "$help_output" == Usage:* ]]
[[ "$help_output" == *'install_uv_tools'* ]]
[[ "$help_output" == *'--all-steps'* ]]
[[ "$(bash "$ROOT_DIR/bootstrap.sh")" == "$help_output" ]]
for option in -h --help; do
    [[ "$(bash "$ROOT_DIR/bootstrap.sh" "$option")" == "$help_output" ]]
done

expected_steps=(
    install_dnf_packages
    install_flatpak_apps
    install_oh_my_zsh
    install_rust_and_cargo
    install_cargo_tools
    install_uv
    install_uv_tools
    install_node
    install_npm_tools
    install_custom_curl_tools
    install_nerd_fonts
    install_extra_fonts
    link_dotfiles
)
[[ "$(bash "$ROOT_DIR/bootstrap.sh" list-steps)" == "$(printf '%s\n' "${expected_steps[@]}")" ]]

for step in unknown-step help; do
    if bash "$ROOT_DIR/bootstrap.sh" "$step" >/dev/null 2>&1; then
        printf 'An unknown step should fail: %s\n' "$step" >&2
        exit 1
    fi
done

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
