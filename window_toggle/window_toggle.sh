#!/bin/bash

# Define the fast forward button keycode (171 in your case)
FAST_FORWARD_KEYCODE="171"

# Initialize the toggle state
TOGGLE_STATE="A"

while true; do
    # Use xev to monitor key events and grep for the fast forward keycode
    if xev -root | grep -q "keycode $FAST_FORWARD_KEYCODE"; then
        # Toggle between 'A' and 'B' when the fast forward button is pressed
        if [ "$TOGGLE_STATE" == "A" ]; then
            echo "A"
            TOGGLE_STATE="B"
        else
            echo "B"
            TOGGLE_STATE="A"
        fi
    fi

    # Sleep for a short interval to avoid high CPU usage
    sleep 0.1
done
