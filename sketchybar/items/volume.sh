#!/usr/bin/env bash

COLOR="$ICON_COLOR"

sketchybar \
	--add item volume right \
	--set volume \
	icon.color="$COLOR" \
	icon.padding_left=10 \
	label.color="$COLOR" \
	label.padding_right=10 \
	background.height=26 \
	background.corner_radius="$CORNER_RADIUS" \
	background.padding_right=5 \
	background.border_width="$BORDER_WIDTH" \
	background.border_color="$ITEM_BORDER_COLOR" \
	background.color="$ITEM_BG_COLOR" \
	background.shadow.drawing=off \
	background.drawing=on \
	click_script="open /System/Library/PreferencePanes/Sound.prefPane" \
	script="$PLUGIN_DIR/sound.sh" \
	--subscribe volume volume_change
