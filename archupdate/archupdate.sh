#!/bin/bash

echo "
_________________________________________

            /\\      /\\
           //\\\    /||\\
          //--\\\    ||
         //    \\\   ||
__________________________________________
"

echo "=========================================="
echo "[ARCH UPDATE] System packages"
echo "=========================================="
sudo pacman -Syu --noconfirm

echo
echo "=========================================="
echo "[ARCH UPDATE] AUR packages via yay"
echo "=========================================="
yay -Syu --noconfirm

echo
echo "=========================================="
echo "[ARCH UPDATE] Flatpak packages via Flathub"
echo "=========================================="
flatpak update --noninteractive

echo
read -p "[ARCH UPDATE] Press Enter to exit..."
