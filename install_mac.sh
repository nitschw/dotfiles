#!/bin/zsh
#
# macOS Dotfiles Installation Script
# Creates symlinks from ~/.config to this repo (mac/ subdirectory)
#
# Usage:
#   ./install_mac.sh              # Interactive menu
#   ./install_mac.sh all          # Install everything
#   ./install_mac.sh aerospace    # Install specific packages
#   ./install_mac.sh --list       # List available packages
#   ./install_mac.sh --apps       # Interactive app picker
#   ./install_mac.sh --brewfile   # Install from Brewfile only
#

set -e

DOTFILES_DIR="${0:A:h}"
MAC_DIR="$DOTFILES_DIR/mac"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR=""
BACKUP_CREATED=false

# Generate unique backup dir
generate_backup_dir() {
    sleep 1
    BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ═══════════════════════════════════════════════════════════════════
# Package Definitions - macOS specific
# Format: "name|description|brew_packages (space separated)|config_dir"
# ═══════════════════════════════════════════════════════════════════

PACKAGES=(
    "aerospace|Tiling window manager (i3-like)|nikitabobko/tap/aerospace|aerospace"
    "iterm2|Terminal emulator + shell integration|--cask iterm2|iterm2"
    "raycast|Launcher with custom scripts|--cask raycast|raycast"
    "sketchybar|Custom macOS menu bar|felixkratz/formulae/sketchybar|sketchybar"
    "borders|Window borders for macOS|felixkratz/formulae/borders|borders"
    "skhd|Hotkey daemon|koekeishiya/formulae/skhd|skhd"
    "btop|Resource monitor|btop|btop"
    "fastfetch|System info display|fastfetch|fastfetch"
    "nvim|Neovim config|neovim|nvim"
    "cli-tools|Modern CLI tools (eza, bat, duf, etc)|eza bat duf dust procs fd ripgrep fzf|"
    "vnc|VNC Viewer + connection manager|--cask vnc-viewer|vnc"
    "shottr|Screenshot tool with annotations|--cask shottr|"
    "fonts|Nerd fonts and icons|font-jetbrains-mono-nerd-font font-fantasque-sans-mono-nerd-font font-symbols-only-nerd-font|"
    "scripts|Custom scripts||scripts"
    "zsh|Zsh aliases and config||"
)

# ═══════════════════════════════════════════════════════════════════
# Brewfile Apps - organized by category
# These are installed via Brewfile or --apps
# ═══════════════════════════════════════════════════════════════════

APPS=(
    # Terminal power tools
    "bat|Cat with syntax highlighting|bat||terminal"
    "btop|Beautiful resource monitor|btop||terminal"
    "delta|Beautiful git diffs|git-delta||terminal"
    "duf|Better df with colors|duf||terminal"
    "dust|Better du with visuals|dust||terminal"
    "entr|Run commands on file change|entr||terminal"
    "eza|Modern ls replacement|eza||terminal"
    "fd|Fast find alternative|fd||terminal"
    "fzf|Fuzzy finder (Ctrl+R on steroids)|fzf||terminal"
    "hyperfine|Command benchmarking|hyperfine||terminal"
    "jq|JSON processor|jq||terminal"
    "lazygit|Git TUI (amazing)|lazygit||terminal"
    "ncdu|Disk usage analyzer TUI|ncdu||terminal"
    "ranger|Terminal file manager|ranger||terminal"
    "ripgrep|Super fast grep (rg)|ripgrep||terminal"
    "tldr|Simplified man pages|tlrc||terminal"
    "tmux|Terminal multiplexer|tmux||terminal"
    "trash|Safe rm (moves to trash)|trash||terminal"
    "tree|Directory tree viewer|tree||terminal"
    "yq|YAML/JSON/XML processor|yq||terminal"
    "zoxide|Smarter cd (z command)|zoxide||terminal"

    # Dev tools
    "curl|HTTP client|curl||dev"
    "direnv|Per-directory env vars|direnv||dev"
    "docker|Container runtime (Docker Desktop)|--cask docker||dev"
    "gh|GitHub CLI|gh||dev"
    "git|Version control|git||dev"
    "git-lfs|Git large file storage|git-lfs||dev"
    "glab|GitLab CLI|glab||dev"
    "httpie|Modern HTTP client|httpie||dev"
    "lazydocker|Docker TUI|lazydocker||dev"
    "pre-commit|Git pre-commit hooks|pre-commit||dev"
    "shellcheck|Shell script linter|shellcheck||dev"
    "shfmt|Shell script formatter|shfmt||dev"
    "wget|File downloader|wget||dev"

    # Network tools
    "aria2|Multi-connection downloader|aria2||network"
    "mtr|Better traceroute|mtr||network"
    "nmap|Network scanner|nmap||network"
    "speedtest|Internet speed test|speedtest-cli||network"

    # Media
    "ffmpeg|Video/audio processing|ffmpeg||media"
    "imagemagick|Image manipulation CLI|imagemagick||media"
    "mpv|Lightweight video player|mpv||media"
    "yt-dlp|Download any video (YouTube etc)|yt-dlp||media"

    # GUI Apps (casks)
    "flameshot|Screenshot tool with editor|--cask flameshot||apps"
    "obsidian|Note taking|--cask obsidian||apps"
    "raycast|Launcher (Spotlight/dmenu replacement)|--cask raycast||apps"
    "spotify|Music streaming|--cask spotify||apps"
    "vlc|Best media player ever|--cask vlc||apps"
    "vnc-viewer|RealVNC Viewer for remote desktop|--cask vnc-viewer||apps"
)

# Category display names
typeset -A CATEGORY_NAMES
CATEGORY_NAMES=(
    [apps]="GUI Apps"
    [dev]="Dev Tools"
    [media]="Media"
    [network]="Network"
    [terminal]="Terminal Power Tools"
)

CATEGORY_ORDER=(terminal dev network media apps)

# ═══════════════════════════════════════════════════════════════════
# Helper Functions
# ═══════════════════════════════════════════════════════════════════

print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   macOS Dotfiles Installation Script   ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
}

