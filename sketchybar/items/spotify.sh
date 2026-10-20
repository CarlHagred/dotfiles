#!/usr/bin/env bash

sketchybar --add item spotify q \
	--set spotify \
	"${ISLAND_STYLE[@]}" \
	scroll_texts=on \
	icon=󰎆 \
	icon.color="$ACCENT" \
	icon.padding_left=12 \
	icon.padding_right=6 \
	label.color="$LABEL_COLOR" \
	label.padding_left=0 \
	label.padding_right=14 \
	label.max_chars=23 \
	associated_display=active \
	updates=on \
	script="$PLUGIN_DIR/spotify.sh" \
	--subscribe spotify media_change
