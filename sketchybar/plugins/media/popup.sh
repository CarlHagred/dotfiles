#!/usr/bin/env bash
# Fills the media popup from the shared state file.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"

STATE_FILE="$STATE_DIR/media.json"
[ -f "$STATE_FILE" ] || exit 0

STATE="$(jq -r '.state' "$STATE_FILE")"
TITLE="$(jq -r '.title' "$STATE_FILE")"
ARTIST="$(jq -r '.artist' "$STATE_FILE")"
ALBUM="$(jq -r '.album' "$STATE_FILE")"
ART="$(jq -r '.art // ""' "$STATE_FILE")"

if [ "$STATE" = "playing" ]; then
	CONTROLS="󰒮     󰏤     󰒭"
else
	CONTROLS="󰒮     󰐊     󰒭"
fi

ARGS=(--set media.title label="$TITLE"
	--set media.artist label="$ARTIST${ALBUM:+ · $ALBUM}"
	--set media.controls label="$CONTROLS")

if [ -n "$ART" ] && [ -s "$ART" ]; then
	ARGS+=(--set media.art drawing=on background.image="$ART" background.image.drawing=on)
else
	ARGS+=(--set media.art drawing=off)
fi

sketchybar "${ARGS[@]}"
"$PLUGIN_DIR/media/progress.sh"
