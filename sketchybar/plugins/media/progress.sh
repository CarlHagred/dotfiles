#!/usr/bin/env bash
# Moves the progress slider to the current playback position.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"

STATE_FILE="$STATE_DIR/media.json"
[ -f "$STATE_FILE" ] || exit 0
APP="$(jq -r '.app' "$STATE_FILE")"
DURATION="$(jq -r '.duration' "$STATE_FILE")"
[ "${DURATION:-0}" -gt 0 ] || exit 0

POS="$(osascript -e "tell application \"$APP\" to return player position as text" 2>/dev/null | tr ',' '.')"
[ -z "$POS" ] && exit 0

PERCENT=$(awk -v p="$POS" -v d="$DURATION" 'BEGIN { v = int(p * 100 / d); if (v > 100) v = 100; if (v < 0) v = 0; print v }')
sketchybar --set media.progress slider.percentage="$PERCENT"
