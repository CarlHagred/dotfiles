#!/usr/bin/env bash
# Closes the popup of <item> once the mouse has stayed away from the item and its popup
# for about a second. Runs only while the popup is open.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"

PARENT="$1"
PIDFILE="$STATE_DIR/popup_watch_$PARENT.pid"
MARGIN=14 # Points around the item and popup that still count as "inside"
AWAY_TICKS=4 # Consecutive 0.25 s ticks outside before the popup closes

[ -f "$PIDFILE" ] && kill "$(cat "$PIDFILE")" 2>/dev/null
echo $$ >"$PIDFILE"
trap 'rm -f "$PIDFILE"' EXIT

# Prints "x1 y1 x2 y2" covering the parent item and its popup
bounds() {
	local names=("$PARENT") n
	while IFS= read -r n; do names+=("$n"); done < <(sketchybar --query "$PARENT" | jq -r '.popup.items[]')
	for n in "${names[@]}"; do
		sketchybar --query "$n"
	done | jq -rs '
		[ .[] | .bounding_rects | to_entries[] | .value
		  | select(.origin[0] > -9000) ]
		| if length == 0 then empty else
		  [ (map(.origin[0]) | min), (map(.origin[1]) | min),
		    (map(.origin[0] + .size[0]) | max), (map(.origin[1] + .size[1]) | max) ]
		  | map(floor) | @tsv end'
}

sleep 0.5
read -r X1 Y1 X2 Y2 < <(bounds)
away=0
tick=0

while true; do
	sleep 0.25
	popup_is_open "$PARENT" || exit 0

	tick=$((tick + 1))
	if [ $((tick % 12)) -eq 0 ]; then
		read -r X1 Y1 X2 Y2 < <(bounds)
	fi
	[ -z "$X1" ] && continue

	read -r MX MY < <("$SB_HELPER" mouse)
	if [ "$MX" -ge $((X1 - MARGIN)) ] && [ "$MX" -le $((X2 + MARGIN)) ] &&
		[ "$MY" -ge $((Y1 - MARGIN)) ] && [ "$MY" -le $((Y2 + MARGIN)) ]; then
		away=0
	else
		away=$((away + 1))
		if [ "$away" -ge "$AWAY_TICKS" ]; then
			sketchybar --set "$PARENT" popup.drawing=off
			exit 0
		fi
	fi
done
