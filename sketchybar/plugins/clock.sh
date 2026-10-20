#!/usr/bin/env bash

case "$SENDER" in
"mouse.clicked")
	if [ "$BUTTON" = "right" ]; then
		sketchybar --set "$NAME" popup.drawing=off
		open -a Calendar
	else
		"$HOME/.config/sketchybar/plugins/calendar_popup.sh"
		sketchybar --set "$NAME" popup.drawing=toggle
	fi
	;;
"mouse.exited.global")
	sketchybar --set "$NAME" popup.drawing=off
	;;
"system_woke")
	"$HOME/.config/sketchybar/plugins/calendar_popup.sh"
	;;
*)
	LABEL=$(date '+%a %d. %b %H:%M:%S')
	sketchybar --set "$NAME" label="$LABEL"
	;;
esac
