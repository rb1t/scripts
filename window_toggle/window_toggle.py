import evdev
import time
from subprocess import check_output

# Configuration Section
WINDOW1 = "Jengu"
WINDOW2 = "Drow"

def find_gamepad_device():
    for device in evdev.list_devices():
        dev = evdev.InputDevice(device)
        if 'X-Box 360 pad' in dev.name:
            return dev
    return None

def activate_window(window_name):
    # Delay before switching to let the system settle
    time.sleep(0.10)  # Increased delay
    check_output(["xdotool", "search", "--name", window_name, "windowactivate"])
    # Additional delay after switching to let the system settle again
    time.sleep(0.10)  # Increased delay

def toggle_windows(window1, window2, gamepad):
    current_window = window1
    last_window_toggle_time = time.time()

    for event in gamepad.read_loop():
        if event.type == evdev.ecodes.EV_KEY and event.code == evdev.ecodes.BTN_START and event.value == 1:
            if time.time() - last_window_toggle_time > 0.5:  # Debounce to prevent repeated toggling
                target_window = window2 if current_window == window1 else window1
                activate_window(target_window)
                print(f"Switching to {target_window}")
                current_window = target_window
                last_window_toggle_time = time.time()

def main():
    gamepad = find_gamepad_device()
    if gamepad is None:
        print("Gamepad not found.")
        return
    print(f"Using gamepad: {gamepad.name}")
    print("Listening for gamepad events... (Press 'start' button)")
    toggle_windows(WINDOW1, WINDOW2, gamepad)

if __name__ == "__main__":
    main()
