#!/bin/bash
# sleep 5  # Adjust the sleep time as needed
echo "Rescanning USB devices..."
sudo sh -c 'echo 1 > /sys/bus/usb/devices/*/remove'
sleep 2
sudo sh -c 'echo 1 > /sys/bus/usb/devices/*/authorized'
