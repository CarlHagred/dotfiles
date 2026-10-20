#!/usr/bin/env bash
# Progress slider click: jump to that position in the current track.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"

[ "$SENDER" = "mouse.clicked" ] || exit 0
case "$PERCENTAGE" in '' | *[!0-9]*) exit 0 ;; esac

STATE_FILE="$STATE_DIR/media.json"
APP="$(jq -r '.app // "Spotify"' "$STATE_FILE" 2>/dev/null)"
DURATION="$(jq -r '.duration // 0' "$STATE_FILE" 2>/dev/null)"
[ "${DURATION:-0}" -gt 0 ] || exit 0

osascript -e "tell application \"$APP\" to set player position to $((DURATION * PERCENTAGE / 100))" >/dev/null 2>&1
