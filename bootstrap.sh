#!/usr/bin/env bash

# Set up a Fedora KDE machine. Run without arguments for all steps, or pass one step name.

set -euo pipefail

NODE_VERSION="26"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log_info() {
    printf '\n\033[1;34m==> %s\033[0m\n' "$*"
}

log_warn() {
    printf '\n\033[1;33mWARN: %s\033[0m\n' "$*"
}

log_error() {
    printf '\n\033[1;31mERROR: %s\033[0m\n' "$*" >&2
}

install_dnf_packages() {
    log_info "Installing Fedora DNF packages..."
    sudo dnf install -y @development-tools

    local packages
    mapfile -t packages < "$ROOT_DIR/packages/dnf.txt"
    sudo dnf install -y "${packages[@]}"
}

install_flatpak_apps() {
    log_info "Installing Flatpak apps..."
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    local apps
    mapfile -t apps < "$ROOT_DIR/packages/flatpak.txt"
    flatpak install -y flathub "${apps[@]}"
}

install_oh_my_zsh() {
    log_info "Installing oh-my-zsh..."

    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | \
            env RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh
    else
        echo "oh-my-zsh is already installed. Nothing to do."
    fi

    local zsh_path
    zsh_path="$(command -v zsh)"
    if [[ "${SHELL:-}" != "$zsh_path" ]]; then
        log_warn "Default shell is not zsh. Run this to set zsh as default: chsh -s $zsh_path"
    fi
}

install_rust_and_cargo() {
    log_info "Installing Rust and Cargo..."

    if ! command -v cargo >/dev/null 2>&1; then
        curl https://sh.rustup.rs -sSf | sh -s -- -y
    else
        echo "Rust and Cargo are already installed. Nothing to do."
    fi

    # shellcheck disable=SC1091
    [[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
}

install_cargo_tools() {
    log_info "Installing Cargo tools..."

    if ! command -v cargo >/dev/null 2>&1; then
        log_warn "cargo is not available. Skipping Cargo tools."
        return
    fi

    local packages package
    mapfile -t packages < "$ROOT_DIR/packages/cargo.txt"
    for package in "${packages[@]}"; do
        cargo install --locked "$package" || log_warn "Could not install or update Cargo package: $package"
    done
}

install_uv() {
    log_info "Installing uv..."

    if ! command -v uv >/dev/null 2>&1; then
        curl -LsSf https://astral.sh/uv/install.sh | sh
    else
        echo "uv is already installed. Nothing to do."
    fi

    export PATH="$HOME/.local/bin:$PATH"
}

install_uv_tools() {
    log_info "Installing uv tools..."

    if ! command -v uv >/dev/null 2>&1; then
        log_warn "uv is not available. Skipping uv tools."
        return
    fi

    local tools tool
    mapfile -t tools < "$ROOT_DIR/packages/uv.txt"
    for tool in "${tools[@]}"; do
        uv tool install "$tool@latest"
    done
}

install_node() {
    log_info "Installing nvm and Node.js $NODE_VERSION..."

    if [[ ! -d "$HOME/.nvm" ]]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    else
        echo "nvm is already installed."
    fi

    export NVM_DIR="$HOME/.nvm"
    # shellcheck disable=SC1091
    source "$NVM_DIR/nvm.sh"

    nvm install "$NODE_VERSION"
    nvm use "$NODE_VERSION"
    nvm alias default "$NODE_VERSION"
}

install_npm_tools() {
    log_info "Installing global npm tools..."

    if ! command -v npm >/dev/null 2>&1; then
        log_warn "npm is not available. Skipping npm tools."
        return
    fi

    local packages
    mapfile -t packages < "$ROOT_DIR/packages/npm.txt"
    npm install -g "${packages[@]}"
}

install_custom_curl_tools() {
    log_info "Installing custom tools via curl..."

    # Pi coding agent
    curl -fsSL https://pi.dev/install.sh | sh
    # Zed coding editor
    curl -f https://zed.dev/install.sh | sh
    # Herdr (terminal multiplexer)
    curl -fsSL https://herdr.dev/install.sh | sh
    # Hunk (terminal diff tool)
    curl -fsSL https://hunk.dev/install.sh | sh
    # Leaf (terminal markdown viewer)
    curl -fsSL https://raw.githubusercontent.com/RivoLink/leaf/main/scripts/install.sh | sh
    # Dua-cli (disk usage analyzer)
    curl -LSfs https://raw.githubusercontent.com/Byron/dua-cli/master/ci/install.sh | \
        sh -s -- --git Byron/dua-cli --target x86_64-unknown-linux-musl --crate dua
}

install_nerd_fonts() {
    log_info "Installing Nerd Fonts..."

    local font_dir="$HOME/.local/share/fonts/nerd-fonts" font_name archive
    mkdir -p "$font_dir"

    local -a nerd_fonts=(
        FiraCode
        GeistMono
        JetBrainsMono
        IBMPlexMono
        NerdFontsSymbolsOnly
        RobotoMono
    )

    for font_name in "${nerd_fonts[@]}"; do
        if [[ -d "$font_dir/$font_name" ]]; then
            echo "$font_name Nerd Font is already installed. Nothing to do."
            continue
        fi

        archive="$(mktemp --suffix=.zip)"
        curl -fL --retry 3 "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font_name}.zip" -o "$archive"
        unzip -q "$archive" -d "$font_dir/$font_name"
        rm -f "$archive"
    done

    fc-cache -f "$font_dir"
}

install_extra_fonts() {
    log_info "Installing extra fonts..."

    local font_dir="$HOME/.local/share/fonts/fontawesome" archive
    if [[ -d "$font_dir" ]]; then
        echo "Font Awesome Free Desktop is already installed. Nothing to do."
    else
        archive="$(mktemp --suffix=.zip)"
        curl -fL --retry 3 "https://github.com/FortAwesome/Font-Awesome/releases/download/7.3.1/fontawesome-free-7.3.1-desktop.zip" -o "$archive"
        unzip -q "$archive" -d "$font_dir"
        rm -f "$archive"
    fi

    fc-cache -f "$font_dir"
}

link_dotfiles() {
    log_info "Linking dotfiles..."

    local zsh_custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    local file
    mkdir -p "$zsh_custom_dir"

    for file in .gitconfig .inputrc .vimrc .zshrc; do
        if [[ -e "$HOME/$file" && ! -L "$HOME/$file" ]]; then
            mv --backup=numbered "$HOME/$file" "$HOME/$file.bak"
        fi
        ln -sfn "$ROOT_DIR/dotfiles/$file" "$HOME/$file"
    done

    for file in "$ROOT_DIR"/dotfiles/zsh-custom/*.zsh; do
        ln -sf "$file" "$zsh_custom_dir/"
        echo "linked ${file##*/} -> $zsh_custom_dir"
    done
}

STEPS=(
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

run_step() {
    local requested="$1" step
    for step in "${STEPS[@]}"; do
        if [[ "$requested" == "$step" ]]; then
            "$step"
            return
        fi
    done

    log_error "Unknown step '$requested'. Available steps: ${STEPS[*]}"
    return 1
}

if (( $# > 0 )); then
    run_step "$1"
else
    for step in "${STEPS[@]}"; do
        "$step"
    done
fi

log_info "Done. Restart your terminal, then follow docs/post-install.md."
