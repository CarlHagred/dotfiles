#!/usr/bin/env bash

export PATH="/opt/homebrew/bin:$PATH"
NAME="${NAME:-volume}"
PLUGIN_DIR="$HOME/.config/sketchybar/plugins"

get_volume() {
	osascript -e 'output volume of (get volume settings)' 2>/dev/null
}

set_volume() {
	local v=$1
	[ "$v" -gt 100 ] && v=100
	[ "$v" -lt 0 ] && v=0
	osascript -e "set volume output volume $v" -e "set volume without output muted"
}

update() {
	local settings volume muted device icon
	settings="$(osascript -e 'get volume settings')"
	volume="$(echo "$settings" | sed -E 's/.*output volume:([^,]*),.*/\1/')"
	muted="$(echo "$settings" | sed -E 's/.*output muted:([a-z]*).*/\1/')"
	case "$volume" in
	'' | *[!0-9]*) volume=100 ;;
	esac

	device="$(SwitchAudioSource -c -t output 2>/dev/null)"

	if [ "$muted" = "true" ]; then
		icon="󰖁"
		volume=0
		MUTE_ICON="󰕾"
		MUTE_LABEL="Unmute"
	else
		MUTE_ICON="󰖁"
		MUTE_LABEL="Mute"
		case "$device" in
		*MacBook* | "")
			case ${volume} in
			100) icon="󰕾" ;;
			[5-9]*) icon="󰖀" ;;
			[0-9]*) icon="󰕿" ;;
			*) icon="󰖁" ;;
			esac
			;;
		*) icon="󰋋" ;; # headphones for any non built-in output
		esac
	fi

	sketchybar -m \
		--set "$NAME" icon="$icon" label="$volume%" \
		--set volume.slider slider.percentage="$volume" \
		--set volume.mute icon="$MUTE_ICON" label="$MUTE_LABEL"
}

case "$SENDER" in
"mouse.entered" | "mouse.exited")
	source "$PLUGIN_DIR/hover.sh"
	;;
"mouse.clicked")
	if [ "$BUTTON" = "right" ]; then
		sketchybar --set "$NAME" popup.drawing=off
		open "x-apple.systempreferences:com.apple.Sound-Settings.extension"
	else
		"$PLUGIN_DIR/audio_devices.sh"
		update
		sketchybar --set "$NAME" popup.drawing=toggle
	fi
	;;
"mouse.scrolled")
	cur="$(get_volume)"
	case "$cur" in '' | *[!0-9]*) exit 0 ;; esac
	if [ "${SCROLL_DELTA:-0}" -gt 0 ] 2>/dev/null; then
		set_volume $((cur + 3))
	elif [ "${SCROLL_DELTA:-0}" -lt 0 ] 2>/dev/null; then
		set_volume $((cur - 3))
	fi
	;;
"mouse.exited.global")
	sketchybar --set "$NAME" popup.drawing=off
	;;
*)
	update
	;;
esac
