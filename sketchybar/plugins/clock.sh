#!/usr/bin/env bash

case "$SENDER" in
"mouse.entered" | "mouse.exited")
	# Hover only brightens the island border; the background stays solid
	source "$HOME/.config/sketchybar/variables.sh"
	if [ "$SENDER" = "mouse.entered" ]; then
		sketchybar --animate tanh 8 --set "$NAME" background.border_color=0x40ffffff
	else
		sketchybar --animate tanh 8 --set "$NAME" background.border_color="$ISLAND_BORDER"
	fi
	;;
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
	sketchybar --set "$NAME" icon="$(date '+%a %d. %b')" label="$(date '+%H:%M:%S')"
	;;
esac
