#!/bin/bash
# ╔════════════════════════════════════════════════════════════════╗
# ║        Auto-detect monitors and assign workspaces              ║
# ╚════════════════════════════════════════════════════════════════╝
#
# Run this on login or when monitors change to update workspace assignments
# Usage: update-monitor-config.sh
#

CONFIG_FILE="$HOME/.config/aerospace/aerospace.toml"
MARKER_START="# AUTO-GENERATED-MONITOR-CONFIG-START"
MARKER_END="# AUTO-GENERATED-MONITOR-CONFIG-END"

# Get monitor count
MONITOR_COUNT=$(aerospace list-monitors 2>/dev/null | wc -l | tr -d ' ')

if [[ -z "$MONITOR_COUNT" ]] || [[ "$MONITOR_COUNT" -eq 0 ]]; then
    echo "Could not detect monitors, defaulting to 1"
    MONITOR_COUNT=1
fi

echo "Detected $MONITOR_COUNT monitor(s)"

# Generate workspace assignments based on monitor count
generate_config() {
    echo "$MARKER_START"
    echo "# Workspaces distributed across $MONITOR_COUNT monitor(s)"
    echo "[workspace-to-monitor-force-assignment]"
    
    case $MONITOR_COUNT in
        1)
            # All workspaces on main
            for i in {1..9}; do
                echo "$i = 'main'"
            done
            ;;
        2)
            # 1-5 main, 6-9 secondary
            for i in {1..5}; do
                echo "$i = 'main'"
            done
            for i in {6..9}; do
                echo "$i = ['secondary', 'main']"
            done
            ;;
        3)
            # 1-3 main, 4-6 secondary, 7-9 tertiary
            for i in {1..3}; do
                echo "$i = 'main'"
            done
            for i in {4..6}; do
                echo "$i = ['secondary', 'main']"
            done
            for i in {7..9}; do
                # AeroSpace uses monitor IDs, tertiary would be ID 3
                echo "$i = [3, 'secondary', 'main']"
            done
            ;;
        *)
            # 4+ monitors: distribute evenly, fallback chain
            local per_monitor=$((9 / MONITOR_COUNT))
            local workspace=1
            for ((m=1; m<=MONITOR_COUNT && workspace<=9; m++)); do
                local count=$per_monitor
                # Give extra workspaces to first monitors
                if [[ $m -le $((9 % MONITOR_COUNT)) ]]; then
                    ((count++))
                fi
                for ((w=0; w<count && workspace<=9; w++)); do
                    if [[ $m -eq 1 ]]; then
                        echo "$workspace = 'main'"
                    else
                        echo "$workspace = [$m, 'main']"
                    fi
                    ((workspace++))
                done
            done
            ;;
    esac
    
    echo "$MARKER_END"
}

# Check if config has our markers
if grep -q "$MARKER_START" "$CONFIG_FILE" 2>/dev/null; then
    # Replace existing auto-generated section
    # Create temp file with new config
    TEMP_FILE=$(mktemp)
    awk -v start="$MARKER_START" -v end="$MARKER_END" -v new="$(generate_config)" '
        $0 ~ start { skip=1; print new; next }
        $0 ~ end { skip=0; next }
        !skip { print }
    ' "$CONFIG_FILE" > "$TEMP_FILE"
    mv "$TEMP_FILE" "$CONFIG_FILE"
    echo "Updated monitor config in $CONFIG_FILE"
else
    echo ""
    echo "Add this to your aerospace.toml (or run with --append):"
    echo ""
    generate_config
fi

# Reload aerospace
aerospace reload-config 2>/dev/null && echo "Reloaded aerospace config"
