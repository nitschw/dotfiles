# ╔════════════════════════════════════════════════════════════════╗
# ║                    Custom Bash Aliases                         ║
# ║          Sourced from dotfiles - add your aliases here         ║
# ╚════════════════════════════════════════════════════════════════╝

# Dotfiles location (change this if you clone to a different path)
export DOTFILES="${DOTFILES:-$HOME/dotfiles}"

# Add ~/.local/bin to PATH (for user-installed binaries)
[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"

# ─────────────────────────────────────────────────────────────────
# SSH - Fix terminal colors when connecting to remote hosts
# ─────────────────────────────────────────────────────────────────
alias ssh='TERM=xterm-256color ssh'

# ─────────────────────────────────────────────────────────────────
# NoMachine - Quick launch for remote desktop
# ─────────────────────────────────────────────────────────────────
alias nomachine='/usr/NX/bin/nxplayer'

# ─────────────────────────────────────────────────────────────────
# ls improvements
# ─────────────────────────────────────────────────────────────────
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls --color=auto'

# ─────────────────────────────────────────────────────────────────
# grep with color
# ─────────────────────────────────────────────────────────────────
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ─────────────────────────────────────────────────────────────────
# Navigation shortcuts
# ─────────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ─────────────────────────────────────────────────────────────────
# Safety nets
# ─────────────────────────────────────────────────────────────────
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ─────────────────────────────────────────────────────────────────
# System shortcuts
# ─────────────────────────────────────────────────────────────────
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias keybinds='~/.config/scripts/keybinds.sh'
alias dotfiles='cd $DOTFILES'

# Conditional aliases - only set if the tool is installed
# Modern replacements
command -v nvim &>/dev/null && alias vim='nvim' && alias vi='nvim'
command -v batcat &>/dev/null && alias bat='batcat' && alias cat='batcat --paging=never'
command -v fdfind &>/dev/null && alias fd='fdfind'
command -v eza &>/dev/null && alias ls='eza --color=auto --icons' && alias ll='eza -la --icons' && alias la='eza -a --icons' && alias lt='eza --tree --level=2'
command -v duf &>/dev/null && alias df='duf -hide special,loops'
command -v dust &>/dev/null && alias du='dust'
command -v procs &>/dev/null && alias ps='procs'
command -v trash-put &>/dev/null && alias rm='trash-put' && alias trash='trash-list' && alias restore='trash-restore'

# Quick launchers
command -v fastfetch &>/dev/null && alias ff='fastfetch'
command -v lazygit &>/dev/null && alias lg='lazygit'
command -v lazydocker &>/dev/null && alias lzd='lazydocker'
command -v ncdu &>/dev/null && alias diskuse='ncdu'
command -v baobab &>/dev/null && alias diskgui='baobab'
command -v ranger &>/dev/null && alias r='ranger'
command -v nnn &>/dev/null && alias n='nnn -de'
command -v tldr &>/dev/null && alias help='tldr'
command -v flameshot &>/dev/null && alias screenshot='flameshot gui'
command -v peek &>/dev/null && alias gif='peek'
command -v obs &>/dev/null && alias record='obs'

# Network tools
command -v speedtest-cli &>/dev/null && alias speedtest='speedtest-cli'
command -v nload &>/dev/null && alias netmon='nload'
command -v iftop &>/dev/null && alias netstat='sudo iftop'
command -v nethogs &>/dev/null && alias netprocs='sudo nethogs'

# Dev tools
command -v gh &>/dev/null && alias ghpr='gh pr create' && alias ghprs='gh pr list'
command -v glab &>/dev/null && alias glmr='glab mr create' && alias glmrs='glab mr list' && alias glci='glab ci status'
command -v delta &>/dev/null && alias diff='delta'
command -v shellcheck &>/dev/null && alias sc='shellcheck'
command -v direnv &>/dev/null && eval "$(direnv hook bash)"

# Shell enhancements
command -v zoxide &>/dev/null && eval "$(zoxide init bash)"
command -v fzf &>/dev/null && eval "$(fzf --bash 2>/dev/null)" # Ctrl+R fuzzy history

# ─────────────────────────────────────────────────────────────────
# i3 shortcuts
# ─────────────────────────────────────────────────────────────────
alias i3config='$EDITOR ~/.config/i3/config'
alias i3reload='i3-msg reload'
alias i3restart='i3-msg restart'

# ─────────────────────────────────────────────────────────────────
# Wallpaper
# ─────────────────────────────────────────────────────────────────
# Usage: update_bg image.jpg (from ~/.config/backgrounds)
update_bg() {
    local bg_dir="$HOME/.config/backgrounds"
    if [[ -z "$1" ]]; then
        echo "Usage: update_bg <image_name>"
        echo "Available wallpapers:"
        ls -1 "$bg_dir" | grep -v '^wallpaper.jpg$'
        return 1
    fi
    if [[ -f "$bg_dir/$1" ]]; then
        ln -sf "$1" "$bg_dir/wallpaper.jpg"
        feh --bg-fill "$bg_dir/wallpaper.jpg"
        echo "Wallpaper set to: $1"
    else
        echo "Error: $1 not found in $bg_dir"
        ls -1 "$bg_dir" | grep -v '^wallpaper.jpg$'
        return 1
    fi
}

# ─────────────────────────────────────────────────────────────────
# Quick edits
# ─────────────────────────────────────────────────────────────────
alias bashrc='$EDITOR ~/.bashrc && source ~/.bashrc'
alias aliases='$EDITOR ~/.bash_aliases && source ~/.bash_aliases'

# ─────────────────────────────────────────────────────────────────
# Git shortcuts
# ─────────────────────────────────────────────────────────────────
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -10'
alias gd='git diff'

# ─────────────────────────────────────────────────────────────────
# Add your own aliases below
# ─────────────────────────────────────────────────────────────────

