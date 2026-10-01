# Post-install checklist

Run these after `bootstrap.sh` finishes.

## Shell

- Restart the terminal.
- If you want zsh as the default shell, run the command printed by the script, for example:

  ```bash
  chsh -s /usr/bin/zsh
  ```

- Log out and back in after changing the default shell.

## Accounts and apps

- Log into Chromium sync if needed.
- Log into Discord.
- Log into Mattermost.
- Link Signal Desktop.
- Log into Telegram.
- Open KeePassXC and unlock your database.
- Configure Remmina connections if needed.
- Configure DBeaver connections if needed.

## Developer setup

- Configure Git identity:

  ```bash
  git config --global user.name "Your Name"
  git config --global user.email "you@example.com"
  ```

- Configure SSH keys.
- Configure GitLab CLI:

  ```bash
  glab auth login
  ```

- Confirm Node.js version:

  ```bash
  node --version
  npm --version
  ```

- Confirm Rust tools:

  ```bash
  cargo --version
  broot --version
  dua --version
  ```

## KDE and hardware

- Check display scaling.
- Check touchpad settings.
- Check keyboard layout and shortcuts.
- Check battery and power settings.
- Reboot once when done.
