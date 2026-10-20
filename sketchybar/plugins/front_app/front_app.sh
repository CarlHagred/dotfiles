#!/usr/bin/env bash
# Shows the name of the frontmost app (the front_app_switched event passes it in $INFO).

[ "$SENDER" = "front_app_switched" ] && sketchybar --set "$NAME" label="$INFO"
exit 0
