# Personal aliases for Fedora KDE.
# Add your machine-independent aliases here.

# Prompt before any removal and over-write
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# Some more `ls` aliases
alias l1="ls -1F"

# vim-X11 on Fedora supports clipboard
alias vim="vimx"

# zshrc
alias zsh-config="vim ~/.zshrc"
alias zsh-reload="source ~/.zshrc"

# Misc
alias open="xdg-open"
alias symlink="ln -s"
alias make-exe="chmod 700"

# Agent stuff
alias skills-cli="npx skills@latest"
alias skills-list="skills-cli list --global"
alias skills-update="skills-cli update --global"
alias pi-update="pi update && pi update --extensions"

# List, mount and unmount external drives
alias drive-list="lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL,MODEL,TYPE"
alias drive-mount="udisksctl mount -b"
alias drive-unmount="udisksctl unmount -b"
