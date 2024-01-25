import keyboard
import time
from subprocess import check_output

# Define the names of the two windows you want to toggle between
WINDOW1 = "Jengu"
WINDOW2 = "Drow"

CURRENT_WINDOW = WINDOW1

# Define the hotkey as "tilde+g" for toggling and "tilde+esc" for exit
TOGGLE_HOTKEY = "ctrl+alt"
EXIT_HOTKEY = "tilde+esc"

# Flag to keep track of the hotkey state
HOTKEY_PRESSED = False

while True:
    # Check if the toggle hotkey is pressed
    if keyboard.is_pressed(TOGGLE_HOTKEY):

        if CURRENT_WINDOW == WINDOW1:
            print("Switching to window 2: " + WINDOW2)
            check_output(["xdotool", "search", "--name", WINDOW2, "windowactivate"])
            CURRENT_WINDOW = WINDOW2

        elif CURRENT_WINDOW == WINDOW2:
            print("Switching to window 1: " + WINDOW1)
            check_output(["xdotool", "search", "--name", WINDOW1, "windowactivate"])
            CURRENT_WINDOW = WINDOW1
        else:
            print("Error finding window by name!")

        # Sleep to avoid rapid processing of the hotkey
        time.sleep(1)  # Adjust this sleep duration as needed

    # Check if the exit hotkey is pressed
    if keyboard.is_pressed(EXIT_HOTKEY):
        print("Exiting the program.")
        break

    # Sleep for a short interval to avoid high CPU usage
    time.sleep(0.1)