ensure_backup_dir() {
    if [[ "$BACKUP_CREATED" == false ]]; then
        generate_backup_dir
        mkdir -p "$BACKUP_DIR"
        BACKUP_CREATED=true
    fi
}

get_package_field() {
    local pkg="$1"
    local field="$2"
    for p in "${PACKAGES[@]}"; do
        local name="${p%%|*}"
        if [[ "$name" == "$pkg" ]]; then
            echo "$p" | cut -d'|' -f"$field"
            return 0
        fi
    done
    return 1
}

get_package_desc() { get_package_field "$1" 2; }
get_package_deps() { get_package_field "$1" 3; }
get_package_config() { get_package_field "$1" 4; }

list_packages() {
    echo -e "${BOLD}Available packages:${NC}"
    echo ""
    printf "  ${CYAN}%-12s${NC} %-35s %s\n" "NAME" "DESCRIPTION" "BREW PACKAGES"
    echo "  ──────────────────────────────────────────────────────────────────────"
    for p in "${PACKAGES[@]}"; do
        local name="${p%%|*}"
        local desc=$(get_package_desc "$name")
        local deps=$(get_package_deps "$name")
        [[ -z "$deps" ]] && deps="-"
        printf "  ${GREEN}%-12s${NC} %-35s ${YELLOW}%s${NC}\n" "$name" "$desc" "$deps"
    done
    echo ""
    echo -e "Usage: ${CYAN}./install_mac.sh <package> [package2] ...${NC}"
    echo -e "       ${CYAN}./install_mac.sh all${NC} to install everything"
}

