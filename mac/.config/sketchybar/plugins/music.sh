#!/bin/bash

# Get currently playing track from Spotify
# Works with Spotify desktop app

PLAYING=""
ARTIST=""
TRACK=""

# Check if Spotify is running
if pgrep -x "Spotify" > /dev/null; then
    PLAYER_STATE=$(osascript -e 'tell application "Spotify" to player state as string' 2>/dev/null)
    
    if [[ "$PLAYER_STATE" == "playing" ]]; then
        TRACK=$(osascript -e 'tell application "Spotify" to name of current track as string' 2>/dev/null)
        ARTIST=$(osascript -e 'tell application "Spotify" to artist of current track as string' 2>/dev/null)
        
        # Truncate if too long
        if [ ${#TRACK} -gt 25 ]; then
            TRACK="${TRACK:0:22}..."
        fi
        if [ ${#ARTIST} -gt 15 ]; then
            ARTIST="${ARTIST:0:12}..."
        fi
        
        ICON=""
        LABEL="$TRACK - $ARTIST"
        COLOR="0xffa6e3a1"  # Green
    elif [[ "$PLAYER_STATE" == "paused" ]]; then
        ICON=""
        LABEL="Paused"
        COLOR="0xfff9e2af"  # Yellow
    else
        ICON=""
        LABEL=""
        COLOR="0xff6c7086"  # Gray
    fi
else
    # Spotify not running - check Apple Music
    if pgrep -x "Music" > /dev/null; then
        PLAYER_STATE=$(osascript -e 'tell application "Music" to player state as string' 2>/dev/null)
        
        if [[ "$PLAYER_STATE" == "playing" ]]; then
            TRACK=$(osascript -e 'tell application "Music" to name of current track as string' 2>/dev/null)
            ARTIST=$(osascript -e 'tell application "Music" to artist of current track as string' 2>/dev/null)
            
            if [ ${#TRACK} -gt 25 ]; then
                TRACK="${TRACK:0:22}..."
            fi
            if [ ${#ARTIST} -gt 15 ]; then
                ARTIST="${ARTIST:0:12}..."
            fi
            
            ICON=""
            LABEL="$TRACK - $ARTIST"
            COLOR="0xfff38ba8"  # Pink/Red for Apple Music
        elif [[ "$PLAYER_STATE" == "paused" ]]; then
            ICON=""
            LABEL="Paused"
            COLOR="0xfff9e2af"
        else
            ICON=""
            LABEL=""
            COLOR="0xff6c7086"
        fi
    else
        # No music player running
        ICON=""
        LABEL=""
        COLOR="0xff6c7086"
    fi
fi

sketchybar --set $NAME icon="$ICON" label="$LABEL" icon.color="$COLOR"
