#!/bin/bash
#
# Dotfiles Installation Script
# Creates symlinks from ~/.config to this repo
#
# Usage:
#   ./install.sh              # Interactive menu
#   ./install.sh all          # Install everything
#   ./install.sh i3 polybar   # Install specific packages
#   ./install.sh --list       # List available packages
#   ./install.sh --deps-only  # Only install apt dependencies
#

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR=""  # Set dynamically to ensure unique timestamp
BACKUP_CREATED=false

# Generate unique backup dir with 1s sleep to prevent timestamp collisions
generate_backup_dir() {
    sleep 1  # Ensure unique timestamp even if run in rapid succession
    BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ═══════════════════════════════════════════════════════════════════
# Package Definitions - each package with its deps and config dir
# Format: "name|description|apt_packages (space separated)|config_dir"
# ═══════════════════════════════════════════════════════════════════

declare -a PACKAGES=(
    "i3|Tiling window manager (i3-gaps)|dex xss-lock i3lock xinput|i3"
    "polybar|Status bar|polybar|polybar"
    "picom|Compositor (transparency, blur, shadows)|picom|picom"
    "kitty|GPU-accelerated terminal|kitty|kitty"
    "dunst|Notification daemon|dunst libnotify-bin|dunst"
    "rofi|Application launcher|rofi|"
    "dmenu|Lightweight launcher||"
    "screenshots|Screenshot tools|maim xclip xdotool|"
    "brightness|Screen brightness control|brightnessctl|"
    "autorandr|Multi-monitor profiles|autorandr|autorandr"
    "feh|Wallpaper setter (used by i3)|feh|"
    "tray|System tray apps|network-manager-gnome pasystray copyq udiskie|"
    "btop|Resource monitor|btop|btop"
    "htop|Process viewer|htop|htop"
    "fastfetch|System info display (fast neofetch)||fastfetch"
    "nvim|Neovim config||nvim"
    "fonts|Nerd fonts and icons|fonts-jetbrains-mono fonts-font-awesome|"
    "scripts|Custom scripts||scripts"
    "backgrounds|Wallpapers||backgrounds"
    "wally|ZSA keyboard flasher||wally"
    "bash|Bash aliases||"
)

# ═══════════════════════════════════════════════════════════════════
# General Apps - awesome tools (no config files, just apt/flatpak)
# Format: "name|description|apt_package|flatpak_id"
# ═══════════════════════════════════════════════════════════════════

# Apps organized by category, sorted alphabetically within each
# Format: "name|description|apt_package|flatpak_id|category"

declare -a APPS=(
    # Apps
    "blender|3D modeling|blender||apps"
    "chromium|Browser|chromium-browser||apps"
    "discord|Chat||com.discordapp.Discord|apps"
    "evince|PDF viewer|evince||apps"
    "firefox|Browser|firefox||apps"
    "gimp|Image editor|gimp||apps"
    "gpick|Color picker|gpick||apps"
    "inkscape|Vector graphics|inkscape||apps"
    "keepassxc|Password manager|keepassxc||apps"
    "krita|Digital painting||org.kde.krita|apps"
    "libreoffice|Office suite|libreoffice||apps"
    "obsidian|Note taking||md.obsidian.Obsidian|apps"
    "slack|Work chat|slack-desktop||apps"
    "zathura|Minimal PDF viewer|zathura||apps"
    
    # Dev tools
    "curl|HTTP client|curl||dev"
    "direnv|Per-directory env vars|direnv||dev"
    "docker|Container runtime|docker.io docker-compose||dev"
    "gh|GitHub CLI|||dev"
    "git|Version control|git||dev"
    "git-lfs|Git large file storage|git-lfs||dev"
    "glab|GitLab CLI|||dev"
    "httpie|Modern HTTP client|httpie||dev"
    "lazydocker|Docker TUI|||dev"
    "pre-commit|Git pre-commit hooks|||dev"
    "shellcheck|Shell script linter|shellcheck||dev"
    "shfmt|Shell script formatter|||dev"
    "wget|File downloader|wget||dev"
    
    # Media
    "ffmpeg|Video/audio processing|ffmpeg||media"
    "imagemagick|Image manipulation CLI|imagemagick||media"
    "mpv|Lightweight video player|mpv||media"
    "spotify|Music streaming||com.spotify.Client|media"
    "vlc|Best media player ever|vlc||media"
    "yt-dlp|Download any video (YouTube etc)|||media"
    
    # Network tools
    "aria2|Multi-connection downloader|aria2||network"
    "iftop|Network bandwidth monitor|iftop||network"
    "mtr|Better traceroute|mtr||network"
    "netcat|TCP/UDP networking|netcat-openbsd||network"
    "nethogs|Per-process network usage|nethogs||network"
    "nload|Network traffic monitor|nload||network"
    "nmap|Network scanner|nmap||network"
    "speedtest|Internet speed test|speedtest-cli||network"
    
    # Screen recording & demos
    "asciinema|Terminal session recorder|asciinema||recording"
    "obs|Screen recording/streaming|obs-studio||recording"
    "peek|GIF screen recorder|peek||recording"
    "screenkey|Show keypresses for demos|screenkey||recording"
    
    # System utilities
    "arandr|Monitor layout GUI|arandr||system"
    "baobab|Disk usage analyzer GUI|baobab||system"
    "blueman|Bluetooth manager|blueman||system"
    "dconf-editor|GNOME settings editor|dconf-editor||system"
    "flameshot|Screenshot tool with editor|flameshot||system"
    "gparted|Partition editor|gparted||system"
    "inxi|System info CLI|inxi||system"
    "lm-sensors|Hardware temp sensors|lm-sensors||system"
    "lsof|List open files|lsof||system"
    "pavucontrol|Audio control GUI|pavucontrol||system"
    "playerctl|Media player control|playerctl||system"
    "redshift|Night mode / blue light filter|redshift||system"
    "strace|System call tracer|strace||system"
    "xkill|Kill window by clicking|x11-utils||system"
    
    # Terminal power tools
    "bat|Cat with syntax highlighting|bat||terminal"
    "btop|Beautiful resource monitor|btop||terminal"
    "delta|Beautiful git diffs|||terminal"
    "duf|Better df with colors|duf||terminal"
    "dust|Better du with visuals|||terminal"
    "entr|Run commands on file change|entr||terminal"
    "eza|Modern ls replacement|||terminal"
    "fd|Fast find alternative|fd-find||terminal"
    "fzf|Fuzzy finder (Ctrl+R on steroids)|||terminal"
    "hyperfine|Command benchmarking|hyperfine||terminal"
    "jq|JSON processor|jq||terminal"
    "lazygit|Git TUI (amazing)|||terminal"
    "moreutils|Sponge, parallel, etc|moreutils||terminal"
    "ncdu|Disk usage analyzer TUI|ncdu||terminal"
    "nnn|Fast terminal file manager|nnn||terminal"
    "procs|Better ps|||terminal"
    "pv|Pipe progress viewer|pv||terminal"
    "ranger|Terminal file manager|ranger||terminal"
    "ripgrep|Super fast grep (rg)|ripgrep||terminal"
    "tldr|Simplified man pages|tldr||terminal"
    "tmux|Terminal multiplexer|tmux||terminal"
    "trash-cli|Safe rm (moves to trash)|trash-cli||terminal"
    "tree|Directory tree viewer|tree||terminal"
    "watch|Run command periodically|procps||terminal"
    "xclip|Clipboard from terminal|xclip||terminal"
    "xdotool|Automate X actions|xdotool||terminal"
    "yq|YAML/JSON/XML processor|||terminal"
    "zoxide|Smarter cd (z command)|||terminal"
)

# Category display names
declare -A CATEGORY_NAMES=(
    ["apps"]="Apps"
    ["dev"]="Dev Tools"
    ["media"]="Media"
    ["network"]="Network"
    ["recording"]="Screen Recording & Demos"
    ["system"]="System Utilities"
    ["terminal"]="Terminal Power Tools"
)

# Category order for display
CATEGORY_ORDER=(terminal dev system network media recording apps)

# ═══════════════════════════════════════════════════════════════════
# Helper Functions
# ═══════════════════════════════════════════════════════════════════

print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║       Dotfiles Installation Script     ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
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

# Clean up existing configs and convert to symlinks
clean_and_relink() {
    echo -e "${YELLOW}Cleaning existing configs and converting to symlinks...${NC}"
    echo ""
    
    # Get all config dirs from packages
    local configs=()
    for p in "${PACKAGES[@]}"; do
        local name="${p%%|*}"
        local config=$(get_package_config "$name")
        [[ -n "$config" ]] && configs+=("$config")
    done
    
    # Add neofetch to clean up stale symlinks
    configs+=("neofetch")
    
    local backed_up=()
    local removed_symlinks=()
    local skipped=()
    
    for config in "${configs[@]}"; do
        local target="$CONFIG_DIR/$config"
        
        if [[ -d "$target" && ! -L "$target" ]]; then
            # Real directory - needs backup
            ensure_backup_dir
            echo -e "${YELLOW}[BACKUP]${NC} $config -> $BACKUP_DIR/$config"
            mv "$target" "$BACKUP_DIR/$config"
            backed_up+=("$config")
        elif [[ -L "$target" ]]; then
            # Symlink - just remove it
            echo -e "${BLUE}[REMOVE]${NC} Stale symlink: $config"
            rm "$target"
            removed_symlinks+=("$config")
        else
            skipped+=("$config")
        fi
    done
    
    echo ""
    echo -e "${GREEN}Cleanup complete!${NC}"
    [[ ${#backed_up[@]} -gt 0 ]] && echo -e "  Backed up: ${YELLOW}${backed_up[*]}${NC}"
    [[ ${#removed_symlinks[@]} -gt 0 ]] && echo -e "  Removed symlinks: ${BLUE}${removed_symlinks[*]}${NC}"
    [[ "$BACKUP_CREATED" == true ]] && echo -e "  Backup location: ${CYAN}$BACKUP_DIR${NC}"
    echo ""
    echo -e "Now run ${CYAN}./install.sh all${NC} to create fresh symlinks."
}

list_packages() {
    echo -e "${BOLD}Available packages:${NC}"
    echo ""
    printf "  ${CYAN}%-12s${NC} %-35s %s\n" "NAME" "DESCRIPTION" "APT DEPS"
    echo "  ──────────────────────────────────────────────────────────────────────"
    for p in "${PACKAGES[@]}"; do
        local name="${p%%|*}"
        local desc=$(get_package_desc "$name")
        local deps=$(get_package_deps "$name")
        [[ -z "$deps" ]] && deps="-"
        printf "  ${GREEN}%-12s${NC} %-35s ${YELLOW}%s${NC}\n" "$name" "$desc" "$deps"
    done
    echo ""
    echo -e "Usage: ${CYAN}./install.sh <package> [package2] ...${NC}"
    echo -e "       ${CYAN}./install.sh all${NC} to install everything"
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
                echo -e "  ${GREEN}${name}${NC}$(printf '%*s' $((14 - ${#name})) '') ${desc}$(printf '%*s' $((40 - ${#desc})) '') ${GREEN}[installed]${NC}"
            else
                echo -e "  ${YELLOW}${name}${NC}$(printf '%*s' $((14 - ${#name})) '') ${desc}"
            fi
        done
        echo ""
    done
    
    echo -e "Usage: ${CYAN}./install.sh --apps${NC}              Interactive picker"
    echo -e "       ${CYAN}./install.sh --apps vlc btop${NC}     Install specific apps"
    echo -e "       ${CYAN}./install.sh --apps-list${NC}         Show this list"
}

# Check if an app is installed
is_app_installed() {
    local app_name="$1"
    
    # Map app names to binary names where they differ
    case "$app_name" in
        ripgrep) command -v rg &>/dev/null ;;
        fd) command -v fdfind &>/dev/null || command -v fd &>/dev/null ;;
        bat) command -v batcat &>/dev/null || command -v bat &>/dev/null ;;
        trash-cli) command -v trash-put &>/dev/null ;;
        speedtest) command -v speedtest-cli &>/dev/null || command -v speedtest &>/dev/null ;;
        netcat) command -v nc &>/dev/null ;;
        docker) command -v docker &>/dev/null ;;
        obs) command -v obs &>/dev/null ;;
        lm-sensors) command -v sensors &>/dev/null ;;
        xkill) command -v xkill &>/dev/null ;;
        moreutils) command -v sponge &>/dev/null ;;
        imagemagick) command -v convert &>/dev/null ;;
        git-lfs) command -v git-lfs &>/dev/null ;;
        watch) command -v watch &>/dev/null ;;
        fzf) 
            # fzf needs version 0.33+ for zoxide compatibility
            if command -v fzf &>/dev/null; then
                local ver=$(fzf --version | cut -d' ' -f1)
                [[ "$(printf '%s\n' "0.33" "$ver" | sort -V | head -1)" == "0.33" ]]
            else
                return 1
            fi
            ;;
        *) command -v "$app_name" &>/dev/null ;;
    esac
}

