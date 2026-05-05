#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Kill Process
# @raycast.mode fullOutput
# @raycast.packageName System

# Optional parameters:
# @raycast.icon 💀
# @raycast.argument1 { "type": "text", "placeholder": "process name", "optional": false }

# Documentation:
# @raycast.description Kill a process by name (fuzzy match)
# @raycast.author Your Name

process_name="$1"

# Find matching processes (exclude grep itself)
matches=$(ps aux | grep -i "$process_name" | grep -v grep | grep -v "kill-process.sh")

if [[ -z "$matches" ]]; then
    echo "No processes found matching: $process_name"
    exit 0
fi

echo "Found processes:"
echo "$matches" | awk '{print $2, $11}' | head -10
echo ""

# Kill all matching processes
pids=$(echo "$matches" | awk '{print $2}')
for pid in $pids; do
    if kill "$pid" 2>/dev/null; then
        echo "✓ Killed PID $pid"
    else
        echo "✗ Failed to kill PID $pid (may need sudo)"
    fi
done
