import evdev
import time
from subprocess import check_output

# Function to find the gamepad device
def find_gamepad_device():
    for device in evdev.list_devices():
        dev = evdev.InputDevice(device)
        if 'X-Box 360 pad' in dev.name:
            return dev
    return None

# Function to toggle windows
def toggle_windows(window1, window2, gamepad):
    current_window = window1
    start_pressed = False  # Flag to track the state of the start button

    for event in gamepad.read_loop():
        if event.type == evdev.ecodes.EV_KEY:
            if event.code == evdev.ecodes.BTN_START:
                if event.value == 1:  # Button pressed
                    start_pressed = True
                elif event.value == 0:  # Button released
                    if start_pressed:
                        if current_window == window1:
                            print("Switching to window 2:", window2)
                            check_output(["xdotool", "search", "--name", window2, "windowactivate"])
                            current_window = window2
                        elif current_window == window2:
                            print("Switching to window 1:", window1)
                            check_output(["xdotool", "search", "--name", window1, "windowactivate"])
                            current_window = window1
                        else:
                            print("Error finding window by name!")

                    start_pressed = False

        # Check if the tilde+esc key combination is pressed
        if event.type == evdev.ecodes.EV_KEY and event.code == evdev.ecodes.KEY_GRAVE and event.value == 1:
            print("Exiting the program.")
            return

        time.sleep(0.01)  # Adjust the sleep time for responsiveness

# Main function
def main():
    # Find the gamepad device
    gamepad = find_gamepad_device()

    if gamepad is None:
        print("Gamepad not found.")
        return

    print(f"Using gamepad: {gamepad.name}")

    # Define the names of the two windows you want to toggle between
    WINDOW1 = "Jengu"
    WINDOW2 = "Drow"

    # Start toggling windows
    print("Listening for gamepad events... (Press 'start' button)")
    toggle_windows(WINDOW1, WINDOW2, gamepad)

if __name__ == "__main__":
    main()
