#!/bin/bash

# -- Archsumm --
# Summarize installed applications and other information, printing to a file.
# (This is only intended for Arch-based Linux systems!)

# Define output directory and file name
output_dir="output"
mkdir -p "$output_dir"  # Ensure the directory exists

# Define the output file path
output_file="$output_dir/archsum_$(date +'%Y-%m-%d_%H-%M-%S').txt"

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

# Function to generate a one-line install command from package list
generate_install_command() {
    local packages="$1"
    local command_prefix="$2"
    local output="$3"
    echo "" >> "$output_file"
    echo "$command_prefix $(echo $packages | tr '\n' ' ')" >> "$output_file"
    add_to_file "" # Add an empty line for spacing
}

# Check for command existence
command_exists() {
    command -v "$1" &> /dev/null
}

# Heading and timestamp
add_to_file "-- Archsumm --"
add_to_file "(Arch Linux System Report)"
add_to_file "Generated on $(date +'%Y-%m-%d_%H-%M-%S')"

# 1. List Installed Pacman Packages
add_section_header "Installed Pacman Packages"
if command_exists pacman; then
    packages=$(pacman -Qqe)
    echo "$packages" | sed 's/^/* /' >> "$output_file"
    generate_install_command "$packages" "sudo pacman -Sy --needed" "$output_file"
else
    add_to_file "Pacman not found, skipping..."
fi

# 2. List AUR Packages (using yay)
if command_exists yay; then
    add_section_header "Installed AUR Packages"
    aur_packages=$(yay -Qqm)
    echo "$aur_packages" | sed 's/^/* /' >> "$output_file"
    generate_install_command "$aur_packages" "yay -S --needed" "$output_file"
else
    add_to_file "Yay not found, skipping AUR packages..."
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
add_to_file "* CPU: $(lscpu | grep 'Model name' | sed -r 's/Model name:\s{1,}//' | awk '{$1=$1; print}')"
add_to_file "* GPU: $(lspci | grep VGA | cut -d ':' -f3 | awk '{$1=$1; print}')"
add_to_file "* RAM: $(free -h | grep Mem | awk '{print $2}' | awk '{$1=$1; print}') of total memory"

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

# 9. Other Apps/Installed from Discover
add_section_header "Other Apps/Installed from Discover"

# Flatpak Applications
if command_exists flatpak; then
    add_to_file "*** Flatpak Applications:"
    flatpak list --app --columns=application | sed 's/^/* /' >> "$output_file"
    add_to_file ""
fi

# Snap Applications
if command_exists snap; then
    add_to_file "*** Snap Applications:"
    snap list | awk 'NR>1 {print "* " $1}' >> "$output_file"
    add_to_file ""
fi

# 10. Groups and Passwd File
add_section_header "Groups"
if [ -f /etc/group ]; then
    add_to_file "$(cat /etc/group)"
else
    add_to_file "/etc/group file not found"
fi

add_section_header "Passwd File"
if [ -f /etc/passwd ]; then
    add_to_file "$(cat /etc/passwd)"
else
    add_to_file "/etc/passwd file not found"
fi

# 11. Contents of Specific Configuration Files
add_section_header "Specific Configuration Files"

declare -A config_files_to_check=(
    ["~/.config/pipewire/jack.conf"]="$HOME/.config/pipewire/jack.conf"
    ["/etc/security/limits.d/audio.conf"]="/etc/security/limits.d/audio.conf"
    ["~/.ssh/config"]="$HOME/.ssh/config"
)

for label in "${!config_files_to_check[@]}"; do
    config_file="${config_files_to_check[$label]}"
    add_section_header "$label"
    if [ -f "$config_file" ]; then
        add_to_file "$(cat "$config_file")"
    else
        add_to_file "$config_file not found"
    fi
done

# Done!
echo "Report generated and saved to $output_file"
exit 0
