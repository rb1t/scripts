#!/bin/bash
# Script to optimize multiple desktop windows based on given names

optimize_window() {
  local window_name=$1
  # Fetch the PID of the window with the specified name
  pid=$(wmctrl -lp | grep "$window_name" | awk '{print $3}')

  if [[ -n $pid ]]; then
    echo "Optimizing PID $pid for '$window_name'"

    # Set the CPU affinity to use CPUs 0-3
    taskset -cp 0-3 $pid

    # Set a higher priority
    sudo renice -n -10 -p $pid

    echo "Optimization applied: CPU affinity set to CPUs 0-3, Priority increased for '$window_name'"
  else
    echo "Window '$window_name' not found"
  fi
}

if [[ $# -eq 0 ]]; then
  echo "No window names provided. Usage: $0 'Window Name 1' 'Window Name 2' ..."
  exit 1
fi

# Loop through all arguments, each one is a window name
for window_name in "$@"; do
  optimize_window "$window_name"
done
