# macOS Keybindings Reference

Keybindings for AeroSpace window manager and common tools, designed to match the i3 Linux setup.

## AeroSpace (Window Manager)

AeroSpace uses **Alt (Option)** as the mod key, same as i3's `Mod1`.

### Launching Applications

| Keybinding | Action |
|------------|--------|
| `Alt + Enter` | Open terminal (iTerm2) |
| `Alt + d` | Open Raycast (app launcher) |
| `Alt + Shift + d` | Open Spotlight |

### Window Management

| Keybinding | Action |
|------------|--------|
| `Alt + Shift + q` | Close focused window |
| `Alt + f` | Toggle fullscreen |
| `Alt + Shift + Space` | Toggle floating/tiling |
| `Alt + Space` | Focus back and forth |
| `Alt + a` | Focus parent container |

### Focus Movement

| Keybinding | Action |
|------------|--------|
| `Alt + j` | Focus left |
| `Alt + k` | Focus down |
| `Alt + l` | Focus up |
| `Alt + ;` | Focus right |
| `Alt + ←/↓/↑/→` | Focus (arrow keys) |

### Move Windows

| Keybinding | Action |
|------------|--------|
| `Alt + Shift + j` | Move window left |
| `Alt + Shift + k` | Move window down |
| `Alt + Shift + l` | Move window up |
| `Alt + Shift + ;` | Move window right |
| `Alt + Shift + ←/↓/↑/→` | Move (arrow keys) |

### Layouts & Splits

