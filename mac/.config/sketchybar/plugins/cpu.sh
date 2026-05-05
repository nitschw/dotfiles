#!/bin/bash

# Get CPU usage percentage
CPU=$(ps -A -o %cpu | awk '{s+=$1} END {print int(s)}')

# Cap at 100% per core (M4 Max has many cores)
CORES=$(sysctl -n hw.ncpu)
MAX=$((CORES * 100))
if [ "$CPU" -gt "$MAX" ]; then
    CPU=$MAX
fi

# Show as percentage of total capacity
PERCENT=$((CPU / CORES))

sketchybar --set $NAME label="${PERCENT}%"
