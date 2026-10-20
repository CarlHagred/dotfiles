#!/usr/bin/env bash
# Network pill: connection-type icon (Wi-Fi strength, Ethernet, VPN, offline), hover and popup.
# Left click toggles the popup, right click opens Network settings.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"

case "$SENDER" in
"mouse.entered" | "mouse.exited")
	source "$LIB_DIR/hover.sh"
	;;
"mouse.clicked")
	source "$LIB_DIR/popups.sh"
	if [ "$BUTTON" = "right" ]; then
		popup_close_all
		open_settings Network
	else
		popup_toggle "$NAME" "$PLUGIN_DIR/network/popup.sh"
	fi
	;;
*)
	IFACE="$(route -n get default 2>/dev/null | awk '/interface:/{print $2}')"
	WIFI_DEV="$(wifi_device)"

	if [ -z "$IFACE" ]; then
		WIFI="$("$SB_HELPER" wifi)"
		if [ "$WIFI" = "down" ] || [ -z "$WIFI" ]; then
			sketchybar --set "$NAME" icon="󰤮" icon.color="$ICON_DIM_COLOR" icon.padding_right=5 label="Offline" label.drawing=on
		fi
		exit 0
	fi

	sketchybar --set "$NAME" label.drawing=off icon.padding_right=9 icon.color="$ICON_COLOR"
	if [ "$IFACE" = "$WIFI_DEV" ]; then
		RSSI="$("$SB_HELPER" wifi | sed -n 's/^rssi=//p')"
		RSSI="${RSSI:--60}"
		if [ "$RSSI" -gt -55 ]; then
			ICON="󰤨"
		elif [ "$RSSI" -gt -65 ]; then
			ICON="󰤥"
		elif [ "$RSSI" -gt -75 ]; then
			ICON="󰤢"
		else
			ICON="󰤟"
		fi
	elif [[ "$IFACE" == utun* ]]; then
		ICON="󰖂"
	else
		ICON="󰈀"
	fi
	sketchybar --set "$NAME" icon="$ICON"
	;;
esac
