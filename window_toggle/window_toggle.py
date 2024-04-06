import evdev
import time
from subprocess import check_output
import keyboard

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
    for event in gamepad.read_loop():
        if event.type == evdev.ecodes.EV_KEY and event.value == 1 and event.code == evdev.ecodes.BTN_START:
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

        # Check if the tilde+esc key combination is pressed
        if keyboard.is_pressed('tilde+esc'):
            print("Exiting the program.")
            break

        time.sleep(0.1)

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
