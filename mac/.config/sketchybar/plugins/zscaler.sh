#!/bin/bash

# Check if Zscaler is running and connected
if pgrep -x "Zscaler" > /dev/null || pgrep -f "ZscalerTunnel" > /dev/null; then
    # Check if tunnel is active by looking for the process
    if pgrep -f "ZscalerTunnel" > /dev/null; then
        ICON="󰒃"
        LABEL="ZS"
        COLOR="0xffa6e3a1"  # Green - connected
    else
        ICON="󰒄"
        LABEL="ZS"
        COLOR="0xfff9e2af"  # Yellow - running but not tunneled
    fi
else
    ICON="󰦞"
    LABEL="ZS"
    COLOR="0xff6c7086"  # Gray - not running
fi

sketchybar --set $NAME icon="$ICON" label="$LABEL" icon.color="$COLOR"
