#!/bin/bash

# Highlight active space
if [ "$SELECTED" = "true" ]; then
    sketchybar --set $NAME \
        background.drawing=on \
        icon.highlight=on
else
    sketchybar --set $NAME \
        background.drawing=off \
        icon.highlight=off
fi
