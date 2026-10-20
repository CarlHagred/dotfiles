#!/usr/bin/env bash
# Clock tick, hover and click handling. Left click toggles the calendar popup,
# right click opens Calendar.app.

# Fast path: the once-a-second tick only needs a single `date` call
case "$SENDER" in
"mouse.entered" | "mouse.exited" | "mouse.clicked" | "system_woke") ;;
*)
	DATE_TIME="$(date '+%a %d. %b|%H:%M:%S')"
	sketchybar --set "$NAME" icon="${DATE_TIME%|*}" label="${DATE_TIME#*|}"
	exit 0
	;;
esac

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"
source "$LIB_DIR/popups.sh"

HOVER_STYLE=island
source "$LIB_DIR/hover.sh"

case "$SENDER" in
"mouse.clicked")
	if [ "$BUTTON" = "right" ]; then
		popup_close_all
		open -a Calendar
	else
		echo 0 >"$STATE_DIR/cal_offset"
		popup_toggle "$NAME" "$PLUGIN_DIR/clock/popup.sh"
	fi
	;;
"system_woke")
	"$PLUGIN_DIR/clock/popup.sh"
	;;
esac
