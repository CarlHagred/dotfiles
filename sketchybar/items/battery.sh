#!/usr/bin/env bash

sketchybar --add item battery right \
	--set battery \
	"${PILL_STYLE[@]}" \
	update_freq=120 \
	icon.color="$ICON_COLOR" \
	label.color="$LABEL_COLOR" \
	click_script="open /System/Library/PreferencePanes/Battery.prefPane" \
	script="$PLUGIN_DIR/power.sh" \
	--subscribe battery power_source_change mouse.entered mouse.exited
