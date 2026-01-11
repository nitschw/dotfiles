# ⌨️ i3 Keybindings Cheat Sheet

> **Mod key:** `Alt` (Mod1)

## 🚀 Essential

| Keybinding | Action |
|------------|--------|
| `Mod+Return` | Open terminal (kitty) |
| `Mod+d` | **dmenu** - fast text-based launcher |
| `Mod+Shift+d` | **rofi** - modern launcher with icons |
| `Mod+Shift+q` | Kill focused window |
| `Mod+Shift+c` | Reload i3 config |
| `Mod+Shift+r` | Restart i3 in-place |
| `Mod+Shift+e` | Exit i3 (logout) |

### dmenu vs rofi
- **dmenu** (`Mod+d`): Lightweight, types command names directly. Fast for power users.
- **rofi** (`Mod+Shift+d`): Shows .desktop apps with icons. Better for GUI apps.

## 🧭 Navigation

| Keybinding | Action |
|------------|--------|
| `Mod+j` | Focus left |
| `Mod+k` | Focus down |
| `Mod+l` | Focus up |
| `Mod+;` | Focus right |
| `Mod+←/↓/↑/→` | Focus (arrow keys) |
| `Mod+a` | Focus parent container |
| `Mod+space` | Toggle focus tiling/floating |

## 🪟 Window Management

| Keybinding | Action |
|------------|--------|
| `Mod+Shift+j/k/l/;` | Move window (vim keys) |
| `Mod+Shift+←/↓/↑/→` | Move window (arrows) |
| `Mod+h` | Split horizontal |
| `Mod+v` | Split vertical |
| `Mod+f` | Toggle fullscreen |
| `Mod+Shift+space` | Toggle floating |

## 📐 Layout

| Keybinding | Action |
|------------|--------|
| `Mod+s` | Stacking layout |
| `Mod+w` | Tabbed layout |
| `Mod+e` | Toggle split |

## 🔢 Workspaces

| Keybinding | Action |
|------------|--------|
| `Mod+1-9,0` | Switch to workspace 1-10 |
| `Mod+Shift+1-9,0` | Move window to workspace 1-10 |

## 📏 Resize Mode

Press `Mod+r` to enter resize mode, then:

| Key | Action |
|-----|--------|
| `j` / `←` | Shrink width |
| `;` / `→` | Grow width |
| `k` / `↓` | Grow height |
| `l` / `↑` | Shrink height |
| `Enter` / `Escape` | Exit resize mode |

## 📸 Screenshots (maim)

| Keybinding | Action |
|------------|--------|
| `Print` | Full screen → file |
| `Mod+Print` | Active window → file |
| `Shift+Print` | Selection → file |
| `Ctrl+Print` | Full screen → clipboard |
| `Ctrl+Mod+Print` | Active window → clipboard |
| `Ctrl+Shift+Print` | Selection → clipboard |

## 🔊 Media Keys

| Keybinding | Action |
|------------|--------|
| `XF86AudioRaiseVolume` | Volume +10% |
| `XF86AudioLowerVolume` | Volume -10% |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioMicMute` | Toggle mic mute |
| `Mod+BrightnessUp` | Brightness +5% |
| `Mod+BrightnessDown` | Brightness -5% |

## 🎨 Theme: Catppuccin Mocha

| Element | Color |
|---------|-------|
| Focused border | Pink `#f5c2e7` |
| Inactive border | Mauve `#cba6f7` |
| Urgent | Peach `#fab387` |
| Background | Base `#1e1e2e` |

---

## � Shell Aliases

Configured in `.bash_aliases`. Conditional aliases only activate when the tool is installed.

### Modern Replacements

| Alias | Replaces | Tool |
|-------|----------|------|
| `ls`, `ll`, `la`, `lt` | `ls` | **eza** (with icons) |
| `cat` | `cat` | **bat** (syntax highlighting) |
| `df` | `df` | **duf** (visual disk usage) |
| `du` | `du` | **dust** (visual directory size) |
| `ps` | `ps` | **procs** (modern process viewer) |
| `rm` | `rm` | **trash-put** (safe delete) |
| `vim`, `vi` | `vim` | **nvim** (neovim) |
| `diff` | `diff` | **delta** (beautiful diffs) |
| `fd` | `find` | **fd** (fast find) |

### Quick Launchers

| Alias | Command | Description |
|-------|---------|-------------|
| `lg` | lazygit | TUI for git |
| `lzd` | lazydocker | TUI for docker |
| `ff` | fastfetch | System info |
| `r` | ranger | File manager |
| `n` | nnn | Lightweight file manager |
| `help` | tldr | Simplified man pages |
| `screenshot` | flameshot gui | Take screenshot |
| `gif` | peek | Record GIF |
| `record` | obs | Screen recording |

### Disk Tools

| Alias | Command | Description |
|-------|---------|-------------|
| `diskuse` | ncdu | Interactive disk usage |
| `diskgui` | baobab | GUI disk analyzer |
| `trash` | trash-list | Show trashed files |
| `restore` | trash-restore | Restore from trash |

### Network

| Alias | Command | Description |
|-------|---------|-------------|
| `speedtest` | speedtest-cli | Test internet speed |
| `netmon` | nload | Network bandwidth monitor |
| `netstat` | sudo iftop | Network connections |
| `netprocs` | sudo nethogs | Per-process bandwidth |

### Git / Dev

| Alias | Command | Description |
|-------|---------|-------------|
| `ghpr` | gh pr create | Create GitHub PR |
| `ghprs` | gh pr list | List GitHub PRs |
| `glmr` | glab mr create | Create GitLab MR |
| `glmrs` | glab mr list | List GitLab MRs |
| `glci` | glab ci status | GitLab CI status |
| `sc` | shellcheck | Lint shell scripts |
| `dotfiles` | cd ~/dotfiles | Jump to dotfiles |

### Shell Enhancements

| Tool | Effect |
|------|--------|
| **zoxide** | Smart `cd` - learns your habits, use `z` |
| **fzf** | `Ctrl+R` for fuzzy command history |
| **direnv** | Auto-load `.envrc` files |

---

## 🛠️ Autostart Applications

These run automatically on login:

- **polybar** - Status bar
- **picom** - Compositor (transparency, blur, shadows)
- **dunst** - Notifications
- **nitrogen** - Wallpaper
- **nm-applet** - Network manager tray
- **copyq** - Clipboard manager
- **pasystray** - PulseAudio tray
- **udiskie** - USB automount
- **autorandr** - Multi-monitor profiles

---

## 📁 Config Locations

| App | Path |
|-----|------|
| i3 | `~/.config/i3/config` |
| Polybar | `~/.config/polybar/` |
| Picom | `~/.config/picom/picom.conf` |
| Kitty | `~/.config/kitty/kitty.conf` |
| Dunst | `~/.config/dunst/dunstrc` |
| Autorandr | `~/.config/autorandr/` |
| Bash aliases | `~/.bash_aliases` |
| Dotfiles | `~/dotfiles/` |

---

## 📦 Install Commands

```bash
./install.sh                  # Interactive menu
./install.sh --configs all    # Install all configs
./install.sh --apps all       # Install all apps
./install.sh --aliases        # Install bash aliases
./install.sh --everything     # Install everything
./install.sh --apps-list      # Show apps with install status
./install.sh --clean          # Remove old backups
```

---

*Generated from dotfiles repo*
