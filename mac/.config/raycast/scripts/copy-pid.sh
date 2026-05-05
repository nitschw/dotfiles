#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Copy PID
# @raycast.mode compact
# @raycast.packageName System

# Optional parameters:
# @raycast.icon 📋
# @raycast.argument1 { "type": "text", "placeholder": "process name", "optional": false }

# Documentation:
# @raycast.description Find process and copy PID to clipboard
# @raycast.author Your Name

process_name="$1"

# Find the first matching PID
pid=$(pgrep -i "$process_name" | head -1)

if [[ -z "$pid" ]]; then
    echo "No process found: $process_name"
    exit 1
fi

# Copy to clipboard
echo -n "$pid" | pbcopy

# Get process name for confirmation
proc_name=$(ps -p "$pid" -o comm= 2>/dev/null)
echo "Copied PID $pid ($proc_name)"
