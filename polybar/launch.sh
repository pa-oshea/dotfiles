#!/usr/bin/env bash

# Polybar Launch Script
# Handles multi-monitor setups and proper process management

# Define the configuration directory
CONFIG_DIR="$HOME/.config/polybar"
CONFIG_FILE="$CONFIG_DIR/config"

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Function to log messages
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>/tmp/polybar-launch.log
}

# Function to check if polybar config exists
check_config() {
  if [[ ! -f "$CONFIG_FILE" ]]; then
    log "ERROR: Polybar config not found at $CONFIG_FILE"
    echo "Polybar config not found at $CONFIG_FILE"
    echo "Please ensure your polybar config is located at $CONFIG_FILE"
    exit 1
  fi
}

# Function to terminate existing polybar instances
terminate_polybar() {
  log "Terminating existing Polybar instances..."
  killall -q polybar

  # Wait until all Polybar processes have been shut down
  local timeout=10
  local count=0
  while pgrep -u "$UID" -x polybar >/dev/null; do
    if [[ $count -ge $timeout ]]; then
      log "WARNING: Force killing Polybar processes after ${timeout}s timeout"
      killall -9 polybar 2>/dev/null
      break
    fi
    sleep 1
    ((count++))
  done

  log "All Polybar instances terminated"
}

# Function to launch polybar on monitors
launch_polybar() {
  local monitors
  monitors=$(polybar --list-monitors 2>/dev/null | cut -d":" -f1)

  if [[ -z "$monitors" ]]; then
    log "WARNING: No monitors detected, launching on default monitor"
    MONITOR="" polybar -q main -c "$CONFIG_FILE" 2>&1 | tee -a /tmp/polybar-main.log &
    log "Launched Polybar on default monitor (PID: $!)"
  else
    log "Detected monitors: $(echo $monitors | tr '\n' ' ')"

    for monitor in $monitors; do
      log "Launching Polybar on monitor: $monitor"
      MONITOR="$monitor" polybar -q main -c "$CONFIG_FILE" 2>&1 |
        tee -a "/tmp/polybar-${monitor}.log" &

      local pid=$!
      log "Launched Polybar on $monitor (PID: $pid)"

      # Small delay to prevent race conditions
      sleep 0.1
    done
  fi
}

# Function to verify polybar launched successfully
verify_launch() {
  sleep 2
  local running_instances
  running_instances=$(pgrep -u "$UID" -x polybar | wc -l)

  if [[ $running_instances -gt 0 ]]; then
    log "SUCCESS: $running_instances Polybar instance(s) running"
    echo "Polybar launched successfully on $running_instances monitor(s)"
  else
    log "ERROR: No Polybar instances detected after launch"
    echo "ERROR: Polybar failed to launch. Check logs at /tmp/polybar-*.log"
    exit 1
  fi
}

# Main execution
main() {
  log "=== Polybar Launch Script Started ==="

  # Check if polybar is installed
  if ! command -v polybar >/dev/null 2>&1; then
    echo "ERROR: Polybar is not installed"
    log "ERROR: Polybar command not found"
    exit 1
  fi

  # Check if config exists
  check_config

  # Terminate existing instances
  terminate_polybar

  # Launch polybar
  launch_polybar

  # Verify launch
  verify_launch

  log "=== Polybar Launch Script Completed ==="
}

# Handle script arguments
case "${1:-}" in
--help | -h)
  echo "Polybar Launch Script"
  echo "Usage: $0 [--help|-h] [--kill|-k]"
  echo ""
  echo "Options:"
  echo "  --help, -h    Show this help message"
  echo "  --kill, -k    Kill all polybar instances and exit"
  echo ""
  echo "Config location: $CONFIG_FILE"
  echo "Logs location: /tmp/polybar-*.log"
  exit 0
  ;;
--kill | -k)
  echo "Killing all Polybar instances..."
  log "Manual termination requested"
  terminate_polybar
  echo "All Polybar instances terminated"
  exit 0
  ;;
"")
  # Normal execution
  main
  ;;
*)
  echo "Unknown option: $1"
  echo "Use --help for usage information"
  exit 1
  ;;
esac
