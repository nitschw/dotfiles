#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Flush DNS
# @raycast.mode compact
# @raycast.packageName Network

# Optional parameters:
# @raycast.icon 🔄
# @raycast.needsConfirmation true

# Documentation:
# @raycast.description Flush DNS cache (requires password)
# @raycast.author Your Name

sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

echo "DNS cache flushed ✓"
