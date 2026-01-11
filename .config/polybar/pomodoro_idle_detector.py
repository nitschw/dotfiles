#!/usr/bin/env python3
import subprocess
import time
import os

STATE_FILE = "/tmp/polybar_pomodoro_state"
DISTRACTION_LOG = "/tmp/pomodoro_distractions.log"
IDLE_THRESHOLD = 60  # seconds
REMINDER_INTERVAL = 60 # seconds between reminders

PIDFILE = "/tmp/pomodoro_inactivity_monitor.pid"

# Prevent duplicate processes
if os.path.exists(PIDFILE):
    with open(PIDFILE, 'r') as f:
        try:
            pid = int(f.read().strip())
            os.kill(pid, 0)  # Check if process is alive
            sys.exit(0)      # Already running
        except:
            pass  # PID dead or invalid

# Write current PID
with open(PIDFILE, 'w') as f:
    f.write(str(os.getpid()))

subprocess.call(f'touch {STATE_FILE}', shell=True)
subprocess.call(f'touch {DISTRACTION_LOG}', shell=True)

print('touched files')

def get_idle_time_seconds():
    try:
        output = subprocess.check_output(['xprintidle']).decode().strip()
        return int(output) / 1000  # convert to seconds
    except Exception as e:
        print("Error getting idle time:", e)
        return 0

def is_timer_running():
    try:
        with open(STATE_FILE, 'r') as f:
            return f.read().strip() == "running"
    except:
        return False

def notify():
    subprocess.Popen(['notify-send', "💤 You seem idle", "No mouse or keyboard activity for 1 min"])
    subprocess.Popen(['paplay', '/usr/share/sounds/freedesktop/stereo/suspend-error.oga'])

last_reminder_time = 0

while True:
    time.sleep(1)

    if not is_timer_running():
        continue

    idle_seconds = get_idle_time_seconds()
    now = time.time()

    if idle_seconds > IDLE_THRESHOLD and now - last_reminder_time > REMINDER_INTERVAL:
        notify()
        with open(DISTRACTION_LOG, "a") as f:
            f.write(f"{time.ctime()}: System idle for {int(idle_seconds)}s\n")
        last_reminder_time = now

