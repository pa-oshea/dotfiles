#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# # Launch the bar
# polybar -q main -c "$DIR"/config.ini &

# Check monitors https://github.com/polybar/polybar/issues/763
for m in $(polybar --list-monitors | cut -d":" -f1); do
	MONITOR=$m polybar -q main -c "$DIR"/config.ini &
done
