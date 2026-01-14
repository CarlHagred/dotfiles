#!/usr/bin/env bash

# Get network status
LABEL_NAME="${NAME}_label"
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
	
	sketchybar --set "$NAME" icon="$ICON" drawing=on \
	           --set "$LABEL_NAME" label="$SSID" drawing=on
else
	sketchybar --set "$NAME" icon="󰤮" drawing=on \
	           --set "$LABEL_NAME" label="No WiFi" drawing=on
fi
