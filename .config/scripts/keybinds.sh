#!/bin/bash
#
# Keybindings Cheat Sheet Generator
# Pulls keybindings directly from config files
#

# Colors
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

# Config paths
I3_CONFIG="$HOME/.config/i3/config"
KITTY_CONFIG="$HOME/.config/kitty/kitty.conf"

echo -e "${BOLD}${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║              ⌨️  Keybindings Cheat Sheet                    ║${NC}"
echo -e "${BOLD}${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# ─────────────────────────────────────────────────────────────────
# i3 Keybindings
# ─────────────────────────────────────────────────────────────────
if [[ -f "$I3_CONFIG" ]]; then
    echo -e "${BOLD}${MAGENTA}━━━ i3 Window Manager ━━━${NC}"
    echo -e "${YELLOW}Mod key: Alt${NC}"
    echo ""
    
    # Extract bindsym lines, clean them up
    grep -E "^bindsym" "$I3_CONFIG" | while read -r line; do
        # Skip mode-specific bindings (inside resize mode etc)
        # Parse: bindsym $mod+Return exec kitty
        key=$(echo "$line" | sed 's/bindsym //' | awk '{print $1}')
        action=$(echo "$line" | sed 's/bindsym [^ ]* //' | sed 's/exec --no-startup-id //' | sed 's/exec //')
        
        # Make key more readable
        key=$(echo "$key" | sed 's/\$mod/Alt/g' | sed 's/+/ + /g')
        
        # Truncate long actions
        if [[ ${#action} -gt 50 ]]; then
            action="${action:0:47}..."
        fi
        
        printf "  ${GREEN}%-25s${NC} %s\n" "$key" "$action"
    done
    
    echo ""
    
    # Resize mode
    echo -e "${YELLOW}Resize Mode (Alt + r):${NC}"
    echo -e "  ${GREEN}j / ←${NC}                     Shrink width"
    echo -e "  ${GREEN}; / →${NC}                     Grow width"
    echo -e "  ${GREEN}k / ↓${NC}                     Grow height"
    echo -e "  ${GREEN}l / ↑${NC}                     Shrink height"
    echo -e "  ${GREEN}Enter / Escape${NC}            Exit resize mode"
    echo ""
fi

# ─────────────────────────────────────────────────────────────────
# Kitty Keybindings (if any custom ones defined)
# ─────────────────────────────────────────────────────────────────
if [[ -f "$KITTY_CONFIG" ]]; then
    KITTY_BINDS=$(grep -E "^map " "$KITTY_CONFIG" 2>/dev/null)
    if [[ -n "$KITTY_BINDS" ]]; then
        echo -e "${BOLD}${MAGENTA}━━━ Kitty Terminal ━━━${NC}"
        echo ""
        echo "$KITTY_BINDS" | while read -r line; do
            key=$(echo "$line" | awk '{print $2}')
            action=$(echo "$line" | cut -d' ' -f3-)
            printf "  ${GREEN}%-25s${NC} %s\n" "$key" "$action"
        done
        echo ""
    fi
fi

# ─────────────────────────────────────────────────────────────────
# Neovim Keybindings
# ─────────────────────────────────────────────────────────────────
NVIM_CONFIG="$HOME/.config/nvim/init.vim"
NVIM_LUA="$HOME/.config/nvim/init.lua"

echo -e "${BOLD}${MAGENTA}━━━ Neovim ━━━${NC}"
echo ""

# Check for custom mappings in init.vim
if [[ -f "$NVIM_CONFIG" ]]; then
    NVIM_MAPS=$(grep -E "^(nmap|nnoremap|vnoremap|inoremap|map )" "$NVIM_CONFIG" 2>/dev/null)
    if [[ -n "$NVIM_MAPS" ]]; then
        echo -e "${YELLOW}Custom mappings:${NC}"
        echo "$NVIM_MAPS" | while read -r line; do
            printf "  ${GREEN}%s${NC}\n" "$line"
        done
        echo ""
    fi
    
    # Show autocmds for format on save
    echo -e "${YELLOW}Auto-format on save:${NC}"
    grep -E "^autocmd BufWrite" "$NVIM_CONFIG" 2>/dev/null | while read -r line; do
        filetype=$(echo "$line" | grep -oP '\*\.\w+' | head -1)
        action=$(echo "$line" | sed 's/autocmd BufWrite[^ ]* [^ ]* //')
        printf "  ${GREEN}%-10s${NC} %s\n" "$filetype" "$action"
    done
    echo ""
fi

# Essential vim keybindings reference
echo -e "${YELLOW}Essential Vim Keys:${NC}"
echo -e "  ${GREEN}i / a / o${NC}               Insert / Append / Open line"
echo -e "  ${GREEN}Esc${NC}                     Normal mode"
echo -e "  ${GREEN}:w / :q / :wq${NC}           Save / Quit / Save+Quit"
echo -e "  ${GREEN}dd / yy / p${NC}             Delete / Yank / Paste line"
echo -e "  ${GREEN}u / Ctrl+r${NC}              Undo / Redo"
echo -e "  ${GREEN}/ / n / N${NC}               Search / Next / Previous"
echo -e "  ${GREEN}gg / G${NC}                  Go to start / end"
echo -e "  ${GREEN}ciw / diw${NC}               Change / Delete inner word"
echo -e "  ${GREEN}v / V / Ctrl+v${NC}          Visual / Line / Block select"
echo ""
echo -e "${YELLOW}Plugins:${NC}"
echo -e "  ${GREEN}:NERDTree${NC}               File explorer (auto-opens)"
echo -e "  ${GREEN}Tab${NC}                     Trigger COC completion"
echo -e "  ${GREEN}:ClangFormat${NC}            Format C/C++ code"
echo ""

# ─────────────────────────────────────────────────────────────────
# Bash Aliases
# ─────────────────────────────────────────────────────────────────
BASH_ALIASES="$HOME/.bash_aliases"
if [[ -f "$BASH_ALIASES" ]]; then
    echo -e "${BOLD}${MAGENTA}━━━ Bash Aliases ━━━${NC}"
    echo ""
    grep -E "^alias " "$BASH_ALIASES" | while read -r line; do
        # Parse: alias ll='ls -alF'
        alias_name=$(echo "$line" | sed "s/alias //" | cut -d'=' -f1)
        alias_cmd=$(echo "$line" | cut -d'=' -f2- | tr -d "'\"")
        
        # Truncate long commands
        if [[ ${#alias_cmd} -gt 45 ]]; then
            alias_cmd="${alias_cmd:0:42}..."
        fi
        
        printf "  ${GREEN}%-20s${NC} → %s\n" "$alias_name" "$alias_cmd"
    done
    echo ""
fi

# ─────────────────────────────────────────────────────────────────
# Quick Reference
# ─────────────────────────────────────────────────────────────────
echo -e "${BOLD}${MAGENTA}━━━ Quick Reference ━━━${NC}"
echo ""
echo -e "  ${GREEN}Alt + Return${NC}            Open terminal (kitty)"
echo -e "  ${GREEN}Alt + d${NC}                 dmenu launcher"
echo -e "  ${GREEN}Alt + Shift + d${NC}         rofi launcher"
echo -e "  ${GREEN}Alt + Shift + q${NC}         Kill window"
echo -e "  ${GREEN}Alt + 1-0${NC}               Switch workspace"
echo -e "  ${GREEN}Alt + Shift + 1-0${NC}       Move to workspace"
echo -e "  ${GREEN}Alt + f${NC}                 Fullscreen"
echo -e "  ${GREEN}Alt + Shift + Space${NC}     Toggle floating"
echo -e "  ${GREEN}Alt + Shift + r${NC}         Restart i3"
echo -e "  ${GREEN}Print${NC}                   Screenshot (full)"
echo -e "  ${GREEN}Shift + Print${NC}           Screenshot (selection)"
echo -e "  ${GREEN}Ctrl + Print${NC}            Screenshot to clipboard"
echo ""
