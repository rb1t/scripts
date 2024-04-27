#!/bin/bash
# Script to list windows with PIDs, optionally follow the output like tail -f

follow_mode=false

# Check for the presence of -f or --follow in the arguments
for arg in "$@"; do
  case $arg in
    -f|--follow)
      follow_mode=true
      shift # Remove the current argument
      ;;
  esac
done

list_windows() {
  output="Window ID, PID, Process Name, Window Name\n"
  output+="--------------------------------------------------\n"
  while IFS= read -r window; do
    pid=$(echo "$window" | awk '{print $3}')
    if ! [[ $pid =~ ^[0-9]+$ ]]; then
      continue # Skip if the PID isn't a number
    fi
    window_id=$(echo "$window" | awk '{print $1}')
    window_name=$(echo "$window" | cut -d" " -f5-)
    proc_name=$(ps -p $pid -o comm= 2>/dev/null)
    if [ -z "$proc_name" ]; then
      proc_name="Unknown/Exited"
    fi
    output+="$window_id, $pid, $proc_name, \"$window_name\"\n"
  done <<< "$(wmctrl -lp)"
  echo -ne "\033c"  # Clear screen using ANSI escape code
  echo -e "$output"
}

if [ "$follow_mode" = true ]; then
  while true; do
    list_windows
    sleep 2  # Refresh every 2 seconds, adjust as needed
  done
else
  list_windows
fi
