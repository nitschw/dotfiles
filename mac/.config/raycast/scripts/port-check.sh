#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Port Check
# @raycast.mode fullOutput
# @raycast.packageName Network

# Optional parameters:
# @raycast.icon 🔌
# @raycast.argument1 { "type": "text", "placeholder": "port number", "optional": true }

# Documentation:
# @raycast.description Show what's listening on a port (or all ports)
# @raycast.author Your Name

port="$1"

if [[ -n "$port" ]]; then
    echo "Processes on port $port:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━"
    lsof -i ":$port" 2>/dev/null || echo "Nothing listening on port $port"
else
    echo "Listening ports:"
    echo "━━━━━━━━━━━━━━━━"
    lsof -iTCP -sTCP:LISTEN -P 2>/dev/null | awk 'NR==1 || NR>1 {print $1, $2, $9}' | column -t | head -20
fi
