#!/usr/bin/env bash
# Rebuilds the device rows in the volume popup:
#   Output    - every available output device (built-in, USB, HDMI, connected Bluetooth, virtual, ...)
#   Input     - every available input device
#   Bluetooth - paired audio devices that are not connected yet (click to connect)
# Row N of the cache file ("kind|id|name") is what select.sh acts on.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"

CACHE="$STATE_DIR/audio_devices"
BT_TYPES='Headphones|Headset|Speaker|Hands-?free|Loudspeaker|Portable Audio|HiFi|Car Audio'

current_out="$(SwitchAudioSource -c -t output 2>/dev/null)"
current_in="$(SwitchAudioSource -c -t input 2>/dev/null)"
: >"$CACHE"

add_header() { printf 'hdr|-|%s\n' "$1" >>"$CACHE"; }

add_header "Output"
while IFS= read -r dev; do
	[ -n "$dev" ] && printf 'out|%s|%s\n' "$dev" "$dev" >>"$CACHE"
done < <(SwitchAudioSource -a -t output 2>/dev/null)

add_header "Input"
while IFS= read -r dev; do
	[ -n "$dev" ] && printf 'in|%s|%s\n' "$dev" "$dev" >>"$CACHE"
done < <(SwitchAudioSource -a -t input 2>/dev/null)

bt_lines="$(system_profiler SPBluetoothDataType -json 2>/dev/null |
	jq -r --arg types "$BT_TYPES" '
		.SPBluetoothDataType[0].device_not_connected // []
		| .[] | to_entries[]
		| select((.value.device_minorType // "") | test($types; "i"))
		| [(.value.device_address // ""), .key] | @tsv')"

if [ -n "$bt_lines" ]; then
	add_header "Paired Bluetooth (click to connect)"
	while IFS=$'\t' read -r addr name; do
		[ -n "$addr" ] && printf 'bt|%s|%s\n' "$addr" "$name" >>"$CACHE"
	done <<<"$bt_lines"
fi

sketchybar --remove '/volume\.dev\..*/' >/dev/null 2>&1

ARGS=()
i=0
while IFS='|' read -r kind id name; do
	i=$((i + 1))
	row="volume.dev.$i"

	if [ "$kind" = "hdr" ]; then
		ARGS+=(--add item "$row" popup.volume
			--set "$row"
			icon.drawing=off
			label="$(echo "$name" | tr '[:lower:]' '[:upper:]')"
			label.color="$ICON_DIM_COLOR"
			label.font="$FONT:Bold:10.5"
			label.padding_left=14
			label.padding_right=12
			background.drawing=off)
		continue
	fi

	active=false
	[ "$kind" = "out" ] && [ "$name" = "$current_out" ] && active=true
	[ "$kind" = "in" ] && [ "$name" = "$current_in" ] && active=true

	if $active; then
		icon="󰄬"
		color="$ACCENT"
		label_color="$ACCENT"
		bg="$ACCENT_TINT"
	elif [ "$kind" = "bt" ]; then
		icon="󰂯"
		color="$ICON_DIM_COLOR"
		label_color="$ICON_DIM_COLOR"
		bg="$TRANSPARENT"
	else
		icon=" "
		color="$ACCENT"
		label_color="$LABEL_COLOR"
		bg="$TRANSPARENT"
	fi

	ARGS+=(--add item "$row" popup.volume
		--set "$row"
		icon="$icon"
		icon.color="$color"
		icon.width=26
		icon.align=center
		icon.font="$FONT:Bold:13.5"
		icon.padding_left=8
		icon.padding_right=0
		label="$name"
		label.color="$label_color"
		label.font="$FONT:Bold:13.0"
		label.padding_left=4
		label.padding_right=12
		background.color="$bg"
		background.corner_radius=6
		background.height=22
		background.padding_left=6
		background.padding_right=6
		background.drawing=on
		click_script="$PLUGIN_DIR/volume/select.sh $i")
done <"$CACHE"

[ ${#ARGS[@]} -gt 0 ] && sketchybar "${ARGS[@]}"
exit 0
