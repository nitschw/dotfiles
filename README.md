# 🏠 Dotfiles

Personal dotfiles for my i3 Linux setup with Catppuccin Mocha theme.

![i3wm](https://img.shields.io/badge/WM-i3-blue)
![Catppuccin](https://img.shields.io/badge/Theme-Catppuccin%20Mocha-pink)
![Polybar](https://img.shields.io/badge/Bar-Polybar-green)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-orange)

## 📦 What's Included

### Configs

| Component | Description |
|-----------|-------------|
| **i3** | Tiling window manager config |
| **Polybar** | Status bar with custom modules |
| **Picom** | Compositor (blur, transparency, shadows) |
| **Kitty** | GPU-accelerated terminal |
| **Dunst** | Notification daemon |
| **Fastfetch** | System info display |
| **btop** | Resource monitor |
| **Autorandr** | Multi-monitor profiles |
| **Bash aliases** | 50+ productivity aliases |

### 80+ Installable Apps

Run `./install.sh --apps-list` to see all available apps with install status.

## 🚀 Quick Start

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

## 📋 Install Commands

```bash
./install.sh                  # Interactive menu
./install.sh --configs all    # Install all config symlinks
./install.sh --apps all       # Install all apps
./install.sh --aliases        # Install bash aliases only
./install.sh --everything     # Install everything
./install.sh --apps-list      # Show apps with install status
./install.sh --apps-menu      # Interactive app selector
./install.sh --clean          # Remove old backups (keeps last 5)
```

---

## 🐚 Complete Alias Reference

All aliases are defined in `.bash_aliases`. Conditional aliases only activate when the tool is installed.

### 📂 Navigation

| Alias | Expands To | Description |
|-------|------------|-------------|
| `..` | `cd ..` | Go up one directory |
| `...` | `cd ../..` | Go up two directories |
| `....` | `cd ../../..` | Go up three directories |
| `dotfiles` | `cd ~/dotfiles` | Jump to dotfiles repo |

### 📁 File Listing (eza)

When **eza** is installed, these replace the default `ls`:

| Alias | Command | Description |
|-------|---------|-------------|
| `ls` | `eza --color=auto --icons` | List with icons |
| `ll` | `eza -la --icons` | Long list with hidden files |
| `la` | `eza -a --icons` | List all including hidden |
| `lt` | `eza --tree --level=2` | Tree view (2 levels deep) |

**Usage tips:**
```bash
lt                    # Quick tree view
ll *.py               # Long list Python files
eza --tree --level=4  # Deeper tree view
eza -la --git         # Show git status for files
```

### 📄 File Viewing (bat)

When **bat** is installed:

| Alias | Command | Description |
|-------|---------|-------------|
| `cat` | `batcat --paging=never` | Cat with syntax highlighting |
| `bat` | `batcat` | Full bat with paging |

**Usage tips:**
```bash
cat script.py         # Syntax-highlighted output
bat --language=json   # Force language detection
bat -A file.txt       # Show invisible characters
bat file1 file2       # View multiple files
```

### 💾 Disk Usage

| Alias | Tool | Description |
|-------|------|-------------|
| `df` | **duf** | Visual disk space (hides system partitions) |
| `du` | **dust** | Visual directory sizes |
| `diskuse` | **ncdu** | Interactive disk usage browser |
| `diskgui` | **baobab** | GUI disk analyzer |

**Usage tips:**
```bash
df                    # Quick disk overview
dust                  # Current directory sizes
dust -d 3 ~/          # Home directory, 3 levels deep
diskuse /var          # Interactive explore /var
ncdu --exclude .git   # Exclude git directories
```

### 🔍 Finding Files (fd)

When **fd** is installed:

| Alias | Command | Description |
|-------|---------|-------------|
| `fd` | `fdfind` | Fast find alternative |

**Usage tips:**
```bash
fd pattern            # Find files matching pattern
fd -e py              # Find all Python files
fd -e py -x wc -l     # Count lines in all Python files
fd -H .env            # Include hidden files
fd -t d node_modules  # Find only directories
fd . -e jpg -e png    # Find images
```

### 🔄 Process Management (procs)

When **procs** is installed:

| Alias | Command | Description |
|-------|---------|-------------|
| `ps` | `procs` | Modern process viewer |

**Usage tips:**
```bash
ps                    # All processes
procs --tree          # Process tree
procs python          # Filter by name
procs --sortd cpu     # Sort by CPU descending
procs --watch 1       # Update every second
```

### 🗑️ Safe Delete (trash-cli)

When **trash-cli** is installed:

| Alias | Command | Description |
|-------|---------|-------------|
| `rm` | `trash-put` | Move to trash instead of delete |
| `trash` | `trash-list` | Show trashed files |
| `restore` | `trash-restore` | Restore from trash |

**Usage tips:**
```bash
rm file.txt           # Safely move to trash
trash                 # List all trashed files
restore               # Interactive restore
trash-empty           # Empty trash permanently
trash-empty 30        # Empty items older than 30 days
```

### 🚀 Quick Launchers

| Alias | Tool | Description |
|-------|------|-------------|
| `lg` | **lazygit** | TUI for git (amazing!) |
| `lzd` | **lazydocker** | TUI for docker |
| `ff` | **fastfetch** | System info |
| `r` | **ranger** | Terminal file manager |
| `n` | **nnn** | Lightweight file manager |
| `icat` | **kitty icat** | Display images in terminal |
| `help` | **tldr** | Simplified man pages |

**Usage tips:**
```bash
lg                    # Open lazygit in current repo
lzd                   # Manage docker containers
ff                    # Quick system info
help tar              # Quick examples for tar
help git-rebase       # Git commands too
icat image.png        # View image in terminal
n -de                 # nnn with detail mode
```

### 📸 Screenshots & Recording

| Alias | Tool | Description |
|-------|------|-------------|
| `screenshot` | **flameshot** | Screenshot with annotations |
| `gif` | **peek** | Record GIF |
| `record` | **obs** | Screen recording/streaming |

**Usage tips:**
```bash
screenshot            # Opens flameshot GUI
flameshot full -p ~/  # Full screen to home dir
flameshot screen -c   # Current screen to clipboard
gif                   # Record area as GIF
```

### 🌐 Network Tools

| Alias | Tool | Description |
|-------|------|-------------|
| `speedtest` | **speedtest-cli** | Internet speed test |
| `netmon` | **nload** | Bandwidth monitor |
| `netstat` | **iftop** | Network connections (sudo) |
| `netprocs` | **nethogs** | Per-process bandwidth (sudo) |

**Usage tips:**
```bash
speedtest             # Quick speed test
speedtest --simple    # Just the numbers
netmon eth0           # Monitor specific interface
netprocs              # See which apps use bandwidth
```

### 🔧 Git Shortcuts

| Alias | Command | Description |
|-------|---------|-------------|
| `gs` | `git status` | Status |
| `ga` | `git add` | Stage files |
| `gc` | `git commit` | Commit |
| `gp` | `git push` | Push |
| `gl` | `git log --oneline -10` | Recent commits |
| `gd` | `git diff` | Show diff |

### 🐙 GitHub/GitLab CLI

| Alias | Tool | Description |
|-------|------|-------------|
| `ghpr` | `gh pr create` | Create GitHub PR |
| `ghprs` | `gh pr list` | List GitHub PRs |
| `glmr` | `glab mr create` | Create GitLab MR |
| `glmrs` | `glab mr list` | List GitLab MRs |
| `glci` | `glab ci status` | GitLab CI status |

**Usage tips:**
```bash
ghpr                  # Interactive PR creation
ghpr --web            # Open PR in browser
ghprs --state=all     # Show all PRs
gh pr checkout 123    # Checkout PR locally
glab ci view          # View CI pipeline
```

### ✏️ Quick Edits

| Alias | Command | Description |
|-------|---------|-------------|
| `aliases` | Edit & reload `.bash_aliases` | Quick alias editing |
| `bashrc` | Edit & reload `.bashrc` | Quick bashrc editing |
| `i3config` | Edit i3 config | Quick i3 editing |
| `i3reload` | `i3-msg reload` | Reload i3 config |
| `i3restart` | `i3-msg restart` | Restart i3 |

### 🖼️ Wallpaper

```bash
update_bg             # List available wallpapers
update_bg photo.jpg   # Set wallpaper (from ~/.config/backgrounds/)
```

### 🔌 Shell Enhancements

#### zoxide - Smart cd

Learns your habits and lets you jump anywhere:

```bash
z dot                 # Jump to ~/dotfiles
z proj                # Jump to ~/projects
z src comp            # Fuzzy match to src/components
zi                    # Interactive selection with fzf
zoxide query -l       # List all tracked directories
zoxide add ~/mydir    # Manually add directory
```

#### fzf - Fuzzy Finder

| Keybinding | Action |
|------------|--------|
| `Ctrl+R` | Fuzzy search command history |
| `Ctrl+T` | Fuzzy find files |
| `Alt+C` | Fuzzy cd into directories |

**Usage tips:**
```bash
# Pipe anything to fzf
cat file | fzf                    # Fuzzy select line
ls | fzf                          # Fuzzy select file
git branch | fzf                  # Fuzzy select branch

# Preview files
fzf --preview 'bat --color=always {}'

# Kill process interactively
kill -9 $(ps aux | fzf | awk '{print $2}')
```

#### direnv - Auto-load .envrc

Automatically loads environment variables when entering directories:

```bash
# Create .envrc in project directory
echo 'export API_KEY=secret' > .envrc
direnv allow                      # Trust this directory
cd ..                             # Variables unloaded
cd project                        # Variables auto-loaded!
```

### 🛡️ Safety Nets

These prompt before overwriting:

| Alias | Command |
|-------|---------|
| `cp` | `cp -i` |
| `mv` | `mv -i` |

### 🎨 Misc

| Alias | Description |
|-------|-------------|
| `ssh` | Sets TERM for proper colors on remote |
| `nomachine` | Launch NoMachine client |
| `keybinds` | Show i3 keybindings |
| `diff` | **delta** for beautiful diffs |
| `sc` | **shellcheck** for linting scripts |

---

## ⌨️ Keybindings

> **Mod key:** `Alt`

| Key | Action |
|-----|--------|
| `Alt+Return` | Terminal (kitty) |
| `Alt+d` | dmenu |
| `Alt+Shift+d` | rofi |
| `Alt+Shift+q` | Kill window |
| `Alt+1-0` | Workspaces 1-10 |
| `Alt+Shift+r` | Reload i3 |
| `Alt+f` | Fullscreen |
| `Alt+r` | Resize mode |

Full keybindings: [KEYBINDINGS.md](KEYBINDINGS.md)

## 🎨 Theme

Using **Catppuccin Mocha** across all components:

| Element | Color |
|---------|-------|
| Background | `#1e1e2e` |
| Foreground | `#cdd6f4` |
| Pink accent | `#f5c2e7` |
| Mauve accent | `#cba6f7` |

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
│   ├── fastfetch/    # System info
│   ├── autorandr/    # Monitor profiles
│   ├── backgrounds/  # Wallpapers
│   └── scripts/      # Custom scripts
├── .bash_aliases     # Shell aliases
├── install.sh        # Installation script
├── KEYBINDINGS.md    # Keybindings cheat sheet
└── README.md         # This file
```

## 🔧 Post-Install

1. **Reload bash:** `source ~/.bashrc` (or open new terminal)
2. **Reload i3:** `Alt+Shift+r`
3. **Set wallpaper:** `update_bg image.jpg`
4. **Clear command cache:** `hash -r` (if commands show "not found")

## 🛠️ Special Installers

These tools are installed from GitHub for latest versions:

| Tool | Why | Install |
|------|-----|---------|
| **fzf** | apt version (0.29) too old for zoxide | `./install.sh --apps fzf` |
| **eza** | Not in apt | `./install.sh --apps eza` |
| **lazygit** | Not in apt | `./install.sh --apps lazygit` |
| **lazydocker** | Not in apt | `./install.sh --apps lazydocker` |
| **zoxide** | Not in apt | `./install.sh --apps zoxide` |
| **dust** | Not in apt | `./install.sh --apps dust` |
| **delta** | Not in apt | `./install.sh --apps delta` |
| **gh** | Needs official repo | `./install.sh --apps gh` |

## 📝 Troubleshooting

### Command not found after install

```bash
hash -r                # Clear shell command cache
source ~/.bashrc       # Reload shell config
```

### Aliases not working

```bash
source ~/.bash_aliases # Reload aliases
```

### fzf path error

If you see `/usr/bin/fzf: No such file or directory`:
```bash
hash -r                # Shell cached old path
```

## 📝 Notes

- Mod key is `Alt` (Mod1)
- `~/.local/bin` is added to PATH automatically
- Backups are created at `~/.config-backup-TIMESTAMP/`
- Run `./install.sh --clean` to remove old backups
