#!/usr/bin/env bash

source "$HOME/.config/sketchybar/plugins/hover.sh"

# Get network status
WIFI_DEVICE=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')
WIFI_STATUS=$(ifconfig "$WIFI_DEVICE" 2>/dev/null | grep "status:" | awk '{print $2}')

if [ "$WIFI_STATUS" = "active" ]; then
	SSID=$(networksetup -getairportnetwork "$WIFI_DEVICE" | awk -F': ' '{print $2}')
	RSSI=$(sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep "agrCtlRSSI" | awk '{print $2}')
	
	if [ -n "$RSSI" ]; then
		if [ "$RSSI" -gt -50 ]; then
			ICON="󰤨"
		elif [ "$RSSI" -gt -60 ]; then
			ICON="󰤥"
		elif [ "$RSSI" -gt -70 ]; then
			ICON="󰤢"
		else
			ICON="󰤟"
		fi
	else
		ICON="󰤨"
	fi
	
	if [ -n "$SSID" ]; then
		sketchybar --set "$NAME" icon="$ICON" icon.color="$ICON_COLOR" icon.padding_right=5 label="$SSID" label.drawing=on
	else
		sketchybar --set "$NAME" icon="$ICON" icon.color="$ICON_COLOR" icon.padding_right=9 label.drawing=off
	fi
else
	sketchybar --set "$NAME" icon="󰤮" icon.padding_right=5 icon.color="$ICON_DIM_COLOR" label="No WiFi" label.drawing=on
fi
