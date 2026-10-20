#!/usr/bin/env bash

COLOR="$SECONDARY_HIGHLIGHT"

sketchybar --add item spotify q \
	--set spotify \
	scroll_texts=on \
	icon=󰎆 \
	icon.color="$COLOR" \
	icon.padding_left=10 \
	label.color="$ICON_COLOR" \
	background.color="$ITEM_ACTIVE_BG" \
	background.height=26 \
	background.corner_radius="$CORNER_RADIUS" \
	background.border_width="$BORDER_WIDTH" \
	background.border_color="$ITEM_BORDER_COLOR" \
	background.shadow.drawing=off \
	background.padding_right=6 \
	background.drawing=on \
	label.padding_right=10 \
	label.max_chars=23 \
	associated_display=active \
	updates=on \
	script="$PLUGIN_DIR/spotify.sh" \
	--subscribe spotify media_change
