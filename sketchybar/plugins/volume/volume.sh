#!/usr/bin/env bash
# Volume pill: icon and percentage, hover, scroll to change the volume, and the popup
# (slider, mute and device list). Left click toggles the popup, right click opens Sound settings.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"

NAME="${NAME:-volume}"
VOLUME_STEP=3 # Percent per scroll tick

# update: refresh the pill, the slider and the mute row
update() {
	local volume muted device icon mute_icon mute_label
	read -r volume muted < <("$SB_HELPER" volume)
	device="$("$SB_HELPER" output)"

	if [ "$muted" = "1" ]; then
		icon="󰖁"
		volume=0
		mute_icon="󰕾"
		mute_label="Unmute"
	else
		mute_icon="󰖁"
		mute_label="Mute"
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
		--set volume.mute icon="$mute_icon" label="$mute_label"
}

case "$SENDER" in
"mouse.entered" | "mouse.exited")
	source "$LIB_DIR/hover.sh"
	;;
"mouse.clicked")
	source "$LIB_DIR/popups.sh"
	if [ "$BUTTON" = "right" ]; then
		popup_close_all
		open_settings Sound
	else
		refresh_volume_popup() {
			"$PLUGIN_DIR/volume/devices.sh"
			update
		}
		popup_toggle "$NAME" refresh_volume_popup
	fi
	;;
"mouse.scrolled")
	read -r cur _ < <("$SB_HELPER" volume)
	if [ "${SCROLL_DELTA:-0}" -gt 0 ] 2>/dev/null; then
		"$SB_HELPER" set-volume $((cur + VOLUME_STEP))
	elif [ "${SCROLL_DELTA:-0}" -lt 0 ] 2>/dev/null; then
		"$SB_HELPER" set-volume $((cur - VOLUME_STEP))
	fi
	;;
*)
	update
	;;
esac
