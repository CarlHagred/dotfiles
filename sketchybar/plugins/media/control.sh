#!/usr/bin/env bash
# Click handler of the controls row: the left third is "previous", the middle "play/pause",
# the right third "next". The click position comes from the mouse location.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"

APP="$(jq -r '.app // "Spotify"' "$STATE_DIR/media.json" 2>/dev/null)"

read -r MX _ < <("$SB_HELPER" mouse)
read -r X W < <(sketchybar --query media.controls |
	jq -r '.bounding_rects | to_entries[] | .value | select(.origin[0] > -9000) | "\(.origin[0] | floor) \(.size[0] | floor)"' |
	head -1)

THIRD=$((W / 3))
if [ "$MX" -lt $((X + THIRD)) ]; then
	ACTION="previous track"
elif [ "$MX" -gt $((X + 2 * THIRD)) ]; then
	ACTION="next track"
else
	ACTION="playpause"
fi

osascript -e "tell application \"$APP\" to $ACTION" >/dev/null 2>&1
