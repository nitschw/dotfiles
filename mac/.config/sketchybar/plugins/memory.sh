#!/bin/bash

# Get memory usage
MEMORY=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{print 100 - $5}' | tr -d '%')

# Fallback if memory_pressure doesn't work
if [ -z "$MEMORY" ]; then
    # Use vm_stat
    PAGES_FREE=$(vm_stat | grep "Pages free" | awk '{print $3}' | tr -d '.')
    PAGES_ACTIVE=$(vm_stat | grep "Pages active" | awk '{print $3}' | tr -d '.')
    PAGES_INACTIVE=$(vm_stat | grep "Pages inactive" | awk '{print $3}' | tr -d '.')
    PAGES_WIRED=$(vm_stat | grep "Pages wired" | awk '{print $4}' | tr -d '.')
    PAGES_COMPRESSED=$(vm_stat | grep "Pages occupied by compressor" | awk '{print $5}' | tr -d '.')
    
    TOTAL=$((PAGES_FREE + PAGES_ACTIVE + PAGES_INACTIVE + PAGES_WIRED + PAGES_COMPRESSED))
    USED=$((PAGES_ACTIVE + PAGES_WIRED + PAGES_COMPRESSED))
    MEMORY=$((USED * 100 / TOTAL))
fi

sketchybar --set $NAME label="${MEMORY}%"
