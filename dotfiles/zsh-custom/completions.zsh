# Shell completions for tools installed by bootstrap.sh.

if command -v uv >/dev/null 2>&1; then
    eval "$(uv generate-shell-completion zsh)"
fi

if command -v uvx >/dev/null 2>&1; then
    eval "$(uvx --generate-shell-completion zsh)"
fi

if command -v ruff >/dev/null 2>&1; then
    eval "$(ruff generate-shell-completion zsh)"
fi

if command -v ty >/dev/null 2>&1; then
    eval "$(ty generate-shell-completion zsh)"
fi
