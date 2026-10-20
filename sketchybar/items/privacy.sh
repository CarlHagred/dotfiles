#!/usr/bin/env bash
# Dot that appears while the microphone or camera is in use (polled by plugins/privacy/privacy.sh).

sketchybar --add item privacy right \
	--set privacy \
	"${PILL_STYLE[@]}" \
	drawing=off \
	updates=on \
	update_freq=3 \
	icon="●" \
	icon.color="$ORANGE" \
	icon.padding_left=9 \
	icon.padding_right=9 \
	label.drawing=off \
	script="$PLUGIN_DIR/privacy/privacy.sh"
