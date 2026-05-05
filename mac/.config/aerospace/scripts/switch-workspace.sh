#!/bin/bash
# Switch to workspace and ensure it appears on the CURRENT monitor

WORKSPACE="$1"

# Get the currently focused monitor BEFORE switching
CURRENT_MONITOR=$(aerospace list-monitors --focused 2>/dev/null | cut -d'|' -f1 | tr -d ' ')

# Switch to the workspace
aerospace workspace "$WORKSPACE"

# Move the workspace to the monitor we were on
# This only matters for newly created workspaces
aerospace move-workspace-to-monitor "$CURRENT_MONITOR" 2>/dev/null
