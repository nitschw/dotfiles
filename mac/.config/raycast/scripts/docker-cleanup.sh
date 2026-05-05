#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Docker Cleanup
# @raycast.mode fullOutput
# @raycast.packageName Dev

# Optional parameters:
# @raycast.icon 🐳
# @raycast.needsConfirmation true

# Documentation:
# @raycast.description Remove stopped containers, dangling images, unused networks
# @raycast.author Your Name

echo "Docker Cleanup"
echo "━━━━━━━━━━━━━━"

echo ""
echo "Removing stopped containers..."
docker container prune -f

echo ""
echo "Removing dangling images..."
docker image prune -f

echo ""
echo "Removing unused networks..."
docker network prune -f

echo ""
echo "Space reclaimed ✓"
docker system df
