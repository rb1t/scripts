import evdev
import time
from subprocess import check_output, CalledProcessError

# Configuration Section
WINDOW1 = "Jengu"
WINDOW2 = "Drow"
DEBOUNCE_TIME = 0.5
FOCUS_STABILIZATION_DELAY = 0.1

def find_gamepad_device():
    for device in evdev.list_devices():
        dev = evdev.InputDevice(device)
        if 'X-Box 360 pad' in dev.name:
            return dev
    return None

def activate_window(window_name):
    try:
        check_output(["xdotool", "search", "--name", window_name, "windowactivate"])
        return True
    except CalledProcessError:
        return False

def toggle_windows(window1, window2, gamepad):
    current_window = window1
    last_window_toggle_time = time.time()
    while True:
        for event in gamepad.read_loop():
            if event.type == evdev.ecodes.EV_KEY and event.code == evdev.ecodes.BTN_START and event.value == 1:
                if time.time() - last_window_toggle_time > DEBOUNCE_TIME:
                    target_window = window2 if current_window == window1 else window1
                    if activate_window(target_window):
                        print(f"Switching to {target_window}")
                        current_window = target_window
                        last_window_toggle_time = time.time()
                        time.sleep(FOCUS_STABILIZATION_DELAY)
                    else:
                        print(f"Waiting for {target_window} to open...")
                        time.sleep(1)

            if event.code == evdev.ecodes.KEY_GRAVE and event.value == 1:
                if any(evdev.InputDevice(event.device.path).active_keys(verbose=True)):
                    if evdev.ecodes.KEY_ESC in evdev.InputDevice(event.device.path).active_keys():
                        print("Exiting the program.")
                        return

def main():
    gamepad = find_gamepad_device()
    if gamepad is None:
        print("Gamepad not found.")
        return
    print(f"Using gamepad: {gamepad.name}")
    print("Listening for gamepad events... (Press 'start' button)")
    print("Press Tilde+Esc to exit")
    toggle_windows(WINDOW1, WINDOW2, gamepad)

if __name__ == "__main__":
    main()
