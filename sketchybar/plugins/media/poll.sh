#!/usr/bin/env bash
# Reads the current track straight from Spotify / Music when no notification has arrived yet
# (for example right after SketchyBar starts). Writes the shared state file.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"

STATE_FILE="$STATE_DIR/media.json"

for APP in Spotify Music; do
	pgrep -x "$APP" >/dev/null || continue
	RESULT="$(osascript 2>/dev/null <<OSA
tell application "$APP"
	if player state is stopped then return ""
	set s to player state as text
	set d to duration of current track
	set t to name of current track
	set a to artist of current track
	set al to album of current track
	return s & "|" & d & "|" & t & "|" & a & "|" & al
end tell
OSA
)"
	[ -z "$RESULT" ] && continue
	IFS='|' read -r STATE DURATION TITLE ARTIST ALBUM <<<"$RESULT"
	if [ "$APP" = "Spotify" ]; then
		DURATION=$((${DURATION%.*} / 1000)) # Spotify reports milliseconds
	else
		DURATION=${DURATION%.*}
	fi
	jq -n --arg app "$APP" --arg state "$STATE" --arg title "$TITLE" --arg artist "$ARTIST" \
		--arg album "$ALBUM" --argjson duration "${DURATION:-0}" \
		'{app:$app,state:$state,title:$title,artist:$artist,album:$album,duration:$duration,track:($title+$artist)}' >"$STATE_FILE"
	"$PLUGIN_DIR/media/art.sh" &
	exit 0
done
