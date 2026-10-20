#!/usr/bin/env bash

COLOR="$GREEN"

sketchybar --add item battery right \
	--set battery \
	update_freq=120 \
	icon.color="$COLOR" \
	icon.padding_left=10 \
	label.padding_right=10 \
	label.color="$LABEL_COLOR" \
	background.height=26 \
	background.corner_radius="$CORNER_RADIUS" \
	background.padding_right=5 \
	background.border_width="$BORDER_WIDTH" \
	background.border_color="$ITEM_BORDER_COLOR" \
	background.color="$ITEM_BG_COLOR" \
	background.shadow.drawing=off \
	background.drawing=on \
	click_script="open /System/Library/PreferencePanes/Battery.prefPane" \
	script="$PLUGIN_DIR/power.sh" \
	--subscribe battery power_source_change
