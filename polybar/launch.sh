#!/usr/bin/env bash

# Define the configuration directory
CONFIG_DIR="$HOME/.config/polybar"

# Terminate already running instances of Polybar
killall -q polybar

# Wait until all Polybar processes have been shut down
while pgrep -u "$UID" -x polybar >/dev/null; do sleep 1; done

# Launch Polybar on all connected monitors
# This checks for monitors and launches a separate instance of Polybar for each
for monitor in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR="$monitor" polybar -q main -c "$CONFIG_DIR/config.ini" &
done
