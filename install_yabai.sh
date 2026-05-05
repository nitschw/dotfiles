#!/bin/bash

echo "Installing yabai + skhd configuration..."

# Install if not already installed
if ! command -v yabai &> /dev/null; then
    echo "Installing yabai..."
    brew install koekeishiya/formulae/yabai
fi

if ! command -v skhd &> /dev/null; then
    echo "Installing skhd..."
    brew install koekeishiya/formulae/skhd
fi

# Link configs
echo "Linking configurations..."
chmod +x ~/src/dotfiles/mac/.config/yabai/yabairc
ln -sf ~/src/dotfiles/mac/.config/yabai/yabairc ~/.yabairc
ln -sf ~/src/dotfiles/mac/.config/skhd/skhdrc.yabai ~/.skhdrc

# Start services
echo "Starting services..."
yabai --start-service
skhd --start-service

echo ""
echo "✓ yabai + skhd installed!"
echo ""
echo "IMPORTANT: Grant Accessibility permissions:"
echo "  System Settings → Privacy & Security → Accessibility"
echo "  Add: /opt/homebrew/bin/yabai"
echo "  Add: /opt/homebrew/bin/skhd"
echo ""
echo "Keybindings (matching your i3 config):"
echo "  Alt + Enter       - Terminal"
echo "  Alt + d           - Launcher"
echo "  Alt + Shift + q   - Close window"
echo "  Alt + f           - Fullscreen"
echo "  Alt + j/k/l/;     - Focus windows"
echo "  Alt + Shift + j/k/l/; - Move windows"
echo "  Alt + 1-9         - Switch workspace"
echo "  Alt + Shift + 1-9 - Move to workspace"
echo "  Alt + r           - Resize mode"
echo "  Alt + Shift + c   - Reload config"