install_app() {
    local app_name="$1"
    local skip_installed="${2:-true}"  # Default to skipping installed apps
    local apt_pkg=""
    local flatpak_id=""
    local desc=""
    
    for app in "${APPS[@]}"; do
        local name="${app%%|*}"
        if [[ "$name" == "$app_name" ]]; then
            desc=$(echo "$app" | cut -d'|' -f2)
            apt_pkg=$(echo "$app" | cut -d'|' -f3)
            flatpak_id=$(echo "$app" | cut -d'|' -f4)
            break
        fi
    done
    
    if [[ -z "$desc" ]]; then
        echo -e "${RED}[ERROR]${NC} Unknown app: $app_name"
        return 1
    fi
    
    # Check if already installed
    if [[ "$skip_installed" == "true" ]] && is_app_installed "$app_name"; then
        echo -e "${GREEN}[INSTALLED]${NC} $app_name - already installed, skipping"
        return 0
    fi
    
    echo -e "${BLUE}[INSTALLING]${NC} $app_name - $desc"
    
    # Special handlers for apps not in apt
    case "$app_name" in
        lazygit)
            install_lazygit
            return $?
            ;;
        eza)
            install_eza
            return $?
            ;;
        fzf)
            install_fzf
            return $?
            ;;
        zoxide)
            install_zoxide
            return $?
            ;;
        yt-dlp)
            install_yt_dlp
            return $?
            ;;
        dust)
            install_dust
            return $?
            ;;
        procs)
            install_procs
            return $?
            ;;
        delta)
            install_delta
            return $?
            ;;
        lazydocker)
            install_lazydocker
            return $?
            ;;
        gh)
            install_gh
            return $?
            ;;
        glab)
            install_glab
            return $?
            ;;
        yq)
            install_yq
            return $?
            ;;
        shfmt)
            install_shfmt
            return $?
            ;;
        pre-commit)
            install_pre_commit
            return $?
            ;;
    esac
    
    # Try apt first
    if [[ -n "$apt_pkg" ]]; then
        sudo apt install -y $apt_pkg 2>/dev/null && return 0
    fi
    
    # Try flatpak
    if [[ -n "$flatpak_id" ]]; then
        if ! command -v flatpak &>/dev/null; then
            echo -e "${YELLOW}Installing flatpak...${NC}"
            sudo apt install -y flatpak
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        fi
        flatpak install -y flathub "$flatpak_id" && return 0
    fi
    
    echo -e "${RED}[FAIL]${NC} Could not install $app_name"
    return 1
}