| Keybinding | Action |
|------------|--------|
| `Alt + \` | Split horizontal |
| `Alt + -` | Split vertical |
| `Alt + e` | Toggle tiling layout |
| `Alt + s` | Toggle accordion (stacking) layout |

### Workspaces

| Keybinding | Action |
|------------|--------|
| `Alt + 1-9` | Switch to workspace 1-9 |
| `Alt + Shift + 1-9` | Move window to workspace 1-9 |
| `Alt + Tab` | Workspace back and forth |
| `Alt + Shift + m` | Move window to next monitor |

### Resize Mode

Press `Alt + r` to enter resize mode:

| Key | Action |
|-----|--------|
| `h` / `←` | Shrink width |
| `l` / `→` | Grow width |
| `k` / `↑` | Shrink height |
| `j` / `↓` | Grow height |
| `Enter` / `Escape` | Exit resize mode |

### Configuration

| Keybinding | Action |
|------------|--------|
| `Alt + Shift + c` | Reload AeroSpace config |
| `Alt + Shift + r` | Restart AeroSpace |

---

## iTerm2

### Tabs & Windows

| Keybinding | Action |
|------------|--------|
| `Cmd + t` | New tab |
| `Cmd + w` | Close tab |
| `Cmd + n` | New window |
| `Cmd + Shift + ]` | Next tab |
| `Cmd + Shift + [` | Previous tab |
| `Cmd + 1-9` | Switch to tab 1-9 |

### Panes (Splits)

| Keybinding | Action |
|------------|--------|
| `Cmd + d` | Split vertically |
| `Cmd + Shift + d` | Split horizontally |
| `Cmd + ]` | Next pane |
| `Cmd + [` | Previous pane |
| `Cmd + Alt + Arrow` | Navigate panes |
| `Cmd + Shift + Enter` | Maximize pane |

### Text & Search

| Keybinding | Action |
|------------|--------|
| `Cmd + f` | Find |
| `Cmd + g` | Find next |
| `Cmd + Shift + g` | Find previous |
| `Cmd + k` | Clear buffer |
| `Ctrl + l` | Clear screen |

### Scrolling

| Keybinding | Action |
|------------|--------|
| `Cmd + ↑/↓` | Scroll up/down |
| `Page Up/Down` | Scroll page |
| `Cmd + Home/End` | Scroll to top/bottom |

---

## Shell (Zsh)

### Navigation (with zoxide)

| Command | Action |
|---------|--------|
| `z <partial>` | Jump to frecent directory |
| `zi` | Interactive directory picker (fzf) |
| `..` | Go up one directory |
| `...` | Go up two directories |
| `....` | Go up three directories |

### Fuzzy Finding (fzf)

| Keybinding | Action |
|------------|--------|
| `Ctrl + r` | Fuzzy search command history |
| `Ctrl + t` | Fuzzy find files |
| `Alt + c` | Fuzzy cd into directory |

### Quick Commands

| Alias | Command |
|-------|---------|
| `ll` | `eza -la --icons --git` |
| `lt` | `eza --tree --level=2` |
| `lg` | `lazygit` |
| `lzd` | `lazydocker` |
| `ff` | `fastfetch` |
| `vim` / `vi` | `nvim` |

### Git Shortcuts

| Alias | Command |
|-------|---------|
| `gs` | `git status` |
| `ga` | `git add` |
| `gc` | `git commit` |
| `gp` | `git push` |
| `gpl` | `git pull` |
| `gl` | `git log --oneline -10` |
| `gd` | `git diff` |
| `gco` | `git checkout` |
| `gb` | `git branch` |

### macOS Specific

| Alias | Action |
|-------|--------|
| `ql <file>` | Quick Look preview |
| `pbc` | Copy to clipboard (`pbcopy`) |
| `pbp` | Paste from clipboard (`pbpaste`) |
| `flushdns` | Flush DNS cache |
| `showfiles` | Show hidden files in Finder |
| `hidefiles` | Hide hidden files in Finder |
| `localip` | Show local IP address |
| `publicip` | Show public IP address |

---

## tmux (Optional)

Default prefix is `Ctrl + b`:

| Keybinding | Action |
|------------|--------|
| `Prefix + c` | New window |
| `Prefix + n` | Next window |
| `Prefix + p` | Previous window |
| `Prefix + %` | Split horizontal |
| `Prefix + "` | Split vertical |
| `Prefix + Arrow` | Navigate panes |
| `Prefix + d` | Detach |
| `Prefix + [` | Scroll mode |

---

## Comparison: i3 (Linux) vs AeroSpace (macOS)

| Action | i3 (Linux) | AeroSpace (macOS) |
|--------|------------|-------------------|
| Mod key | `Alt` | `Alt` (Option) |
| Terminal | `Alt + Enter` | `Alt + Enter` |
| Close window | `Alt + Shift + q` | `Alt + Shift + q` |
| Fullscreen | `Alt + f` | `Alt + f` |
| Focus left | `Alt + j` | `Alt + j` |
| Move left | `Alt + Shift + j` | `Alt + Shift + j` |
| Workspace 1 | `Alt + 1` | `Alt + 1` |
| Move to ws 1 | `Alt + Shift + 1` | `Alt + Shift + 1` |
| Horizontal split | `Alt + h` | `Alt + \` |
| Vertical split | `Alt + v` | `Alt + -` |
| Reload config | `Alt + Shift + c` | `Alt + Shift + c` |
| Launcher | `Alt + d` (dmenu) | `Alt + d` (Raycast) |

---

## Quick Reference Card

```
╔══════════════════════════════════════════════════════════════════╗
║                    AeroSpace Quick Reference                     ║
╠══════════════════════════════════════════════════════════════════╣
║  Alt + Enter      Terminal        Alt + Shift + q   Close        ║
║  Alt + d          Launcher        Alt + f           Fullscreen   ║
║  Alt + j/k/l/;    Focus           Alt + Shift + ... Move         ║
║  Alt + 1-9        Workspace       Alt + Shift + 1-9 Send to WS   ║
║  Alt + r          Resize mode     Alt + Shift + c   Reload       ║
║  Alt + e          Toggle layout   Alt + s           Stacking     ║
║  Alt + \          Split H         Alt + -           Split V      ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## Configuration Files

| Config | Location |
|--------|----------|
| AeroSpace | `~/.config/aerospace/aerospace.toml` |
| Zsh customizations | `~/dotfiles/mac/.zshrc_dotfiles` |
| btop | `~/.config/btop/btop.conf` |
| Neovim | `~/.config/nvim/` |
| iTerm2 | Preferences → Profiles (GUI-based) |
