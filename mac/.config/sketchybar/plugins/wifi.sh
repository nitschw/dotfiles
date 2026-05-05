#!/bin/bash

# Check if we have an IP (means we're connected to some network)
IP=$(ipconfig getifaddr en0 2>/dev/null)

if [ -z "$IP" ]; then
    ICON="󰖪"
    LABEL="Offline"
else
    ICON="󰖩"
    LABEL="WiFi"
fi

sketchybar --set $NAME icon="$ICON" label="$LABEL"
