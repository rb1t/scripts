# About Arch Update

The goal is simply to have a quick/convenient way to update the system with minimal clicks/typing. This essentially just runs `sudo pacman -Syu` and `yay --noconfirm`. However, it also includes an icon and instructions below to configure as a "desktop"/Favorites icon in KDE. I.e., if you want to add to the Application Launcher (AKA "start menu"). 

## Requirements

- Arch Linux
- KDE Plasma

## Instructions

** Step 1 - Prep **

(a.) Clone this repo to a path of your choosing. Keep this path in mind for `Step 2 (b.)`.
(b.) Run `chmod +x`on `archupdate.sh`

** Step 2 - Create the "Desktop" file **

(a.) Navigate to your KDE "desktop" application directory. For ...
- _system-wide_, go to:  `/usr/share/applications/`
- _a specific user_, go to: `~/.local/share/applications/`

(b.) Create a file named `archupdate.desktop` (can really be "anything.desktop"), and configure it to point to the script and icon. Example included below.

```
[Desktop Entry]
Comment= Runs "sudo pacman -Syu"
Exec=konsole -e /bin/bash -c "/home/myuser/Sripts/archupdate/archupdate.sh"
GenericName=Arch Update
Name=Arch Update
StartupNotify=true
Type=Application
X-KDE-SubstituteUID=false
Icon=/home/myuser/Scripts/archupdate/icon.png
```

_Be sure to replace the `Exec` and `Icon` values with the path you used in Step 1._

** Step 3 - Add your icon to the Application Launcher / Autostart **

You can now add your icon/application to the Application Launcher (similar tot he 'Start' menu in Windows):

- Press the super key ("Windows/Mac button")
- Start typing "update" and the Application should appear in the list-view.
- Right click, and choose "Add to Favorites". You should now see your application in the list.

For Autostart:

- Hit Metakey and type "Autostart", click Autostart in the list of results.
- Add an entry for a Login script, using Konsole (should show in the list)
- Edit the settings to include:
    - _Name_: `Archupdate`
    - _Program_: `Konsole`
    - _Arguments_: `-e /bin/bash -c /[_your script path_]/archupdate.sh`
