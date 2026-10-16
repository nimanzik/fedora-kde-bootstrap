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

## Sway and Waybar

If you also use a sway session with Waybar, install three extra packages. They
are not part of the KDE setup, so `bootstrap.sh` does not install them.

```bash
sudo dnf install -y mako network-manager-applet NetworkManager-openvpn-gnome
```

- `mako`: desktop notifications for sway, which has no notification daemon of
  its own. Start it from your sway config, or enable the `mako` systemd user
  service.
- `network-manager-applet`: the `nm-applet` network tray icon, for Waybar's
  tray module.
- `NetworkManager-openvpn-gnome`: the OpenVPN editor used by
  `nm-connection-editor`.

The sway and Waybar configuration itself is not managed by this repo.
