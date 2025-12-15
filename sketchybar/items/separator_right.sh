#!/usr/bin/env bash

sketchybar --add item separator_right right \
	--set separator_right \
	icon="│" \
	icon.color="$COMMENT" \
	icon.padding_left=5 \
	icon.padding_right=5 \
	label.drawing=off \
	background.drawing=off
