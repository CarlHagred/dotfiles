#!/usr/bin/env bash
# Name of the frontmost app, shown inside the left island.

sketchybar \
	--add item front_app left \
	--set front_app script="$PLUGIN_DIR/front_app/front_app.sh" \
	icon.drawing=off \
	background.drawing=off \
	background.padding_left=0 \
	background.padding_right=0 \
	label.color="$LABEL_COLOR" \
	label.padding_left=4 \
	label.padding_right=14 \
	associated_display=active \
	--subscribe front_app front_app_switched
