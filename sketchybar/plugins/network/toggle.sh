#!/usr/bin/env bash
# Turns Wi-Fi on or off, then refreshes the popup and the network pill.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"

WIFI_DEV="$(wifi_device)"
if [ "$(networksetup -getairportpower "$WIFI_DEV" | awk '{print $NF}')" = "On" ]; then
	networksetup -setairportpower "$WIFI_DEV" off
else
	networksetup -setairportpower "$WIFI_DEV" on
fi
sleep 1
"$PLUGIN_DIR/network/popup.sh"
NAME=network "$PLUGIN_DIR/network/network.sh"
