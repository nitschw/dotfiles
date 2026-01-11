#!/usr/bin/env bash
#polybar-msg cmd quit
#polybar main 2>&1 & disown
#polybar main --config=~/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar.log & disown


# Kill existing bars
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.2; done

# Launch on each connected monitor
for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload main --config=~/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar-$m.log & disown &
done

