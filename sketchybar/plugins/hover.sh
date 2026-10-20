#!/usr/bin/env bash

# Sourced by item plugins to animate the hover pill of an item:
#   mouse.entered -> tinted pill, mouse.exited -> transparent again
source "$HOME/.config/sketchybar/variables.sh"

case "$SENDER" in
"mouse.entered")
	sketchybar --animate tanh 8 --set "$NAME" background.color="$HOVER_BG"
	exit 0
	;;
"mouse.exited")
	sketchybar --animate tanh 8 --set "$NAME" background.color="$TRANSPARENT"
	exit 0
	;;
esac
