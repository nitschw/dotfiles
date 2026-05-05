#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title IP Addresses
# @raycast.mode compact
# @raycast.packageName Network

# Optional parameters:
# @raycast.icon 🌐

# Documentation:
# @raycast.description Show local and public IP addresses
# @raycast.author Your Name

local_ip=$(ipconfig getifaddr en0 2>/dev/null || echo "Not connected")
public_ip=$(curl -s --max-time 2 ifconfig.me || echo "Unavailable")

echo "Local: $local_ip | Public: $public_ip"
