#!/bin/bash

# AeroSpace workspace indicator for SketchyBar
# MONITOR is passed from sketchybarrc (1, 2, or 3)

BAR_DISPLAY="${MONITOR:-1}"

# Get workspaces currently visible/active on this monitor
# --monitor shows workspaces that are ON this monitor (not just assigned)
MONITOR_WORKSPACES=$(aerospace list-workspaces --monitor "$BAR_DISPLAY" 2>/dev/null)

# Get the globally focused workspace
FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)

# Build display string - show workspaces on this monitor
DISPLAY_STR=""
for ws in $MONITOR_WORKSPACES; do
    HAS_WINDOWS=$(aerospace list-windows --workspace "$ws" 2>/dev/null)
    
    if [ "$ws" = "$FOCUSED" ]; then
        # This is the globally focused workspace
        DISPLAY_STR="${DISPLAY_STR}●${ws} "
    elif [ -n "$HAS_WINDOWS" ]; then
        # Has windows but not focused
        DISPLAY_STR="${DISPLAY_STR}○${ws} "
    else
        # Empty workspace on this monitor
        DISPLAY_STR="${DISPLAY_STR}◌${ws} "
    fi
done

# If nothing to show, show the monitor's default workspace
if [ -z "$DISPLAY_STR" ]; then
    # Default: workspace number matches monitor number
    DEFAULT_WS="$BAR_DISPLAY"
    if [ "$DEFAULT_WS" = "$FOCUSED" ]; then
        DISPLAY_STR="●${DEFAULT_WS}"
    else
        DISPLAY_STR="○${DEFAULT_WS}"
    fi
fi

# Trim trailing space
DISPLAY_STR=$(echo "$DISPLAY_STR" | sed 's/ $//')

sketchybar --set "$NAME" label="$DISPLAY_STR"
