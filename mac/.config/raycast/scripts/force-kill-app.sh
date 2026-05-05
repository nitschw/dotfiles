#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Force Kill App
# @raycast.mode compact
# @raycast.packageName System

# Optional parameters:
# @raycast.icon ☠️
# @raycast.argument1 { "type": "text", "placeholder": "app name", "optional": false }

# Documentation:
# @raycast.description Force quit a macOS application
# @raycast.author Your Name

app_name="$1"

# Try to quit gracefully first, then force
if osascript -e "tell application \"$app_name\" to quit" 2>/dev/null; then
    echo "Quit: $app_name"
else
    # Force kill by process name
    pkill -9 -i "$app_name" && echo "Force killed: $app_name" || echo "Not found: $app_name"
fi
