#!/usr/bin/env bash

STATE_FILE="/tmp/polybar_pomodoro_state"       # running, paused, break
TIME_FILE="/tmp/polybar_pomodoro_time"
BREAK_START_FILE="/tmp/polybar_pomodoro_break_start"
NOTIFY_COUNT_FILE="/tmp/polybar_pomodoro_notify_count"
DURATION=1500  # Pomodoro: 25 min
BREAK_GRACE=300  # Break before reminders: 5 min
MAX_REMINDERS=5

start_timer() {
    notify-send "🍅 Pomodoro Started" "25 minutes of focus time!" -i clock
    paplay /usr/share/sounds/freedesktop/stereo/service-login.oga

    echo "running" > "$STATE_FILE"
    echo 0 > "$NOTIFY_COUNT_FILE"

    # 🧠 Launch the idle monitor if not already running
    if ! pgrep -f pomodoro_inactivity_monitor.py >/dev/null; then
        setsid /usr/bin/python3 ~/.config/polybar/pomodoro_idle_detector.py >> ~/.pomodoro_idle.log 2>&1 &
    fi


    for ((i=DURATION; i>=0; i--)); do
        [[ "$(cat "$STATE_FILE" 2>/dev/null)" != "running" ]] && break
        printf "🍅 %02d:%02d\n" $((i/60)) $((i%60)) > "$TIME_FILE"
        sleep 1
    done

    if [[ "$(cat "$STATE_FILE" 2>/dev/null)" == "running" ]]; then
        echo "break" > "$STATE_FILE"
        date +%s > "$BREAK_START_FILE"
        echo 0 > "$NOTIFY_COUNT_FILE"
        echo "🧘 Break" > "$TIME_FILE"
    fi
}

send_break_reminder() {
    count=$(cat "$NOTIFY_COUNT_FILE" 2>/dev/null || echo 0)
    if [[ "$count" -lt $MAX_REMINDERS ]]; then
        notify-send "⏳ Break Over?" "Click 🍅 to start the next session" -i face-cool
        paplay /usr/share/sounds/freedesktop/stereo/suspend-error.oga
        echo $((count + 1)) > "$NOTIFY_COUNT_FILE"
    fi
}

print_status() {
    state=$(cat "$STATE_FILE" 2>/dev/null)
    case "$state" in
        running)
            cat "$TIME_FILE" 2>/dev/null || echo "🍅 25:00"
            ;;
        break)
            if [[ -f "$BREAK_START_FILE" ]]; then
                now=$(date +%s)
                start=$(cat "$BREAK_START_FILE")
                elapsed=$((now - start))
                printf "🧘 Break %02d:%02d\n" $((elapsed/60)) $((elapsed%60))

                if (( elapsed > BREAK_GRACE && elapsed % 60 == 0 )); then
                    send_break_reminder
                fi
            else
                echo "🧘 Break"
            fi
            ;;
        *)
            echo "🍅 Ready"
            ;;
    esac
}

case "$1" in
    toggle)
        state=$(cat "$STATE_FILE" 2>/dev/null)
        if [[ "$state" == "running" ]]; then
            echo "paused" > "$STATE_FILE"
        else
            start_timer &
        fi
        ;;
    reset)
        echo "🍅 Ready" > "$TIME_FILE"
        echo "paused" > "$STATE_FILE"
        rm -f "$BREAK_START_FILE" "$NOTIFY_COUNT_FILE"
        ;;
    print)
        print_status
        ;;
    *)
        echo "Usage: $0 [toggle|reset|print]"
        ;;
esac

