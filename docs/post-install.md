# Post-install checklist

Run these after `bootstrap.sh` finishes.

## Shell

- Restart the terminal.
- If you want zsh as the default shell, run the command printed by the script,
  for example:

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

If you also use a sway session with Waybar, you need to install some extra
packages. They are not part of the KDE setup, so `bootstrap.sh` does not
install them.

```bash
sudo dnf install -y mako network-manager-applet NetworkManager-openvpn-gnome \
  rofi qt6ct plasma-breeze breeze-icon-theme
```

- `mako`: desktop notifications for sway, which has no notification daemon of
  its own. Start it from your sway config, or enable the `mako` systemd user
  service.
- `network-manager-applet`: the `nm-applet` network tray icon, for Waybar's
  tray module.
- `NetworkManager-openvpn-gnome`: the OpenVPN editor used by
  `nm-connection-editor`.
- `rofi`: provides an application launcher and window switcher.
- `qt6ct`: lets you configure Qt 6 apps outside Plasma, including dark colors
  for apps like Okular and Dolphin.
- `plasma-breeze`: provides the Breeze widget style for Qt apps.
- `breeze-icon-theme`: provides Breeze icons for apps and file managers.

For Qt 6 dark themes in sway, set `QT_QPA_PLATFORMTHEME=qt6ct` in the
environment used to launch your sway session. If you start sway from zsh,
you can add the following line to `~/.zshenv`:

```bash
export QT_QPA_PLATFORMTHEME=qt6ct
```

Sessions started by a display manager may not read `~/.zshenv`. Avoid applying
the variable to Plasma sessions, where it can override KDE's theme integration.

Log out and back in, then open `qt6ct` and select the Breeze style and a dark
color scheme. Select Breeze icons in the icon theme settings. Installing the
packages alone does not enable a dark theme.

The sway and Waybar configuration itself is not managed by this repo.