# Special installers for apps not in Ubuntu 22.04 repos
install_lazygit() {
    if command -v lazygit &>/dev/null; then
        echo -e "${GREEN}[OK]${NC} lazygit already installed"
        return 0
    fi
    
    echo -e "${YELLOW}Installing lazygit from GitHub...${NC}"
    local version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${version}_Linux_x86_64.tar.gz"
    tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
    sudo install /tmp/lazygit /usr/local/bin
    rm /tmp/lazygit.tar.gz /tmp/lazygit
    echo -e "${GREEN}[OK]${NC} lazygit installed to /usr/local/bin"
}

install_eza() {
    if command -v eza &>/dev/null; then
        echo -e "${GREEN}[OK]${NC} eza already installed"
        return 0
    fi
    
    echo -e "${YELLOW}Installing eza from GitHub...${NC}"
    curl -Lo /tmp/eza.tar.gz "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz"
    tar xf /tmp/eza.tar.gz -C /tmp
    sudo install /tmp/eza /usr/local/bin
    rm /tmp/eza.tar.gz /tmp/eza
    echo -e "${GREEN}[OK]${NC} eza installed to /usr/local/bin"
}

install_fzf() {
    if command -v fzf &>/dev/null; then
        local ver=$(fzf --version | cut -d' ' -f1)
        # Check if version is 0.33 or higher (supports 'start' key)
        if [[ "$(printf '%s\n' "0.33" "$ver" | sort -V | head -1)" == "0.33" ]]; then
            echo -e "${GREEN}[OK]${NC} fzf $ver already installed"
            return 0
        fi
        echo -e "${YELLOW}fzf $ver is outdated, upgrading...${NC}"
    fi
    
    echo -e "${YELLOW}Installing fzf from GitHub...${NC}"
    # Remove apt version if present
    sudo apt remove -y fzf 2>/dev/null
    # Install via official installer
    rm -rf ~/.fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --bin
    sudo install ~/.fzf/bin/fzf /usr/local/bin/
    echo -e "${GREEN}[OK]${NC} fzf installed to /usr/local/bin"
}

