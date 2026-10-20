#!/usr/bin/env bash

sketchybar --add item network right \
	--set network \
	"${PILL_STYLE[@]}" \
	update_freq=10 \
	icon.color="$ICON_COLOR" \
	icon.padding_right=9 \
	label.color="$LABEL_COLOR" \
	label.drawing=off \
	click_script="open /System/Library/PreferencePanes/Network.prefPane" \
	script="$PLUGIN_DIR/network.sh" \
	--subscribe network mouse.entered mouse.exited