list_apps() {
    echo -e "${BOLD}Available apps:${NC}"
    echo ""
    
    for category in "${CATEGORY_ORDER[@]}"; do
        echo -e "${CYAN}── ${CATEGORY_NAMES[$category]} ──${NC}"
        for app in "${APPS[@]}"; do
            local cat=$(echo "$app" | cut -d'|' -f5)
            [[ "$cat" != "$category" ]] && continue
            
            local name="${app%%|*}"
            local desc=$(echo "$app" | cut -d'|' -f2)
            
            if is_app_installed "$name"; then
                echo -e "  ${GREEN}${name}${NC}$(printf '%*s' $((14 - ${#name})) '') ${desc}$(printf '%*s' $((35 - ${#desc})) '') ${GREEN}[installed]${NC}"
            else
                echo -e "  ${YELLOW}${name}${NC}$(printf '%*s' $((14 - ${#name})) '') ${desc}"
            fi
        done
        echo ""
    done
    
    echo -e "Usage: ${CYAN}./install_mac.sh --apps${NC}              Interactive picker"
    echo -e "       ${CYAN}./install_mac.sh --apps vlc btop${NC}     Install specific apps"
    echo -e "       ${CYAN}./install_mac.sh --apps-list${NC}         Show this list"
}

is_app_installed() {
    local app_name="$1"
    case "$app_name" in
        docker) [[ -d "/Applications/Docker.app" ]] ;;
        visual-studio-code) [[ -d "/Applications/Visual Studio Code.app" ]] || command -v code &>/dev/null ;;
        iterm2) [[ -d "/Applications/iTerm.app" ]] ;;
        arc) [[ -d "/Applications/Arc.app" ]] ;;
        raycast) [[ -d "/Applications/Raycast.app" ]] ;;
        *) command -v "$app_name" &>/dev/null ;;
    esac
}

# ═══════════════════════════════════════════════════════════════════
# Installation Functions
# ═══════════════════════════════════════════════════════════════════

install_homebrew() {
    if command -v brew &>/dev/null; then
        echo -e "${GREEN}[OK]${NC} Homebrew already installed"
        return 0
    fi
    
    echo -e "${YELLOW}Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add to path for Apple Silicon
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    
    echo -e "${GREEN}[OK]${NC} Homebrew installed"
}

install_brew_packages() {
    local packages="$1"
    [[ -z "$packages" ]] && return 0
    
    local is_cask=false
    # Use ${=packages} for zsh word splitting
    for pkg in ${=packages}; do
        if [[ "$pkg" == "--cask" ]]; then
            is_cask=true
            continue
        fi
        
        if [[ "$is_cask" == true ]]; then
            # Check if app is already installed (App Store or other)
            local app_name="$pkg"
            if is_app_installed "$app_name"; then
                echo -e "${GREEN}[OK]${NC} $pkg already installed (App Store or manual)"
                is_cask=false
                continue
            fi
            if brew list --cask "$pkg" &>/dev/null; then
                echo -e "${GREEN}[OK]${NC} $pkg already installed (Homebrew)"
            else
                echo -e "${BLUE}[BREW]${NC} Installing cask: $pkg"
                brew install --cask "$pkg" || echo -e "${YELLOW}[WARN]${NC} $pkg install failed (may already exist)"
            fi
            is_cask=false
        # Check if it's a tap/formula
        elif [[ "$pkg" == *"/"* ]]; then
            local tap="${pkg%/*}"
            local formula="${pkg##*/}"
            if brew list "$formula" &>/dev/null; then
                echo -e "${GREEN}[OK]${NC} $formula already installed"
            else
                echo -e "${BLUE}[BREW]${NC} Tapping $tap and installing $formula"
                brew tap "$tap" 2>/dev/null || true
                brew install "$pkg" || brew install "$formula"
            fi
        else
            if brew list "$pkg" &>/dev/null; then
                echo -e "${GREEN}[OK]${NC} $pkg already installed"
            else
                echo -e "${BLUE}[BREW]${NC} Installing: $pkg"
                brew install "$pkg"
            fi
        fi
    done
}

install_from_brewfile() {
    local brewfile="$MAC_DIR/Brewfile"
    if [[ ! -f "$brewfile" ]]; then
        echo -e "${RED}[ERROR]${NC} Brewfile not found at $brewfile"
        return 1
    fi
    
    echo -e "${BLUE}Installing from Brewfile...${NC}"
    brew bundle --file="$brewfile"
    echo -e "${GREEN}[OK]${NC} Brewfile installation complete"
}

