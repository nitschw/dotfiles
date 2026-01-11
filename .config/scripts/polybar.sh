#!/usr/bin/env bash

# Kill running polybar instances gracefully if IPC is enabled
polybar-msg cmd quit

# Wait until all polybar processes have shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.5; done

echo "--- Starting polybar on all monitors ---"

# Launch polybar on each connected monitor
for m in $(polybar --list-monitors | cut -d: -f1); do
  echo "▶️  Launching bar on $m"
  MONITOR=$m polybar example --config=~/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar-$m.log & disown
done

echo "✅ Bars launched..."

