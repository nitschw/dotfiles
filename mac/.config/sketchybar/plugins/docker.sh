#!/bin/bash

# Check if Docker is running
if pgrep -x "Docker" > /dev/null; then
    # Get running container count
    CONTAINERS=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')
    if [ "$CONTAINERS" -gt 0 ]; then
        ICON="󰡨"
        LABEL="$CONTAINERS"
        COLOR="0xffa6e3a1"  # Green
    else
        ICON="󰡨"
        LABEL="0"
        COLOR="0xff6c7086"  # Gray
    fi
else
    ICON="󰡨"
    LABEL="Off"
    COLOR="0xfff38ba8"  # Red
fi

sketchybar --set $NAME icon="$ICON" label="$LABEL" icon.color="$COLOR"
