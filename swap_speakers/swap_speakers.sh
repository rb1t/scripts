#!/bin/bash

# Load remapped sink
pactl load-module module-remap-sink master=alsa_output.pci-0000_00_1f.3.analog-stereo channels=2 master_channel_map=front-right,front-left channel_map=front-left,front-right remix=no sink_name=reverse-stereo

# Set remapped sink as default
pactl set-default-sink reverse-stereo
