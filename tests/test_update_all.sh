#!/usr/bin/env bash
# Exercise the updater without installing anything or invoking sudo.
set -euo pipefail

script=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)/scripts/update_all.sh
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
export UPDATE_LOG="$tmp/log"
export FAIL_COMMAND=''

mkdir "$tmp/bin"
# Variables belong to the generated mock, not this test process.
# shellcheck disable=SC2016
printf '%s\n' '#!/usr/bin/env bash' \
    'printf "%s\n" "${0##*/} $*" >> "$UPDATE_LOG"' \
    '[[ ${0##*/} != "$FAIL_COMMAND" ]]' > "$tmp/bin/mock"
chmod +x "$tmp/bin/mock"
for command in sudo flatpak uv npm hunk herdr; do
    ln -s mock "$tmp/bin/$command"
done
export PATH="$tmp/bin:$PATH"

bash "$script" > "$tmp/output" 2>&1
diff -u <(printf '%s\n' \
    'sudo dnf upgrade --refresh -y' \
    'flatpak update -y' \
    'uv self update' \
    'uv tool upgrade --all' \
    'npm update --global' \
    'hunk update' \
    'herdr update') "$UPDATE_LOG"
grep -q 'All updates completed' "$tmp/output"

export FAIL_COMMAND=flatpak
: > "$UPDATE_LOG"
if bash "$script" > "$tmp/output" 2>&1; then
    printf 'Expected a nonzero exit when flatpak fails.\n' >&2
    exit 1
fi
grep -q 'Failed updates:' "$tmp/output"
grep -q 'flatpak update' "$tmp/output"
grep -qx 'herdr update' "$UPDATE_LOG"
[[ $(wc -l < "$UPDATE_LOG") -eq 7 ]]
printf 'Updater tests passed.\n'
