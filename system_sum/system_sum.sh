#!/bin/bash

# File: arch-info.sh

# Define output file name with date and time
output_file="archsum_$(date +'%Y-%m-%d_%H-%M-%S').txt"

# Function to add content to output file
add_to_file() {
    echo "$1" >> "$output_file"
}

# Function to add a section header
add_section_header() {
    echo "" >> "$output_file"
    echo "================================================================================" >> "$output_file"
    echo "$1" >> "$output_file"
    echo "================================================================================" >> "$output_file"
    echo "" >> "$output_file"
}

add_to_file "Arch Linux System Information Report"

# 1. List Installed Pacman Packages
add_section_header "Installed Pacman Packages"
pacman -Qqe | sed 's/^/* /' >> "$output_file"

# 2. List AUR Packages
# This section now should work given yay is installed
if command -v yay &> /dev/null; then
    add_section_header "Installed AUR Packages"
    yay -Qqm | sed 's/^/* /' >> "$output_file"
fi

# 3. System Information
add_section_header "System Information"
add_to_file "* Kernel Version: $(uname -r)"
if [ -f /etc/hostname ]; then
    add_to_file "* Hostname: $(cat /etc/hostname)"
else
    add_to_file "* Hostname: Hostname not found"
fi

# 4. Hardware Information
add_section_header "Hardware Information"
add_to_file "* CPU: $(lscpu | grep 'Model name' | sed -r 's/Model name:\s{1,}//')"
add_to_file "* GPU: $(lspci | grep VGA | cut -d ':' -f3)"
add_to_file "* RAM: $(free -h | grep Mem | awk '{print $2}') of total memory"

# 5. Disk Usage
add_section_header "Disk Usage"
df -h | grep '^/dev/' | awk '{print "* " $1 ": " $5 " used (" $3 "/" $2 ") on " $6}' >> "$output_file"

# 6. Network Configuration
add_section_header "Network Configuration"
ip -br address | grep UP | awk '{print "* " $1 ": " $3}' >> "$output_file"

# 7. List of Enabled Systemd Services
add_section_header "Enabled Systemd Services"
systemctl list-unit-files --type=service | grep enabled | awk '{print "* " $1}' >> "$output_file"

# 8. Summary of User-specific Configuration Files
add_section_header "User-specific Configuration Files"
config_files=(.bashrc .vimrc .xinitrc .bash_profile)

for file in "${config_files[@]}"
do
    if [ -f "$HOME/$file" ]; then
        add_to_file "* $file: $(wc -l < "$HOME/$file") lines"
    fi
done

add_to_file ""
add_to_file "Report generated on $(date)"

# Output final message to console
echo "Report generated and saved to $output_file"
exit 0
