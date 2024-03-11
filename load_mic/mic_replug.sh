#!/bin/bash

# Get the device and bus numbers for the Blue Yeti
deviceLine=$(lsusb | grep '046d:0ab7')

if [ -z "$deviceLine" ]; then
    echo "Blue Yeti microphone not found."
    exit 1
fi

bus=$(echo $deviceLine | awk '{print $2}')
device=$(echo $deviceLine | awk '{print $4}' | sed 's/://')

# Construct the path for usbreset
usbResetPath="/dev/bus/usb/$bus/$device"

echo "Resetting $usbResetPath"
sudo usbreset $usbResetPath
