#!/usr/bin/env bash
set -uo pipefail

if (( EUID == 0 )); then
    printf 'Run this as your normal user, not with sudo. Only dnf uses sudo.\n' >&2
    exit 1
fi

failed=()
update() {
    printf '\n=== %s ===\n' "$*"
    if "$@"; then
        return 0
    else
        local status=$?
        printf 'FAILED (%s): %s\n' "$status" "$*" >&2
        failed+=("$*")
    fi
}

update sudo dnf upgrade --refresh -y
update flatpak update -y
update uv self update
update uv tool upgrade --all
update npm update --global
update hunk update
update herdr update

if (( ${#failed[@]} )); then
    printf '\nFailed updates:\n' >&2
    printf '  %s\n' "${failed[@]}" >&2
    exit 1
fi
printf '\nAll updates completed. A reboot may be needed after system updates.\n'
