#!/usr/bin/env bash
# Media pill for Spotify and Apple Music. Both apps broadcast their own change
# notifications (spotify_change / music_change events); the current track is kept in a
# small JSON file ($STATE_DIR/media.json) shared with the popup scripts.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"

STATE_FILE="$STATE_DIR/media.json"

# render: updates the pill from the state file (playing / paused / hidden)
render() {
	local state title artist
	state="$(jq -r '.state // "stopped"' "$STATE_FILE" 2>/dev/null)"
	title="$(jq -r '.title // ""' "$STATE_FILE" 2>/dev/null)"
	artist="$(jq -r '.artist // ""' "$STATE_FILE" 2>/dev/null)"
	case "$state" in
	playing)
		sketchybar --set "$NAME" drawing=on icon.color="$ACCENT" label="$title - $artist"
		;;
	paused)
		sketchybar --set "$NAME" drawing=on icon.color="$ICON_DIM_COLOR" label="$title - $artist"
		;;
	*)
		sketchybar --set "$NAME" drawing=off
		;;
	esac
}

# save_state <app> <state> <title> <artist> <album> <duration seconds> <track id>
save_state() {
	jq -n --arg app "$1" --arg state "$2" --arg title "$3" --arg artist "$4" \
		--arg album "$5" --argjson duration "${6:-0}" --arg track "$7" \
		'{app:$app,state:$state,title:$title,artist:$artist,album:$album,duration:$duration,track:$track}' >"$STATE_FILE.tmp" &&
		mv "$STATE_FILE.tmp" "$STATE_FILE"
}

# refresh_popup: keeps an open popup in sync with the state file
refresh_popup() {
	popup_is_open "$NAME" && "$PLUGIN_DIR/media/popup.sh"
}

lower() { echo "$1" | tr '[:upper:]' '[:lower:]'; }

# handle_notification <app> <duration jq expression> <track id jq expression>
handle_notification() {
	local app="$1" duration_expr="$2" track_expr="$3" state
	state="$(lower "$(echo "$INFO" | jq -r '."Player State" // "stopped"')")"
	save_state "$app" "$state" \
		"$(echo "$INFO" | jq -r '.Name // ""')" \
		"$(echo "$INFO" | jq -r '.Artist // ""')" \
		"$(echo "$INFO" | jq -r '.Album // ""')" \
		"$(echo "$INFO" | jq -r "(($duration_expr) / 1000) | floor")" \
		"$(echo "$INFO" | jq -r "$track_expr")"
	render
	refresh_popup
	nohup "$PLUGIN_DIR/media/art.sh" >/dev/null 2>&1 &
}

case "$SENDER" in
"spotify_change")
	handle_notification Spotify '.Duration // 0' '."Track ID" // ""'
	;;
"music_change")
	handle_notification Music '."Total Time" // 0' '.PersistentID // .Name // ""'
	;;
"mouse.entered" | "mouse.exited")
	HOVER_STYLE=island
	source "$LIB_DIR/hover.sh"
	;;
"mouse.clicked")
	source "$LIB_DIR/popups.sh"
	if [ "$BUTTON" = "right" ]; then
		popup_close_all
		open -a "$(jq -r '.app // "Spotify"' "$STATE_FILE" 2>/dev/null)"
	else
		popup_toggle "$NAME" "$PLUGIN_DIR/media/popup.sh"
	fi
	;;
*)
	# Routine tick (and the initial update): pick up whatever is already playing,
	# hide the pill when the player quit, and move the progress slider while the popup is open
	if [ ! -f "$STATE_FILE" ]; then
		"$PLUGIN_DIR/media/poll.sh"
		render
		exit 0
	fi
	APP="$(jq -r '.app // ""' "$STATE_FILE")"
	if [ -n "$APP" ] && ! pgrep -x "$APP" >/dev/null; then
		rm -f "$STATE_FILE"
		render
		exit 0
	fi
	popup_is_open "$NAME" && "$PLUGIN_DIR/media/progress.sh"
	;;
esac
exit 0
