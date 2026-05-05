#!/bin/bash
# Get front app name (use the actual app name, not process name)
APP_NAME=$(osascript -e 'tell application "System Events" to get displayed name of first application process whose frontmost is true' 2>/dev/null)

# Fallback to process name if displayed name fails
if [ -z "$APP_NAME" ]; then
    APP_NAME=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
fi

# Map common process names to friendly names
case "$APP_NAME" in
    "Electron") APP_NAME="VS Code" ;;
    "Code Helper"*) APP_NAME="VS Code" ;;
    "Code") APP_NAME="VS Code" ;;
    "iTerm2") APP_NAME="iTerm" ;;
    "Google Chrome Helper"*) APP_NAME="Chrome" ;;
    "Safari Web Content") APP_NAME="Safari" ;;
    "Finder") APP_NAME="Finder" ;;
esac

# Truncate if too long
if [ ${#APP_NAME} -gt 25 ]; then
    APP_NAME="${APP_NAME:0:22}..."
fi

sketchybar --set $NAME label="$APP_NAME"
