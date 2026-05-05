#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Git Status All
# @raycast.mode fullOutput
# @raycast.packageName Dev

# Optional parameters:
# @raycast.icon 📦
# @raycast.argument1 { "type": "text", "placeholder": "parent dir (default: ~/src)", "optional": true }

# Documentation:
# @raycast.description Check git status of all repos in a directory
# @raycast.author Your Name

parent_dir="${1:-$HOME/src}"

echo "Git status for repos in: $parent_dir"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

for dir in "$parent_dir"/*; do
    if [[ -d "$dir/.git" ]]; then
        name=$(basename "$dir")
        
        # Get status summary
        cd "$dir"
        branch=$(git branch --show-current 2>/dev/null)
        changes=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
        behind=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
        
        status=""
        [[ "$changes" -gt 0 ]] && status+="±$changes "
        [[ "$ahead" -gt 0 ]] && status+="↑$ahead "
        [[ "$behind" -gt 0 ]] && status+="↓$behind "
        [[ -z "$status" ]] && status="✓"
        
        printf "%-20s %-15s %s\n" "$name" "($branch)" "$status"
    fi
done
