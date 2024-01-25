This script uses xsetwacom to manually calibrate a drawing tablet's pen and screen area, and also sets the button mapping.

_NOTE: This has only been tested on a Huion GT-156HD V2, using Arch Linux and KDE X11; but it should work on any Linux system. It should also work on any tablet, but you will likely need to re-map the buttons._

### Requirements:

- `xsetwacom`
- `evtest`

### Usage

Manually run the script, or set to start with your login scripts.

### Important calibration notes

- The `xsetwacom set "Tablet Monitor Pen stylus" Area 0 0 69000 39000` command is what calibrates the pen to the tablet's screen area. It uses values relative to the screen's resolution/area. I couldn't find a sensible equation for a "sweet spot", so I just tinkered with these values until I got something fairly accurate (i.e., the mouse/cursor is consistently following the pen movement).
- Regarding `xsetwacom set "Tablet Monitor Pen stylus" MapToOutput HEAD-1` (which binds the screen device and pen device together): generally the syntax is, `xsetwacom set "Device Name" MapToOutput "Monitor"` however this was not working for me when using the devices name. I discovered this was caused by Nvidia's proprietary driver and the solution is to instead use `HEAD-1` as the monitor name, per: https://wiki.archlinux.org/title/Graphics_tablet#Mapping_the_tablet_to_a_monitor

### Customizing / Mapping notes

- The following are my own custom mappings for the Huion GT-156HD V2. I've included which device the button exists on under the `xsetwacom --list devices` column. I've also included their corresponding commands in Krita. _This table corresponds with the script, `tablet_setup.sh`._
- If you are using a different tablet, you'll likely need to figure out your own mappings and update the script accordingly. The `evtest` tool can help (see `Handy commands` below).

| Krita cmd                  | Description                                   | `xsetwacom --list devices`       | button id | Cmd                                                                     |
| -------------------------- | --------------------------------------------- | ------------------------------ | --------- | ----------------------------------------------------------------------- |
| N/A                        | Define the drawing area                       | Tablet Monitor Pen stylus      |           | xsetwacom set "Tablet Monitor Pen stylus" Area 0 0 69000 39000          |
| N/A                        | Map tablet to monitor                         | Tablet Monitor Pen stylus      |           | xsetwacom set "Tablet Monitor Pen stylus" MapToOutput HEAD-1            |
| Undo                       | Top dial, left button                         | Tablet Monitor Pad pad         | 2         | xsetwacom set "Tablet Monitor Pad pad" Button "2" "key +ctrl +z"        |
| Erase                      | Top dial, up button                           | Tablet Monitor Pad pad         | 1         | xsetwacom set "Tablet Monitor Pad pad" Button "1" "key +e"              |
| Redo                       | Top dial, right button                        | Tablet Monitor Pad pad         | 8         | xsetwacom set "Tablet Monitor Pad pad" Button "8" "key +ctrl +shift +z" |
| Box select                 | Top dial, down button                         | Tablet Monitor Pad pad         | 9         | xsetwacom set "Tablet Monitor Pad pad" Button "9" "key +alt"            |
| Move Layer                 | Top dial, center button                       | Tablet Monitor Pad pad         | 3         | xsetwacom set "Tablet Monitor Pad pad" Button "3" "key +T"              |
| Ctrl                       | First button after top dial                   | Tablet Monitor Pad pad         | 10        | xsetwacom set "Tablet Monitor Pad pad" Button "10" "key +ctrl"          |
| Shift                      | Second button after top dial                  | Tablet Monitor Pad pad         | 11        | xsetwacom set "Tablet Monitor Pad pad" Button "11" "key +shift"         |
| N/A                        | Slider (not working?)                         | Tablet Monitor Touch Strip pad | 1         | xsetwacom set "Tablet Monitor Touch Strip pad" Button "1" "key +z"      |
| Zoom in                    | First button after slider                     | Tablet Monitor Pad pad         | 12        | xsetwacom set "Tablet Monitor Pad pad" Button "12" "key +plus"          |
| Zoom out                   | Second button after slider                    | Tablet Monitor Pad pad         | 13        | xsetwacom set "Tablet Monitor Pad pad" Button "13" "key +minus"         |
| rotate canvas left         | Bottom dial, left button                      | Tablet Monitor Pad pad         | 15        | xsetwacom set "Tablet Monitor Pad pad" Button "15" "key +0"             |
| Mova canvas                | Bottom dial, up button                        | Tablet Monitor Pad pad         | 14        | xsetwacom set "Tablet Monitor Pad pad" Button "14" "key +space"         |
| rotate canvas right        | Bottom dial, right button                     | Tablet Monitor Pad pad         | 17        | xsetwacom set "Tablet Monitor Pad pad" Button "17" "key +0"             |
| N/A                        | Bottom dial, down button (cant find id)       | Tablet Monitor Pad pad         |           | N/A                                                                     |
| Brush select (right click) | Bottom dial, center button                    | Tablet Monitor Pad pad         | 16        | xsetwacom set "Tablet Monitor Pad pad" Button "16" "button 3"           |
| N/A                        | Pen tip (don't override this, let it default) | Tablet Monitor Pen stylus      | 1         | N/A                                                                     |
| Brush tool                 | Closer to tip                                 | Tablet Monitor Pen stylus      | 2         | xsetwacom set "Tablet Monitor Pen stylus" Button "2" "key +b"           |
| color dropper              | Further from tip                              | Tablet Monitor Pen stylus      | 3         | xsetwacom set "Tablet Monitor Pen stylus" Button "3" "key +p"           |

### Handy commands

- To figure out what your button ids are on each device (and to do your own mapping):
    - get `evtest` and run `sudo evtest`. This will let you select your device(s) from a list, and then you can press keys to see their ids.
    - creating a spreadsheet can help to track your button ids and what device they live on (as I did above). When finished, simply update the script to include your button ids, and device names.
      

- List physical devices and their ids: `xsetwacom --list devices` e.g.,
    - Tablet Monitor Pad pad
    - Tablet Monitor Pen stylus				
    - Tablet Monitor Touch Strip pad				

- Print current mapping: `xsetwacom get [...]` e.g.,
    - `xsetwacom get "Tablet Monitor Pad pad" Button 1` will print, `key +e` (i.e., the 'e' key)
 
- Show display devices: `xrandr`

### Known issues

- The touch strip / slider doesn't appear to be woriking properly.
