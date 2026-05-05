#!/bin/bash

# Cleanup empty workspaces (except one per monitor)
# Called after workspace changes

# Get all monitors
MONITORS=$(aerospace list-monitors 2>/dev/null | cut -d'|' -f1 | tr -d ' ')

for monitor in $MONITORS; do
    # Get workspaces on this monitor
    WORKSPACES=$(aerospace list-workspaces --monitor "$monitor" 2>/dev/null)
    WS_COUNT=$(echo "$WORKSPACES" | wc -l | tr -d ' ')
    
    # If only one workspace, skip (keep at least one per monitor)
    [ "$WS_COUNT" -le 1 ] && continue
    
    # Check each workspace for windows
    for ws in $WORKSPACES; do
        # Skip the currently focused workspace
        FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
        [ "$ws" = "$FOCUSED" ] && continue
        
        # Check if workspace has any windows
        WINDOWS=$(aerospace list-windows --workspace "$ws" 2>/dev/null)
        
        # If empty and not the only one, we can't "close" it but it will
        # naturally disappear when another workspace takes over
        # AeroSpace doesn't have explicit workspace deletion
    done
done

# Note: AeroSpace workspaces are virtual - they exist when referenced
# and effectively "disappear" when empty and not focused.
# This script is a placeholder for future cleanup logic if needed.
