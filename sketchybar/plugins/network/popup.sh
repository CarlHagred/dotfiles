#!/usr/bin/env bash
# Fills the network popup with details about the active connection.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"

IFACE="$(route -n get default 2>/dev/null | awk '/interface:/{print $2}')"
WIFI_DEV="$(wifi_device)"
WIFI_POWER="$(networksetup -getairportpower "$WIFI_DEV" 2>/dev/null | awk '{print $NF}')"

row() { printf '%-8s%s' "$1" "$2"; }

if [ "$WIFI_POWER" = "On" ]; then
	TOGGLE="Turn Wi-Fi Off"
else
	TOGGLE="Turn Wi-Fi On"
fi

if [ -z "$IFACE" ]; then
	sketchybar --set network.title label="Offline" \
		--set network.detail label="Not connected to a network" \
		--set network.ip drawing=off \
		--set network.router drawing=off \
		--set network.toggle label="$TOGGLE"
	exit 0
fi

IP="$(ipconfig getifaddr "$IFACE" 2>/dev/null)"
ROUTER="$(route -n get default 2>/dev/null | awk '/gateway:/{print $2}')"

if [ "$IFACE" = "$WIFI_DEV" ]; then
	while IFS='=' read -r key value; do
		case "$key" in
		rssi) W_RSSI="$value" ;;
		rate) W_RATE="$value" ;;
		channel) W_CHANNEL="$value" ;;
		band) W_BAND="$value" ;;
		esac
	done < <("$SB_HELPER" wifi)
	RSSI="${W_RSSI:--60}"
	if [ "$RSSI" -ge -55 ]; then
		QUALITY="Excellent"
	elif [ "$RSSI" -ge -65 ]; then
		QUALITY="Good"
	elif [ "$RSSI" -ge -75 ]; then
		QUALITY="Fair"
	else
		QUALITY="Weak"
	fi
	TITLE="Wi-Fi · $QUALITY ($RSSI dBm)"
	DETAIL="${W_BAND:-?} · ch ${W_CHANNEL:-?} · ${W_RATE:-?} Mbps"
elif [[ "$IFACE" == utun* ]]; then
	TITLE="VPN"
	DETAIL="Interface $IFACE"
else
	TITLE="Ethernet"
	DETAIL="Interface $IFACE"
fi

sketchybar --set network.title label="$TITLE" \
	--set network.detail label="$DETAIL" \
	--set network.ip drawing=on label="$(row "IP" "${IP:-n/a}")" \
	--set network.router drawing=on label="$(row "Router" "${ROUTER:-n/a}")" \
	--set network.toggle label="$TOGGLE"
