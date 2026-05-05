# macOS Dotfiles

This is the macOS version of my dotfiles, designed to replicate my Linux i3 workflow on a MacBook Pro (M4 Max).

## Quick Start

```bash
# Clone the repo (if not already)
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# Make install script executable
chmod +x install_mac.sh

# Run interactive installer
./install_mac.sh

# Or install everything at once
./install_mac.sh all
```

## What's Included

### Window Management
- **[AeroSpace](https://github.com/nikitabobko/AeroSpace)** - Tiling window manager for macOS (i3-like)
  - Same keybindings as i3 (Alt+Enter, Alt+1-9, etc.)
  - Gaps, workspaces, and layouts
  - No SIP disable required!

### Terminal
- **iTerm2** - Feature-rich terminal emulator
- **tmux** - Terminal multiplexer

### Terminal Power Tools
| Tool | Replaces | Description |
|------|----------|-------------|
| `eza` | `ls` | Modern ls with icons and git status |
| `bat` | `cat` | Syntax highlighting, line numbers |
| `fd` | `find` | Fast and user-friendly |
| `ripgrep` | `grep` | Blazingly fast search |
| `zoxide` | `cd` | Smarter directory jumping |
| `duf` | `df` | Pretty disk usage |
| `dust` | `du` | Intuitive disk usage |
| `btop` | `top` | Beautiful resource monitor |
| `lazygit` | `git` | Git TUI |
| `delta` | `diff` | Beautiful git diffs |
| `fzf` | - | Fuzzy finder (Ctrl+R history) |

### Development
- Neovim with config
- Git + GitHub CLI (`gh`) + GitLab CLI (`glab`)
- direnv, shellcheck, shfmt
- lazydocker for Docker TUI

## Directory Structure

```
dotfiles/
├── install.sh          # Linux installer
├── install_mac.sh      # macOS installer ← YOU ARE HERE
├── mac/
│   ├── Brewfile        # Homebrew packages
│   ├── .zshrc_dotfiles # Shell customizations
│   └── .config/
│       ├── aerospace/  # Window manager config
│       ├── btop/       # Resource monitor
│       ├── fastfetch/  # System info
│       ├── nvim/       # Neovim (symlinked from shared)
│       └── scripts/    # Helper scripts
└── .config/            # Linux configs (not used on mac)
```

## Installation Options

```bash
# Interactive menu
./install_mac.sh

# Install everything
./install_mac.sh all

# Install specific packages
./install_mac.sh aerospace zsh btop

# List available packages
./install_mac.sh --list

# Install apps interactively
./install_mac.sh --apps

# Install from Brewfile only
./install_mac.sh --brewfile
```

## Key Differences from Linux

| Linux | macOS Equivalent |
|-------|------------------|
| i3 | AeroSpace |
| polybar | SketchyBar (optional) |
| rofi/dmenu | Raycast or Spotlight |
| kitty | iTerm2 |
| apt | Homebrew |
| picom | Not needed (macOS has compositing) |
| dunst | macOS native notifications |
| feh | Not needed |

## AeroSpace Tips

AeroSpace works without disabling SIP (System Integrity Protection). Key things to know:

1. **Start AeroSpace**: Run `aerospace` or add to Login Items
2. **Config location**: `~/.config/aerospace/aerospace.toml`
3. **Reload config**: `Alt+Shift+c` or `aerospace reload-config`
4. **Keybindings**: See [KEYBINDINGS_MAC.md](KEYBINDINGS_MAC.md)

### Granting Permissions

On first run, macOS will ask for accessibility permissions:
1. System Settings → Privacy & Security → Accessibility
2. Enable AeroSpace
3. You may need to restart AeroSpace after granting permissions

## Raycast (Optional)

Raycast is like dmenu/rofi for macOS - a keyboard-driven launcher. The free tier includes:
- App launcher
- Clipboard history
- Window management
- Calculator
- File search

If you prefer native Spotlight, the AeroSpace config uses `Alt+Shift+d` for Spotlight and `Alt+d` for Raycast.

## Customization

### Adding aliases
Edit `mac/.zshrc_dotfiles` and re-source:
```bash
source ~/.zshrc
```

### Changing AeroSpace keybindings
Edit `mac/.config/aerospace/aerospace.toml` then:
```bash
aerospace reload-config
# or Alt+Shift+c
```

### Installing more apps
```bash
# Add to Brewfile, then:
brew bundle --file=mac/Brewfile

# Or install directly:
brew install <package>
brew install --cask <app>
```

## Troubleshooting

### AeroSpace not working
1. Check accessibility permissions in System Settings
2. Try restarting: `aerospace reload-config`
3. Check logs: `log show --predicate 'subsystem == "com.apple.processmanager"' --last 5m`

### Homebrew on Apple Silicon
The installer handles this, but if needed:
```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Permission denied errors
```bash
chmod +x install_mac.sh
chmod +x mac/.config/scripts/*.sh
```

## M4 Max Notes

The M4 Max has an excellent integrated GPU (40-core), so GPU-accelerated terminals like kitty or Alacritty would work great. However, iTerm2 is battle-tested and has more features.

Your chip also has:
- High-performance cores for compilation
- Efficiency cores for background tasks
- Unified memory (no separate GPU RAM)
- Native ARM64 - most Homebrew packages are native now

## See Also

- [KEYBINDINGS_MAC.md](KEYBINDINGS_MAC.md) - Full keybinding reference
- [README.md](README.md) - Linux version documentation
