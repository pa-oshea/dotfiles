#!/bin/bash
# Smart status script with pretty dividers and client prefix
# Place at ~/.local/bin/tmux-smart-status.sh

info=""
divider="#[fg=#45475a] │ "

# Git info (only if in repo)
if git rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
      status="⚡"
    else
      status="✓"
    fi
    info="$info#[fg=#a6e3a1]$status$branch"
  fi
fi

# Docker containers running (only if any)
if command -v docker >/dev/null 2>&1; then
  containers=$(docker ps -q 2>/dev/null | wc -l)
  if [ "$containers" -gt 0 ]; then
    [ -n "$info" ] && info="$info$divider"
    info="$info#[fg=#89dceb]🐳$containers"
  fi
fi

# Background jobs (only if any)
jobs=$(jobs -r 2>/dev/null | wc -l)
if [ "$jobs" -gt 0 ]; then
  [ -n "$info" ] && info="$info$divider"
  info="$info#[fg=#f9e2af]⚙$jobs"
fi

# Kubernetes context (only if kubectl available and context set)
if command -v kubectl >/dev/null 2>&1; then
  k8s_context=$(kubectl config current-context 2>/dev/null | cut -d'/' -f1)
  if [ -n "$k8s_context" ] && [ "$k8s_context" != "docker-desktop" ]; then
    [ -n "$info" ] && info="$info$divider"
    info="$info#[fg=#cba6f7]⎈$k8s_context"
  fi
fi

# Virtual environment (Python/Node)
if [ -n "$VIRTUAL_ENV" ]; then
  venv_name=$(basename "$VIRTUAL_ENV")
  [ -n "$info" ] && info="$info$divider"
  info="$info#[fg=#f2cdcd]🐍$venv_name"
elif [ -n "$NODE_ENV" ] && [ "$NODE_ENV" != "production" ]; then
  [ -n "$info" ] && info="$info$divider"
  info="$info#[fg=#a6e3a1]⬢$NODE_ENV"
fi

# Load average (only if high relative to CPU cores)
if command -v uptime >/dev/null 2>&1; then
  load=$(uptime | awk -F'load average:' '{ print $2 }' | awk '{ print $1 }' | sed 's/,//')
  cpu_cores=$(nproc 2>/dev/null || echo "1")
  # Show if load is > 75% of available cores (adjust 0.75 threshold as needed)
  threshold=$(echo "$cpu_cores * 0.75" | bc -l 2>/dev/null)
  if [ -n "$load" ] && [ -n "$threshold" ] && [ "$(echo "$load > $threshold" | bc -l 2>/dev/null)" = "1" ]; then
    [ -n "$info" ] && info="$info$divider"
    info="$info#[fg=#fab387]📊$load"
  fi
fi

# Battery (only if laptop and low)
for bat in /sys/class/power_supply/BAT*/capacity; do
  if [ -f "$bat" ]; then
    battery=$(cat "$bat" 2>/dev/null)
    if [ -n "$battery" ] && [ "$battery" -lt 20 ]; then
      [ -n "$info" ] && info="$info$divider"
      info="$info#[fg=#f38ba8]🔋$battery%"
    fi
    break # Only check first battery found
  fi
done

# Add session name with client prefix indicator
session_name=$(tmux display-message -p '#S')
client_prefix=$(tmux display-message -p '#{?client_prefix,1,0}')

if [ -n "$info" ]; then
  info="$info$divider"
fi

if [ "$client_prefix" = "1" ]; then
  info="$info#[fg=#f38ba8]$session_name"
else
  info="$info#[fg=#89b4fa]$session_name"
fi

echo "$info"
