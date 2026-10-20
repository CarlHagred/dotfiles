#!/usr/bin/env bash
# Downloads / extracts the artwork of the current track and records its path in the state file.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"

STATE_FILE="$STATE_DIR/media.json"
ART_DIR="$STATE_DIR/art"
mkdir -p "$ART_DIR"

[ -f "$STATE_FILE" ] || exit 0
APP="$(jq -r '.app' "$STATE_FILE")"
TRACK="$(jq -r '.track' "$STATE_FILE")"
[ -z "$TRACK" ] && exit 0

ART="$ART_DIR/$(printf '%s' "$APP$TRACK" | md5 -q).jpg"

if [ ! -s "$ART" ]; then
	case "$APP" in
	Spotify)
		URL="$(osascript -e 'tell application "Spotify" to artwork url of current track' 2>/dev/null)"
		[ -n "$URL" ] && curl -sL -m 8 -o "$ART" "$URL"
		;;
	Music)
		osascript >/dev/null 2>&1 <<OSA
tell application "Music"
	set d to raw data of artwork 1 of current track
end tell
set f to open for access POSIX file "$ART" with write permission
set eof f to 0
write d to f
close access f
OSA
		;;
	esac
	# Keep the popup crisp but small (the popup draws it at half size)
	[ -s "$ART" ] && sips -Z 440 "$ART" >/dev/null 2>&1
fi

if [ -s "$ART" ]; then
	jq --arg art "$ART" '.art = $art' "$STATE_FILE" >"$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
else
	jq 'del(.art)' "$STATE_FILE" >"$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
fi

popup_is_open media && "$PLUGIN_DIR/media/popup.sh"
exit 0
