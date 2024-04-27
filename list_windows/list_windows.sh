#!/bin/bash
# List windows with PIDs
wmctrl -lp | while read -r window; do
  pid=$(echo "$window" | awk '{print $3}')
  window_id=$(echo "$window" | awk '{print $1}')
  window_name=$(echo "$window" | cut -d" " -f5-)
  proc_name=$(ps -p $pid -o comm=)
  echo "Window ID: $window_id, PID: $pid, Process Name: $proc_name, Window Name: $window_name"
done
