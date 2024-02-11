#!/bin/bash

# File: arch-info.sh

# Define output file name with date and time
output_file="output_$(date +'%Y-%m-%d_%H-%M-%S').txt"

# Function to add content to output file
add_to_file() {
    echo "$1" >> "$output_file"
}

add_to_file "Arch Linux System Information Report"
add_to_file "------------------------------------"
add_to_file ""

# 1. List Installed Packages via Pacman
add_to_file "*** Installed Pacman Packages:"
pacman -Qqe | sed 's/^/* /' >> "$output_file"
add_to_file ""

# 2. List AUR Packages (if yay is installed)
if command -v yay &> /dev/null
then
    add_to_file "*** Installed AUR Packages:"
    yay -Qqm | sed 's/^/* /' >> "$output_file"
    add_to_file ""
fi

# 3. System Information
add_to_file "* System Information:"
add_to_file "  - Kernel Version: $(uname -r)"
if [ -f /etc/hostname ]; then
    add_to_file "  - Hostname: $(cat /etc/hostname)"
else
    add_to_file "  - Hostname: Hostname not found"
fi

# 4. Summary of User-specific Configuration Files
add_to_file "* Summary of User-specific Configuration Files:"
config_files=(.bashrc .vimrc .xinitrc .bash_profile)

for file in "${config_files[@]}"
do
    if [ -f "$HOME/$file" ]; then
        add_to_file "  - $file: $(wc -l < "$HOME/$file") lines"
    fi
done
add_to_file ""

add_to_file "Report generated on $(date)"

# Output final message to console
echo "Report generated and saved to $output_file"
exit 0