create_symlink() {
    local source="$1"
    local target="$2"
    
    if [[ ! -e "$source" ]]; then
        echo -e "${RED}[ERROR]${NC} Source not found: $source"
        return 1
    fi
    
    # Handle existing directory/file
    if [[ -e "$target" && ! -L "$target" ]]; then
        ensure_backup_dir
        echo -e "${YELLOW}[BACKUP]${NC} $target -> $BACKUP_DIR/"
        mv "$target" "$BACKUP_DIR/"
    elif [[ -L "$target" ]]; then
        rm "$target"
    fi
    
    mkdir -p "$(dirname "$target")"
    ln -s "$source" "$target"
    echo -e "${GREEN}[SYMLINK]${NC} $target -> $source"
}

install_package() {
    local pkg="$1"
    local desc=$(get_package_desc "$pkg")
    local deps=$(get_package_deps "$pkg")
    local config=$(get_package_config "$pkg")
    
    if [[ -z "$desc" ]]; then
        echo -e "${RED}[ERROR]${NC} Unknown package: $pkg"
        return 1
    fi
    
    echo -e "\n${BOLD}Installing $pkg${NC} - $desc"
    
    # Install brew dependencies
    if [[ -n "$deps" ]]; then
        install_brew_packages "$deps"
    fi
    
    # Create config symlink
    if [[ -n "$config" ]]; then
        local source="$MAC_DIR/.config/$config"
        local target="$CONFIG_DIR/$config"
        
        if [[ -e "$source" ]]; then
            create_symlink "$source" "$target"
        else
            echo -e "${YELLOW}[SKIP]${NC} Config dir not found: $source"
        fi
    fi
    
    # Special handling for certain packages
    case "$pkg" in
        zsh)
            setup_zsh
            ;;
        aerospace)
            setup_aerospace
            ;;
        raycast)
            setup_raycast
            ;;
        iterm2)
            setup_iterm2
            ;;
        sketchybar)
            setup_sketchybar
            ;;
        vnc)
            setup_vnc
            ;;
        scripts)
            setup_scripts
            ;;
    esac
    
    echo -e "${GREEN}[DONE]${NC} $pkg installed"
}

setup_zsh() {
    # Link .zshrc additions
    local zshrc_source="$MAC_DIR/.zshrc_dotfiles"
    if [[ -f "$zshrc_source" ]]; then
        # Add source line to .zshrc if not already present
        local source_line="source \"$zshrc_source\""
        if ! grep -qF "$source_line" "$HOME/.zshrc" 2>/dev/null; then
            echo "" >> "$HOME/.zshrc"
            echo "# Dotfiles customizations" >> "$HOME/.zshrc"
            echo "$source_line" >> "$HOME/.zshrc"
            echo -e "${GREEN}[OK]${NC} Added dotfiles source to .zshrc"
        else
            echo -e "${GREEN}[OK]${NC} .zshrc already configured"
        fi
    fi
}

setup_aerospace() {
    # Create aerospace config directory if needed
    mkdir -p "$HOME/.config/aerospace"
    echo -e "${CYAN}[INFO]${NC} AeroSpace tip: Start with 'aerospace' command or add to Login Items"
    echo -e "${CYAN}[INFO]${NC} Key binding: Alt+Enter to open terminal, Alt+d for app launcher"
}