install_zoxide() {
    if command -v zoxide &>/dev/null; then
        echo -e "${GREEN}[OK]${NC} zoxide already installed"
        return 0
    fi
    
    echo -e "${YELLOW}Installing zoxide...${NC}"
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    echo -e "${GREEN}[OK]${NC} zoxide installed"
    echo -e "${YELLOW}Add to ~/.bashrc:${NC} eval \"\$(zoxide init bash)\""
}

install_yt_dlp() {
    if command -v yt-dlp &>/dev/null; then
        echo -e "${GREEN}[OK]${NC} yt-dlp already installed"
        return 0
    fi
    
    echo -e "${YELLOW}Installing yt-dlp...${NC}"
    sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
    sudo chmod a+rx /usr/local/bin/yt-dlp
    echo -e "${GREEN}[OK]${NC} yt-dlp installed"
}

install_dust() {
    if command -v dust &>/dev/null; then
        echo -e "${GREEN}[OK]${NC} dust already installed"
        return 0
    fi
    
    echo -e "${YELLOW}Installing dust from GitHub...${NC}"
    local url=$(curl -s "https://api.github.com/repos/bootandy/dust/releases/latest" | grep "browser_download_url.*amd64.deb" | head -1 | cut -d '"' -f 4)
    curl -Lo /tmp/dust.deb "$url"
    sudo dpkg -i /tmp/dust.deb
    rm /tmp/dust.deb
    echo -e "${GREEN}[OK]${NC} dust installed"
}

