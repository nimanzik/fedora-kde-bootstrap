# Local shell setup shared across laptops.
# This file is symlinked into $ZSH_CUSTOM by bootstrap.sh.

# Rust and Cargo
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# nvm
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