setup_raycast() {
    # Make raycast scripts executable
    local scripts_dir="$MAC_DIR/.config/raycast/scripts"
    if [[ -d "$scripts_dir" ]]; then
        chmod +x "$scripts_dir"/*.sh 2>/dev/null
        echo -e "${CYAN}[INFO]${NC} Raycast scripts are in: ~/.config/raycast/scripts"
        echo -e "${CYAN}[INFO]${NC} To enable: Raycast Preferences → Script Commands → Add Script Directory"
    fi
}

setup_iterm2() {
    local profile="$MAC_DIR/.config/iterm2/dotfiles-profile.json"
    local target_dir="$HOME/.config/iterm2"
    
    # Create symlink for profile
    if [[ -f "$profile" ]]; then
        mkdir -p "$target_dir"
        ln -sf "$profile" "$target_dir/dotfiles-profile.json"
        echo -e "${GREEN}[OK]${NC} iTerm2 profile linked to ~/.config/iterm2/"
        echo -e "${CYAN}[INFO]${NC} To import: iTerm2 → Preferences → Profiles → Other Actions → Import JSON Profiles"
        echo -e "${CYAN}[INFO]${NC} Select: ~/.config/iterm2/dotfiles-profile.json"
        echo -e "${CYAN}[INFO]${NC} The profile uses zsh, Catppuccin colors, and JetBrains Mono Nerd Font"
    fi
    
    # Install iTerm2 shell integration
    if [[ ! -f "$HOME/.iterm2_shell_integration.zsh" ]]; then
        echo -e "${BLUE}[INSTALL]${NC} Installing iTerm2 shell integration..."
        curl -sL https://iterm2.com/shell_integration/install_shell_integration.sh | bash
        echo -e "${GREEN}[OK]${NC} iTerm2 shell integration installed"
    else
        echo -e "${GREEN}[OK]${NC} iTerm2 shell integration already installed"
    fi
}

setup_sketchybar() {
    # Make plugin scripts executable
    local plugins_dir="$MAC_DIR/.config/sketchybar/plugins"
    if [[ -d "$plugins_dir" ]]; then
        chmod +x "$plugins_dir"/*.sh 2>/dev/null
    fi
    
    # Set PLUGIN_DIR in config
    local config="$CONFIG_DIR/sketchybar/sketchybarrc"
    if [[ -f "$config" ]]; then
        # Add PLUGIN_DIR export at the top of the config
        sed -i '' "2i\\
PLUGIN_DIR=\"$CONFIG_DIR/sketchybar/plugins\"
" "$config" 2>/dev/null || true
    fi
    
    echo -e "${CYAN}[INFO]${NC} SketchyBar installed!"
    echo -e "${CYAN}[INFO]${NC} Start with: brew services start sketchybar"
    echo -e "${CYAN}[INFO]${NC} Or run manually: sketchybar"
    echo -e "${CYAN}[INFO]${NC} To hide macOS menu bar: System Settings → Desktop & Dock → Automatically hide menu bar → Always"
}

setup_vnc() {
    # Link VNC connections config
    mkdir -p "$HOME/.config/vnc"
    local vnc_conf="$MAC_DIR/.config/vnc/connections.conf"
    if [[ -f "$vnc_conf" ]]; then
        ln -sf "$vnc_conf" "$HOME/.config/vnc/connections.conf"
        echo -e "${GREEN}[OK]${NC} VNC connections config linked"
    fi
    
    echo -e "${CYAN}[INFO]${NC} VNC Viewer installed!"
    echo -e "${CYAN}[INFO]${NC}"
    echo -e "${CYAN}[INFO]${NC} Usage:"
    echo -e "${CYAN}[INFO]${NC}   vnc              # Interactive selection (with fzf)"
    echo -e "${CYAN}[INFO]${NC}   vnc homelab      # Connect to 'homelab'"
    echo -e "${CYAN}[INFO]${NC}   vnc -l           # List all connections"
    echo -e "${CYAN}[INFO]${NC}"
    echo -e "${CYAN}[INFO]${NC} Edit connections: ~/.config/vnc/connections.conf"
}

setup_scripts() {
    # Make all scripts executable
    local scripts_dir="$MAC_DIR/.config/scripts"
    if [[ -d "$scripts_dir" ]]; then
        chmod +x "$scripts_dir"/* 2>/dev/null || true
        echo -e "${GREEN}[OK]${NC} Scripts made executable"
    fi
    
    # Add scripts to PATH via symlink
    mkdir -p "$HOME/.local/bin"
    for script in "$scripts_dir"/*; do
        if [[ -f "$script" && -x "$script" ]]; then
            local name=$(basename "$script")
            ln -sf "$script" "$HOME/.local/bin/$name"
        fi
    done
    echo -e "${GREEN}[OK]${NC} Scripts linked to ~/.local/bin"
}

install_all() {
    echo -e "${BOLD}Installing all packages...${NC}\n"
    
    install_homebrew
    
    for p in "${PACKAGES[@]}"; do
        local name="${p%%|*}"
        install_package "$name"
    done
    
    echo -e "\n${GREEN}═══════════════════════════════════════════${NC}"
    echo -e "${GREEN}   All packages installed successfully!    ${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════${NC}"
    
    if [[ "$BACKUP_CREATED" == true ]]; then
        echo -e "\n${YELLOW}Backups saved to:${NC} $BACKUP_DIR"
    fi
    
    echo -e "\n${CYAN}Next steps:${NC}"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Start AeroSpace: aerospace"
    echo "  3. Optional: ./install_mac.sh --apps to install more apps"
}

install_app() {
    local app_name="$1"
    local brew_pkg=""
    local desc=""
    
    for app in "${APPS[@]}"; do
        local name="${app%%|*}"
        if [[ "$name" == "$app_name" ]]; then
            desc=$(echo "$app" | cut -d'|' -f2)
            brew_pkg=$(echo "$app" | cut -d'|' -f3)
            break
        fi
    done
    
    if [[ -z "$desc" ]]; then
        echo -e "${RED}[ERROR]${NC} Unknown app: $app_name"
        return 1
    fi
    
    if is_app_installed "$app_name"; then
        echo -e "${GREEN}[INSTALLED]${NC} $app_name - already installed"
        return 0
    fi
    
    echo -e "${BLUE}[INSTALLING]${NC} $app_name - $desc"
    install_brew_packages "$brew_pkg"
}

# ═══════════════════════════════════════════════════════════════════
# Interactive Menu
# ═══════════════════════════════════════════════════════════════════

show_menu() {
    print_header
    
    echo -e "${BOLD}What would you like to do?${NC}\n"
    echo "  1) Install everything (recommended for new setup)"
    echo "  2) Install specific packages"
    echo "  3) Install apps (GUI applications)"
    echo "  4) Install from Brewfile only"
    echo "  5) List available packages"
    echo "  6) List available apps"
    echo "  7) Setup Homebrew only"
    echo "  8) Exit"
    echo ""
    
    read -rp "Enter choice [1-8]: " choice
    
    case $choice in
        1) install_all ;;
        2)
            list_packages
            echo ""
            read -rp "Enter packages (space separated): " pkgs
            for pkg in $pkgs; do
                install_package "$pkg"
            done
            ;;
        3)
            list_apps
            echo ""
            read -rp "Enter apps (space separated): " apps
            for app in $apps; do
                install_app "$app"
            done
            ;;
        4) install_from_brewfile ;;
        5) list_packages ;;
        6) list_apps ;;
        7) install_homebrew ;;
        8) exit 0 ;;
        *) echo "Invalid choice"; exit 1 ;;
    esac
}

# ═══════════════════════════════════════════════════════════════════
# Main Entry Point
# ═══════════════════════════════════════════════════════════════════

main() {
    # Ensure mac/ directory exists
    if [[ ! -d "$MAC_DIR" ]]; then
        echo -e "${RED}[ERROR]${NC} mac/ directory not found. Run from dotfiles root."
        exit 1
    fi
    
    case "${1:-}" in
        "")
            show_menu
            ;;
        all)
            print_header
            install_all
            ;;
        --list)
            list_packages
            ;;
        --apps)
            shift
            if [[ $# -eq 0 ]]; then
                list_apps
            else
                install_homebrew
                for app in "$@"; do
                    install_app "$app"
                done
            fi
            ;;
        --apps-list)
            list_apps
            ;;
        --brewfile)
            install_homebrew
            install_from_brewfile
            ;;
        --help|-h)
            echo "Usage: ./install_mac.sh [command]"
            echo ""
            echo "Commands:"
            echo "  (none)        Interactive menu"
            echo "  all           Install everything"
            echo "  <pkg> [pkg2]  Install specific packages"
            echo "  --list        List available packages"
            echo "  --apps [app]  Install apps (interactive or specific)"
            echo "  --apps-list   List available apps"
            echo "  --brewfile    Install from Brewfile only"
            echo "  --help        Show this help"
            ;;
        *)
            print_header
            install_homebrew
            for pkg in "$@"; do
                install_package "$pkg"
            done
            ;;
    esac
}

main "$@"
