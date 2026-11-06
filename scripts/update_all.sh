#!/usr/bin/env bash
set -uo pipefail

if (( EUID == 0 )); then
    printf 'Run this as your normal user, not with sudo. Only dnf uses sudo.\n' >&2
    exit 1
fi

failed=()
run_update() {
    printf '\n=== %s ===\n' "$*"
    if "$@"; then
        return 0
    else
        local status=$?
        printf 'FAILED (%s): %s\n' "$status" "$*" >&2
        failed+=("$*")
    fi
}

run_update sudo dnf upgrade --refresh -y
run_update flatpak update -y
run_update uv self update
run_update uv tool upgrade --all
run_update npm update --global
HUNK_NO_MODIFY_PATH=1 run_update hunk update
run_update herdr update
run_update pi update
run_update pi update --extensions
run_update npx skills@latest update --global

if (( ${#failed[@]} )); then
    printf '\nFailed updates:\n' >&2
    printf '  %s\n' "${failed[@]}" >&2
    exit 1
fi
printf '\nAll updates completed. A reboot may be needed after system updates.\n'
