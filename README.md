# My Niri Config

A [niri](https://github.com/YaLTeR/niri) (scrollable-tiling Wayland compositor) setup with
[Noctalia](https://docs.noctalia.dev) as the desktop shell: bar, launcher, notifications,
control center, OSD and lock screen. Built and tested on **Arch / CachyOS**.

```
niri/config.kdl          # the niri config (keybinds, layout, startup apps, window rules)
noctalia/settings.json   # Noctalia shell settings (bar layout, widgets, theme behaviour)
noctalia/colors.json     # Noctalia colour palette
noctalia/plugins.json    # Noctalia plugin sources
install.sh               # copies everything into ~/.config with backups
```

Only `niri/config.kdl` is required. The `noctalia/` folder reproduces my exact look; without it
you get Noctalia's defaults.

---

## 1. Requirements

A Wayland-capable machine with working graphics drivers (Mesa for AMD/Intel, or the NVIDIA
proprietary driver with DRM modesetting enabled) and a login method (a display manager such as
SDDM/GDM/greetd, or a TTY).

### Packages (Arch / CachyOS)

Official repos:

```bash
sudo pacman -S --needed \
  niri xwayland-satellite \
  hyprpolkitagent \
  network-manager-applet blueman \
  wl-clipboard cliphist \
  kitty \
  playerctl wireplumber \
  xdg-desktop-portal-gnome xdg-desktop-portal-gtk \
  git
```

Optional: `orca` (screen reader, used by the `Super+Alt+S` bind).

Noctalia shell and its quickshell fork (`qs`):

```bash
# Check your repos first:
pacman -Ss noctalia
# If they are in the official/CachyOS repos:
sudo pacman -S noctalia-shell noctalia-qs
# Otherwise from the AUR:
yay -S noctalia-shell noctalia-qs      # or paru -S ...
```

> **Important:** this config calls `qs -c noctalia-shell ...`. The `qs` binary must come from
> **`noctalia-qs`** (Noctalia's quickshell fork). Plain `quickshell` may not work. On my system
> `noctalia-shell` installs its QML to `/etc/xdg/quickshell/noctalia-shell/`, which is what
> `-c noctalia-shell` resolves to.

| Package | Why the config needs it |
|---|---|
| `niri` | the compositor |
| `noctalia-shell`, `noctalia-qs` | the shell, started with `qs -c noctalia-shell` and controlled over IPC by most keybinds |
| `xwayland-satellite` | lets X11 apps (Steam, many games, some Electron apps) run under niri |
| `hyprpolkitagent` | polkit authentication popups (any privilege prompt) |
| `network-manager-applet` | `nm-applet` tray icon |
| `blueman` | `blueman-applet` Bluetooth tray icon |
| `wl-clipboard`, `cliphist` | clipboard history (`wl-paste --watch cliphist store`) |
| `kitty` | terminal bound to `Mod+T` |
| `playerctl` | media keys |
| `wireplumber` | provides `wpctl`, used for mic mute |
| `orca` (optional) | screen reader on `Super+Alt+S` |

### Other distros

- **Fedora:** niri is in the official repos (`sudo dnf install niri`). Noctalia is not packaged
  there, so follow the [Noctalia install docs](https://docs.noctalia.dev).
- **NixOS / others:** see the [niri install wiki](https://github.com/YaLTeR/niri/wiki/Getting-Started)
  and the Noctalia docs. The config itself is distro-independent; only the package names differ.

---

## 2. Install

```bash
git clone https://github.com/YatharthSharma0/My-Niri-Config.git
cd My-Niri-Config
./install.sh                 # niri + noctalia
# or: ./install.sh --no-noctalia   # niri config only
```

The script:

1. backs up any existing file it would replace as `<file>.bak-<timestamp>`,
2. copies `niri/config.kdl` to `~/.config/niri/`,
3. copies the Noctalia files to `~/.config/noctalia/` (rewriting the `__HOME__` placeholder in
   `settings.json` to your real home directory),
4. creates `~/Pictures/Screenshots` and `~/Pictures/Wallpapers`.

Prefer to do it by hand? Just copy `niri/config.kdl` to `~/.config/niri/config.kdl`.

---

## 3. Adapt it to your hardware (do this!)

### Monitors

`config.kdl` has two `output` blocks that describe **my** screens:

```kdl
output "eDP-2"    { position x=0 y=0; variable-refresh-rate }
output "HDMI-A-1" { position x=-1920 y=0; mode "1920x1080@220.002" }
```

Find your own output names and modes:

```bash
niri msg outputs
```

Then edit or delete those blocks. niri ignores blocks for outputs that don't exist, so leaving
them will not break anything, but your layout won't be what you expect. Remove
`variable-refresh-rate` if your panel doesn't support it, and never force a `mode` your display
doesn't advertise.

### Keyboard / touchpad

The `input` block is mostly defaults (tap-to-click and natural scroll on the touchpad, NumLock
on at startup). For a non-US layout, set it inside `xkb { }`, for example
`layout "de"` or `layout "us,ru"` with `options "grp:alt_shift_toggle"`.

### Wallpapers and avatar

Noctalia reads wallpapers from `~/Pictures/Wallpapers` (random change mode) and your avatar from
`~/.face`. Put images there or change them in Noctalia's settings (`Mod+Ctrl+Comma`).

### Validate

```bash
niri validate
```

---

## 4. Start it

- From a display manager: pick **niri** in the session list (the `niri` package installs the
  session file).
- From a TTY: run `niri-session`.

On startup the config launches Noctalia, `xwayland-satellite`, the polkit agent, the network and
Bluetooth applets, and the clipboard history watchers.

---

## 5. Keybindings

`Mod` is the Super (Windows) key when running on real hardware (or Alt when niri runs nested
inside another window). Press **`Mod+Shift+/`** in niri for the built-in cheat-sheet.

### Apps and shell

| Keys | Action |
|---|---|
| `Mod+T` | kitty terminal |
| `Mod+D` / `Mod+Space` | Noctalia launcher |
| `Mod+S` | Noctalia control center |
| `Mod+Ctrl+,` | Noctalia settings |
| `Super+Alt+L` | lock screen |
| `Super+Alt+S` | toggle Orca screen reader |
| `Mod+O` | overview |
| `Mod+Q` | close window |
| `Mod+Shift+E` / `Ctrl+Alt+Del` | quit niri |
| `Mod+Shift+P` | turn monitors off |

Volume, brightness and media keys work too (routed through Noctalia so its on-screen display
appears), including while the screen is locked.

### Focus and movement

| Keys | Action |
|---|---|
| `Mod+←/↓/↑/→` or `Mod+H/J/K/L` | focus column left / window down / window up / column right |
| `Mod+Ctrl+` the same keys | move the column or window |
| `Mod+Home` / `Mod+End` | first / last column (add `Ctrl` to move the column there) |
| `Mod+Shift+` arrows or `HJKL` | focus another monitor (add `Ctrl` to send the column there) |
| `Mod+U` / `Mod+I` or `Mod+PageDown/PageUp` | workspace down / up (add `Ctrl` to move the column) |
| `Mod+Shift+U` / `Mod+Shift+I` | move the whole workspace down / up |
| `Mod+1…9` | go to workspace N (`Mod+Ctrl+1…9` moves the column there) |
| `Mod+Wheel` | scroll workspaces; `Mod+Shift+Wheel` scrolls columns |

### Layout

| Keys | Action |
|---|---|
| `Mod+R` / `Mod+Shift+R` | cycle preset column widths (1/3, 1/2, 2/3), forward / back |
| `Mod+Ctrl+Shift+R` / `Mod+Ctrl+R` | cycle preset window heights / reset height |
| `Mod+F` | maximize column |
| `Mod+Shift+F` | fullscreen |
| `Mod+M` | maximize window to edges |
| `Mod+Ctrl+F` | expand column to available width |
| `Mod+C` / `Mod+Ctrl+C` | center column / center all visible columns |
| `Mod+-` / `Mod+=` | column width −10% / +10% |
| `Mod+Shift+-` / `Mod+Shift+=` | window height −10% / +10% |
| `Mod+[` / `Mod+]` | consume or expel window into the left / right column |
| `Mod+,` / `Mod+.` | consume window into column / expel from column |
| `Mod+W` | toggle tabbed column |
| `Mod+V` / `Mod+Shift+V` | toggle floating / switch focus between floating and tiling |

### Screenshots

| Keys | Action |
|---|---|
| `Print` | interactive region screenshot |
| `Ctrl+Print` | whole screen |
| `Alt+Print` | focused window |

Files are saved to `~/Pictures/Screenshots/`.

---

## 6. Customising

- **Colours, bar, widgets:** use Noctalia's settings UI (`Mod+Ctrl+,`). It rewrites
  `~/.config/noctalia/settings.json`.
- **Gaps, focus ring, shadow:** the `layout { }` block in `config.kdl`.
- **Rounded corners:** the first `window-rule` (`geometry-corner-radius 20`).
- **Window rules:** add `window-rule { match app-id="..." ... }` blocks. Find an app-id with
  `niri msg windows`.
- niri reloads `config.kdl` automatically when you save it, so there is no need to log out.

---

## 7. Troubleshooting

| Symptom | Fix |
|---|---|
| Black screen, no bar | Noctalia failed to start. Run `qs -c noctalia-shell` in a terminal (`Mod+T` still works) and read the error. Usually `noctalia-shell` / `noctalia-qs` is missing, or plain `quickshell` is providing `qs`. |
| `Mod+D`, volume or brightness keys do nothing | Noctalia isn't running, so the `qs ... ipc call` commands have no target. |
| Config silently ignored / error toast | Run `niri validate`. |
| Wrong monitor layout or resolution | Edit the `output` blocks (section 3). |
| X11 apps won't open | Install `xwayland-satellite`; check it is running with `pgrep xwayland-satellite`. |
| No authentication popups | Install `hyprpolkitagent`, or swap in another polkit agent and update the `spawn-at-startup` line. |
| Screenshots not saved | Make sure `~/Pictures/Screenshots` exists (the install script creates it). |
| Missing-binary errors in the journal | Install the package from the table above, or delete the matching `spawn-at-startup` / bind line. |

View logs with `journalctl --user -b | grep -i niri`.

---

## 8. Notes on the config

- `debug { honor-xdg-activation-with-invalid-serial }` is required for Noctalia notification
  actions to focus windows. It also lets misbehaving apps steal focus; remove it if that bothers
  you.
- The lock, volume, brightness and media binds use `allow-when-locked=true`, so they work on
  the lock screen. `Super+Alt+S` (Orca) does too, for accessibility.
- Closing the laptop lid locks and suspends through Noctalia (`switch-events { lid-close }`).
- `cliphist` keeps clipboard history, including anything you copy such as passwords, in
  `~/.cache/cliphist`. Clear it with `cliphist wipe`.

## Credits

[niri](https://github.com/YaLTeR/niri) by YaLTeR and contributors, which this config is based on.
[Noctalia](https://docs.noctalia.dev) integration follows the official niri compositor guide.
