#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title List Processes
# @raycast.mode fullOutput
# @raycast.packageName System

# Optional parameters:
# @raycast.icon 📊
# @raycast.argument1 { "type": "text", "placeholder": "filter (optional)", "optional": true }

# Documentation:
# @raycast.description List top processes by CPU/memory, optionally filtered
# @raycast.author Your Name

filter="$1"

echo "Top Processes by CPU:"
echo "━━━━━━━━━━━━━━━━━━━━━"

if [[ -n "$filter" ]]; then
    ps aux | head -1
    ps aux | grep -i "$filter" | grep -v grep | sort -k3 -rn | head -10
else
    ps aux | head -1
    ps aux | sort -k3 -rn | head -10
fi

echo ""
echo "Top by Memory:"
echo "━━━━━━━━━━━━━━"

if [[ -n "$filter" ]]; then
    ps aux | grep -i "$filter" | grep -v grep | sort -k4 -rn | head -5
else
    ps aux | sort -k4 -rn | head -5
fi
