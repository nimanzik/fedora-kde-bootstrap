#!/usr/bin/env bash
# Exercise the Plannotator installer without network access or installing tools.
set -euo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
export REAL_CURL
REAL_CURL=$(command -v curl)
export INSTALLER="$tmp/installer.sh" CURL_LOG="$tmp/curl.log"
mkdir "$tmp/bin"
printf 'exit 0\n' > "$INSTALLER"
# Keep writing well beyond the pipe buffer after the installer exits.
for ((i = 0; i < 10000; i++)); do
    printf '# unused installer content padding padding padding padding padding\n'
done >> "$INSTALLER"

cat > "$tmp/bin/curl" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >> "$CURL_LOG"
args=()
for arg in "$@"; do
    if [[ "$arg" == https://plannotator.ai/install.sh ]]; then
        args+=("file://$INSTALLER")
    else
        args+=("$arg")
    fi
done
if [[ "$*" == *https://plannotator.ai/install.sh* ]]; then
    exec "$REAL_CURL" "${args[@]}"
fi
printf ':\n'
MOCK
chmod +x "$tmp/bin/curl"
export PATH="$tmp/bin:$PATH"

bash "$root/bootstrap.sh" install_custom_curl_tools > "$tmp/output" 2>&1 || {
    grep 'curl:' "$tmp/output" >&2 || true
    printf 'Bootstrap must continue after the minimal installer exits successfully.\n' >&2
    exit 1
}
grep -q 'Byron/dua-cli' "$CURL_LOG"

for failure in download installer; do
    : > "$CURL_LOG"
    if [[ "$failure" == download ]]; then
        rm "$INSTALLER"
    else
        printf 'exit 42\n' > "$INSTALLER"
    fi
    if bash "$root/bootstrap.sh" install_custom_curl_tools > "$tmp/output" 2>&1; then
        printf 'Expected bootstrap to fail on a genuine %s failure.\n' "$failure" >&2
        exit 1
    fi
    if grep -q 'Byron/dua-cli' "$CURL_LOG"; then
        printf 'Bootstrap continued after a genuine %s failure.\n' "$failure" >&2
        exit 1
    fi
done
printf 'Custom curl installer tests passed.\n'
