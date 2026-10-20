#!/usr/bin/env bash
# Fills the clock popup with `cal` output for the month in the offset file
# (0 = current month). Today's week is highlighted when the current month is shown.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"

OFFSET="$(cat "$STATE_DIR/cal_offset" 2>/dev/null || echo 0)"
case "$OFFSET" in '' | *[!0-9-]*) OFFSET=0 ;; esac

WIDTH=20 # `cal` rows are 20 characters wide
TODAY=$((10#$(date +%d)))
MONTH_SHIFT="$(printf '%+d' "$OFFSET")"
read -r MONTH YEAR < <(date -v1d -v"${MONTH_SHIFT}m" '+%m %Y')

ARGS=()
if [ "$OFFSET" -eq 0 ]; then
	ARGS+=(--set clock.cal.title label="$(date '+%a %d %B · W%V')" --set clock.cal.today drawing=off)
else
	ARGS+=(--set clock.cal.title label="$(date -v1d -v"${MONTH_SHIFT}m" '+%B %Y')" --set clock.cal.today drawing=on)
fi

# macOS `cal` prints: month title, weekday header, up to 6 week rows
CAL_LINES=()
while IFS= read -r line; do
	CAL_LINES+=("$line")
done < <(cal "$((10#$MONTH))" "$YEAR")

ARGS+=(--set clock.cal.head label="$(printf "%-${WIDTH}s" "${CAL_LINES[1]}")")

for i in 1 2 3 4 5 6; do
	row="${CAL_LINES[$((i + 1))]}"
	name="clock.cal.w$i"

	if [ -z "${row// /}" ]; then
		ARGS+=(--set "$name" drawing=off)
		continue
	fi

	row="$(printf "%-${WIDTH}s" "$row")"
	if [ "$OFFSET" -eq 0 ] && echo "$row" | grep -Eq "(^| )$TODAY( |$)"; then
		ARGS+=(--set "$name" drawing=on label="$row" label.color="$ACCENT" \
			background.drawing=on background.color="$ACCENT_TINT")
	else
		ARGS+=(--set "$name" drawing=on label="$row" label.color="$LABEL_COLOR" \
			background.drawing=off)
	fi
done

sketchybar "${ARGS[@]}"

# Upcoming events are loaded in the background (icalBuddy can take a moment)
nohup "$PLUGIN_DIR/clock/events.sh" >/dev/null 2>&1 &
