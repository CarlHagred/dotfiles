#!/usr/bin/env bash
# Volume slider click: set the output volume (and unmute).

[ "$SENDER" = "mouse.clicked" ] || exit 0
case "$PERCENTAGE" in '' | *[!0-9]*) exit 0 ;; esac

"${CONFIG_DIR:-$HOME/.config/sketchybar}/helpers/bin/sbhelper" set-volume "$PERCENTAGE"
