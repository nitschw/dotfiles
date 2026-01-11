# 🏠 Dotfiles

Personal dotfiles for my i3 Linux setup with Catppuccin Mocha theme.

![i3wm](https://img.shields.io/badge/WM-i3-blue)
![Catppuccin](https://img.shields.io/badge/Theme-Catppuccin%20Mocha-pink)
![Polybar](https://img.shields.io/badge/Bar-Polybar-green)

## 📦 What's Included

| Component | Description |
|-----------|-------------|
| **i3** | Tiling window manager config |
| **Polybar** | Status bar with custom modules |
| **Picom** | Compositor (blur, transparency, shadows) |
| **Kitty** | GPU-accelerated terminal |
| **Dunst** | Notification daemon |
| **Fastfetch** | System info display (faster neofetch) |
| **btop** | Resource monitor |
| **Nitrogen** | Wallpaper manager |
| **Autorandr** | Multi-monitor profiles |

## 🚀 Installation

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

The install script will:
1. Check for missing dependencies (prompts to install)
2. Backup existing configs to `~/.config-backup-TIMESTAMP/`
3. Create symlinks to this repo
4. Set up bash aliases

### Options

```bash
# Full install with dependency check
./install.sh

# Just install dependencies
./install.sh --install-deps
```

## 📋 Dependencies

The install script will prompt to install these automatically, or install manually:

### Core (APT)

```bash
# Window manager & compositor
sudo apt install i3 picom

# Bar & launchers  
sudo apt install polybar rofi dmenu

# Terminal & notifications
sudo apt install kitty dunst libnotify-bin

# Screenshots & clipboard
sudo apt install maim xclip xdotool

# System utilities
sudo apt install brightnessctl autorandr nitrogen feh

# Tray apps
sudo apt install network-manager-gnome pasystray copyq udiskie

# System monitors
sudo apt install btop htop
# Note: fastfetch is installed via PPA or GitHub releases

# Fonts
sudo apt install fonts-jetbrains-mono fonts-font-awesome

# Misc
sudo apt install dex xss-lock i3lock xinput
```

### One-liner

```bash
sudo apt install i3 picom polybar rofi dmenu kitty dunst libnotify-bin \
  maim xclip xdotool brightnessctl autorandr nitrogen feh \
  network-manager-gnome pasystray copyq udiskie btop htop \
  fonts-jetbrains-mono fonts-font-awesome dex xss-lock i3lock xinput
# Install fastfetch separately: https://github.com/fastfetch-cli/fastfetch
```

## ⌨️ Keybindings

See [KEYBINDINGS.md](KEYBINDINGS.md) for the full cheat sheet.

### Quick Reference

| Key | Action |
|-----|--------|
| `Alt+Return` | Terminal |
| `Alt+d` | dmenu |
| `Alt+Shift+d` | rofi |
| `Alt+Shift+q` | Kill window |
| `Alt+1-0` | Workspaces |
| `Alt+Shift+r` | Reload i3 |

## 🎨 Theme

Using **Catppuccin Mocha** across all components:

- Background: `#1e1e2e`
- Foreground: `#cdd6f4`
- Pink accent: `#f5c2e7`
- Mauve accent: `#cba6f7`

## 📁 Structure

```
dotfiles/
├── .config/
│   ├── i3/           # Window manager
│   ├── polybar/      # Status bar
│   ├── picom/        # Compositor
│   ├── kitty/        # Terminal
│   ├── dunst/        # Notifications
│   ├── btop/         # System monitor
│   ├── nvim/         # Neovim
│   ├── fastfetch/    # System info
│   ├── nitrogen/     # Wallpaper
│   ├── autorandr/    # Monitor profiles
│   └── scripts/      # Custom scripts
├── install.sh        # Installation script
├── KEYBINDINGS.md    # Keybindings cheat sheet
└── README.md         # This file
```

## 🔧 Post-Install

1. **Reload i3:** `Alt+Shift+r`
2. **Set wallpaper:** Add images to `~/dotfiles/background_photos/` or run `nitrogen`
3. **Check monitors:** Run `autorandr --change`

## 📝 Notes

- Mod key is `Alt` (Mod1)
- Touchpad is disabled by default (for external mouse users)
- Screen blanking/DPMS is disabled

---

*Feel free to fork and customize!*
