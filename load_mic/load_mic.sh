#!/bin/bash

# Vendor and product IDs for your microphone
VENDOR_ID="046d"
PRODUCT_ID="0ab7"

# Find the device path based on vendor and product IDs
DEVICE_PATH=$(ls /dev/bus/usb/*/ | grep "$VENDOR_ID:$PRODUCT_ID")

# Check if the device path is not empty
if [ -n "$DEVICE_PATH" ]; then
    # Check if the microphone is already loaded
    if lsusb | grep -q "$VENDOR_ID:$PRODUCT_ID"; then
        echo "Microphone already loaded."
    else
        # Reset the USB device
        sudo usbreset "$DEVICE_PATH"
        echo "Microphone loaded."
    fi
else
    echo "Microphone not found."
fi