install_procs() {
    if command -v procs &>/dev/null; then
        echo -e "${GREEN}[OK]${NC} procs already installed"
        return 0
    fi
    
    echo -e "${YELLOW}Installing procs from GitHub...${NC}"
    local version=$(curl -s "https://api.github.com/repos/dalance/procs/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo /tmp/procs.zip "https://github.com/dalance/procs/releases/latest/download/procs-v${version}-x86_64-linux.zip"
    unzip -o /tmp/procs.zip -d /tmp
    sudo install /tmp/procs /usr/local/bin
    rm /tmp/procs.zip /tmp/procs
    echo -e "${GREEN}[OK]${NC} procs installed"
}

install_delta() {
    if command -v delta &>/dev/null; then
        echo -e "${GREEN}[OK]${NC} delta already installed"
        return 0
    fi
    
    echo -e "${YELLOW}Installing delta from GitHub...${NC}"
    curl -Lo /tmp/delta.deb "https://github.com/dandavison/delta/releases/latest/download/git-delta_0.18.2_amd64.deb"
    sudo dpkg -i /tmp/delta.deb
    rm /tmp/delta.deb
    echo -e "${GREEN}[OK]${NC} delta installed"
    echo -e "${YELLOW}Add to ~/.gitconfig:${NC}"
    echo "  [core]"
    echo "    pager = delta"
}

install_lazydocker() {
    if command -v lazydocker &>/dev/null; then
        echo -e "${GREEN}[OK]${NC} lazydocker already installed"
        return 0
    fi
    
    echo -e "${YELLOW}Installing lazydocker from GitHub...${NC}"
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
    echo -e "${GREEN}[OK]${NC} lazydocker installed"
}

install_gh() {
    if command -v gh &>/dev/null; then
        echo -e "${GREEN}[OK]${NC} gh already installed"
        return 0
    fi
    
    echo -e "${YELLOW}Installing GitHub CLI...${NC}"
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update && sudo apt install gh -y
    echo -e "${GREEN}[OK]${NC} gh installed"
}

install_glab() {
    if command -v glab &>/dev/null; then
        echo -e "${GREEN}[OK]${NC} glab already installed"
        return 0
    fi
    
    echo -e "${YELLOW}Installing GitLab CLI...${NC}"
    curl -Lo /tmp/glab.deb "https://gitlab.com/gitlab-org/cli/-/releases/permalink/latest/downloads/glab_amd64.deb"
    sudo dpkg -i /tmp/glab.deb
    rm /tmp/glab.deb
    echo -e "${GREEN}[OK]${NC} glab installed"
    echo -e "${YELLOW}Run:${NC} glab auth login"
}

install_yq() {
    if command -v yq &>/dev/null; then
        echo -e "${GREEN}[OK]${NC} yq already installed"
        return 0
    fi
    
    echo -e "${YELLOW}Installing yq from GitHub...${NC}"
    sudo curl -Lo /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64"
    sudo chmod +x /usr/local/bin/yq
    echo -e "${GREEN}[OK]${NC} yq installed"
}

install_shfmt() {
    if command -v shfmt &>/dev/null; then
        echo -e "${GREEN}[OK]${NC} shfmt already installed"
        return 0
    fi
    
    echo -e "${YELLOW}Installing shfmt from GitHub...${NC}"
    sudo curl -Lo /usr/local/bin/shfmt "https://github.com/mvdan/sh/releases/latest/download/shfmt_v3.8.0_linux_amd64"
    sudo chmod +x /usr/local/bin/shfmt
    echo -e "${GREEN}[OK]${NC} shfmt installed"
}

install_pre_commit() {
    if command -v pre-commit &>/dev/null; then
        echo -e "${GREEN}[OK]${NC} pre-commit already installed"
        return 0
    fi
    
    echo -e "${YELLOW}Installing pre-commit via pip...${NC}"
    pip3 install --user pre-commit
    echo -e "${GREEN}[OK]${NC} pre-commit installed"
}

interactive_apps_menu() {
    echo -e "${BOLD}Select apps to install:${NC}"
    echo ""
    
    local i=1
    declare -a app_list=()
    
    # Display apps by category with install status
    for category in "${CATEGORY_ORDER[@]}"; do
        echo -e "${CYAN}── ${CATEGORY_NAMES[$category]} ──${NC}"
        for app in "${APPS[@]}"; do
            local cat=$(echo "$app" | cut -d'|' -f5)
            [[ "$cat" != "$category" ]] && continue
            
            local name="${app%%|*}"
            local desc=$(echo "$app" | cut -d'|' -f2)
            
            app_list+=("$name")
            
            if is_app_installed "$name"; then
                echo -e "  ${GREEN}$(printf '%3d' $i)) ${name}${NC}$(printf '%*s' $((14 - ${#name})) '') ${desc}$(printf '%*s' $((35 - ${#desc})) '') ${GREEN}[installed]${NC}"
            else
                echo -e "  ${YELLOW}$(printf '%3d' $i)) ${name}${NC}$(printf '%*s' $((14 - ${#name})) '') ${desc}"
            fi
            ((i++))
        done
        echo ""
    done
    
    echo -e "Enter app names or numbers separated by spaces (or 'all' for uninstalled):"
    read -r choices
    
    if [[ "$choices" == "all" ]]; then
        echo ""
        echo -e "${BOLD}Installing all uninstalled apps...${NC}"
        for app in "${APPS[@]}"; do
            install_app "${app%%|*}"
        done
    else
        for choice in $choices; do
            # Check if it's a number
            if [[ "$choice" =~ ^[0-9]+$ ]] && [[ $choice -ge 1 ]] && [[ $choice -le ${#app_list[@]} ]]; then
                local idx=$((choice - 1))
                install_app "${app_list[$idx]}"
            else
                install_app "$choice"
            fi
        done
    fi
}

ensure_backup_dir() {
    if [[ "$BACKUP_CREATED" == false ]]; then
        generate_backup_dir
        mkdir -p "$BACKUP_DIR"
        BACKUP_CREATED=true
    fi
}

install_apt_packages() {
    local packages=("$@")
    if [[ ${#packages[@]} -eq 0 ]]; then
        return 0
    fi
    
    echo -e "${YELLOW}APT packages: ${packages[*]}${NC}"
    read -p "Install these packages? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo apt update
        sudo apt install -y "${packages[@]}"
        echo -e "${GREEN}[OK]${NC} Packages installed"
        return 0
    else
        echo -e "${YELLOW}[SKIP]${NC} Package installation skipped"
        return 1
    fi
}

link_config() {
    local config="$1"
    local SOURCE="$DOTFILES_DIR/.config/$config"
    local TARGET="$CONFIG_DIR/$config"
    
    if [[ ! -d "$SOURCE" ]]; then
        echo -e "${YELLOW}[SKIP]${NC} $config - config dir not found in dotfiles"
        return 1
    fi
    
    ensure_backup_dir
    
    # Backup existing config if it exists and is not a symlink
    if [[ -d "$TARGET" && ! -L "$TARGET" ]]; then
        echo -e "${YELLOW}[BACKUP]${NC} $config -> $BACKUP_DIR/$config"
        mv "$TARGET" "$BACKUP_DIR/$config"
    elif [[ -L "$TARGET" ]]; then
        echo -e "${BLUE}[UNLINK]${NC} Removing old symlink: $config"
        rm "$TARGET"
    fi
    
    # Create symlink
    ln -s "$SOURCE" "$TARGET"
    echo -e "${GREEN}[LINK]${NC} $config -> $SOURCE"
    return 0
}

# ═══════════════════════════════════════════════════════════════════
# Package Installation Functions
# ═══════════════════════════════════════════════════════════════════

install_package() {
    local pkg="$1"
    local deps=$(get_package_deps "$pkg")
    local config=$(get_package_config "$pkg")
    local desc=$(get_package_desc "$pkg")
    
    if [[ -z "$desc" ]]; then
        echo -e "${RED}[ERROR]${NC} Unknown package: $pkg"
        return 1
    fi
    
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}Installing: $pkg${NC} - $desc"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Install apt dependencies if any
    if [[ -n "$deps" ]]; then
        # Check which packages are missing
        local missing=()
        for dep in $deps; do
            if ! dpkg -l "$dep" 2>/dev/null | grep -q "^ii"; then
                missing+=("$dep")
            fi
        done
        
        if [[ ${#missing[@]} -gt 0 ]]; then
            install_apt_packages "${missing[@]}"
        else
            echo -e "${GREEN}[OK]${NC} All dependencies already installed"
        fi
    fi
    
    # Link config directory if any
    if [[ -n "$config" ]]; then
        link_config "$config"
    fi
    
    # Special handling for specific packages
    case "$pkg" in
        bash)
            install_bash_aliases
            ;;
        fastfetch)
            install_fastfetch
            # Also set up bash aliases so 'ff' works
            install_bash_aliases
            ;;
    esac
    
    return 0
}

install_fastfetch() {
    # Check if fastfetch is already installed
    if command -v fastfetch &> /dev/null; then
        echo -e "${GREEN}[OK]${NC} fastfetch already installed"
        return 0
    fi
    
    echo -e "${YELLOW}fastfetch not in apt, installing from GitHub...${NC}"
    
    # Get latest release URL
    local ARCH=$(dpkg --print-architecture)
    local RELEASE_URL="https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-${ARCH}.deb"
    local TMP_DEB="/tmp/fastfetch.deb"
    
    read -p "Download and install fastfetch from GitHub? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        curl -L -o "$TMP_DEB" "$RELEASE_URL" && \
        sudo dpkg -i "$TMP_DEB" && \
        rm "$TMP_DEB"
        echo -e "${GREEN}[OK]${NC} fastfetch installed"
        echo -e "${YELLOW}Run: ${CYAN}source ~/.bash_aliases${YELLOW} to enable 'ff' alias${NC}"
    else
        echo -e "${YELLOW}[SKIP]${NC} fastfetch installation"
        echo -e "Install manually: ${CYAN}https://github.com/fastfetch-cli/fastfetch${NC}"
    fi
}

install_bash_aliases() {
    echo -e "${BLUE}Setting up bash aliases...${NC}"
    
    local ALIASES_SOURCE="$DOTFILES_DIR/.bash_aliases"
    local ALIASES_TARGET="$HOME/.bash_aliases"
    local BASHRC="$HOME/.bashrc"
    
    if [[ -f "$ALIASES_SOURCE" ]]; then
        ensure_backup_dir
        
        # Backup existing .bash_aliases if it exists and differs
        if [[ -f "$ALIASES_TARGET" && ! -L "$ALIASES_TARGET" ]]; then
            if ! diff -q "$ALIASES_SOURCE" "$ALIASES_TARGET" > /dev/null 2>&1; then
                echo -e "${YELLOW}[BACKUP]${NC} .bash_aliases -> $BACKUP_DIR/"
                cp "$ALIASES_TARGET" "$BACKUP_DIR/.bash_aliases"
            fi
        fi
        
        # Remove old symlink or file and create new symlink
        rm -f "$ALIASES_TARGET"
        ln -s "$ALIASES_SOURCE" "$ALIASES_TARGET"
        echo -e "${GREEN}[LINK]${NC} .bash_aliases -> $ALIASES_SOURCE"
        
        # Add sourcing line to .bashrc if not present
        SOURCE_LINE='if [ -f ~/.bash_aliases ]; then . ~/.bash_aliases; fi'
        if ! grep -qF ".bash_aliases" "$BASHRC" 2>/dev/null; then
            echo "" >> "$BASHRC"
            echo "# Load custom aliases from dotfiles" >> "$BASHRC"
            echo "$SOURCE_LINE" >> "$BASHRC"
            echo -e "${GREEN}[ADDED]${NC} Sourcing line added to .bashrc"
        else
            echo -e "${BLUE}[OK]${NC} .bashrc already sources .bash_aliases"
        fi
    else
        echo -e "${YELLOW}[SKIP]${NC} .bash_aliases not found in dotfiles"
    fi
}

install_all() {
    for p in "${PACKAGES[@]}"; do
        local name="${p%%|*}"
        install_package "$name"
    done
}

install_deps_only() {
    echo -e "${BLUE}Collecting all APT dependencies...${NC}"
    echo ""
    
    local all_deps=()
    for p in "${PACKAGES[@]}"; do
        local name="${p%%|*}"
        local deps=$(get_package_deps "$name")
        for dep in $deps; do
            # Add if not already in array
            if [[ ! " ${all_deps[*]} " =~ " ${dep} " ]]; then
                all_deps+=("$dep")
            fi
        done
    done
    
    echo -e "${YELLOW}All APT packages:${NC}"
    printf '  %s\n' "${all_deps[@]}"
    echo ""
    
    install_apt_packages "${all_deps[@]}"
}

interactive_menu() {
    echo -e "${BOLD}What would you like to install?${NC}"
    echo ""
    echo -e "  ${CYAN}1)${NC} Everything (all packages + configs)"
    echo -e "  ${CYAN}2)${NC} Only APT dependencies (no configs)"
    echo -e "  ${CYAN}3)${NC} Select individual packages"
    echo -e "  ${CYAN}4)${NC} List available packages"
    echo -e "  ${CYAN}q)${NC} Quit"
    echo ""
    read -p "Choose an option: " -n 1 -r
    echo
    echo ""
    
    case $REPLY in
        1)
            install_all
            ;;
        2)
            install_deps_only
            ;;
        3)
            select_packages
            ;;
        4)
            list_packages
            interactive_menu
            ;;
        q|Q)
            echo "Bye!"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option${NC}"
            interactive_menu
            ;;
    esac
}

select_packages() {
    echo -e "${BOLD}Select packages to install (space-separated numbers):${NC}"
    echo ""
    
    local i=1
    local pkg_names=()
    for p in "${PACKAGES[@]}"; do
        local name="${p%%|*}"
        local desc=$(get_package_desc "$name")
        pkg_names+=("$name")
        printf "  ${CYAN}%2d)${NC} %-12s - %s\n" "$i" "$name" "$desc"
        ((i++))
    done
    
    echo ""
    read -p "Enter numbers (e.g., 1 3 5): " -r selections
    
    for sel in $selections; do
        if [[ "$sel" =~ ^[0-9]+$ ]] && [[ $sel -ge 1 ]] && [[ $sel -le ${#pkg_names[@]} ]]; then
            local idx=$((sel - 1))
            install_package "${pkg_names[$idx]}"
        else
            echo -e "${RED}[SKIP]${NC} Invalid selection: $sel"
        fi
    done
}

print_completion() {
    echo ""
    echo -e "${GREEN}════════════════════════════════════════${NC}"
    echo -e "${GREEN}Installation complete!${NC}"
    echo ""
    if [[ "$BACKUP_CREATED" == true ]]; then
        echo -e "${YELLOW}Backup location: $BACKUP_DIR${NC}"
        echo -e "To restore: ${BLUE}cp -r $BACKUP_DIR/* ~/.config/${NC}"
        echo ""
    fi
    echo -e "Next steps:"
    echo -e "  1. Reload bash: ${BLUE}source ~/.bashrc${NC}"
    echo -e "  2. Reload i3: ${BLUE}Alt+Shift+r${NC}"
    echo -e "  3. Check polybar: ${BLUE}~/.config/polybar/launch.sh${NC}"
    echo -e "  4. Add wallpapers to: ${BLUE}~/.config/backgrounds/${NC}"
}

# ═══════════════════════════════════════════════════════════════════
# Main
# ═══════════════════════════════════════════════════════════════════

print_header

case "$1" in
    --list|-l)
        list_packages
        exit 0
        ;;
    --deps-only)
        install_deps_only
        exit 0
        ;;
    --clean)
        clean_and_relink
        exit 0
        ;;
    --apps-list)
        list_apps
        exit 0
        ;;
    --apps)
        shift
        if [[ $# -eq 0 ]]; then
            interactive_apps_menu
        elif [[ "$1" == "all" ]]; then
            echo -e "${BOLD}Installing all apps...${NC}"
            for app in "${APPS[@]}"; do
                install_app "${app%%|*}"
            done
        else
            for app in "$@"; do
                install_app "$app"
            done
        fi
        exit 0
        ;;
    --configs)
        shift
        if [[ $# -eq 0 ]] || [[ "$1" == "all" ]]; then
            echo -e "${BOLD}Installing all configs...${NC}"
            install_all
        else
            for pkg in "$@"; do
                install_package "$pkg"
            done
        fi
        print_completion
        exit 0
        ;;
    --aliases)
        echo -e "${BOLD}Installing bash aliases...${NC}"
        install_bash_aliases
        echo -e "${GREEN}[OK]${NC} Bash aliases installed"
        echo -e "${YELLOW}Run:${NC} source ~/.bashrc"
        exit 0
        ;;
    --everything)
        echo -e "${BOLD}Installing EVERYTHING (configs + apps + aliases)...${NC}"
        echo ""
        echo -e "${CYAN}═══ Phase 1: Configs ═══${NC}"
        install_all
        echo ""
        echo -e "${CYAN}═══ Phase 2: Apps ═══${NC}"
        for app in "${APPS[@]}"; do
            install_app "${app%%|*}"
        done
        echo ""
        echo -e "${CYAN}═══ Phase 3: Aliases ═══${NC}"
        install_bash_aliases
        print_completion
        exit 0
        ;;
    --help|-h)
        echo "Usage: $0 [OPTIONS] [PACKAGES...]"
        echo ""
        echo "Commands:"
        echo "  --configs [all|pkg...]  Install config symlinks (i3, polybar, etc.)"
        echo "  --apps [all|app...]     Install apps (vlc, lazygit, etc.)"
        echo "  --aliases               Install bash aliases only"
        echo "  --everything            Install configs + apps + aliases"
        echo ""
        echo "Options:"
        echo "  --list, -l              List available config packages"
        echo "  --apps-list             List available apps with install status"
        echo "  --deps-only             Only install APT dependencies"
        echo "  --clean                 Backup real dirs, remove symlinks"
        echo "  --help, -h              Show this help"
        echo ""
        echo "Examples:"
        echo "  $0 --configs all        Install all config symlinks"
        echo "  $0 --configs i3 polybar Install specific configs"
        echo "  $0 --apps               Interactive app picker"
        echo "  $0 --apps all           Install all apps"
        echo "  $0 --apps vlc lazygit   Install specific apps"
        echo "  $0 --everything         Full system setup"
        echo ""
        exit 0
        ;;
    all)
        # Legacy: same as --configs all
        install_all
        print_completion
        exit 0
        ;;
    "")
        interactive_menu
        print_completion
        exit 0
        ;;
    *)
        # Install specific packages passed as arguments (legacy)
        for pkg in "$@"; do
            install_package "$pkg"
        done
        print_completion
        exit 0
        ;;
esac
