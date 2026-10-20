#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh"

WIDTH=20
TODAY=$((10#$(date +%d)))

# Title: today's date and ISO week number
sketchybar --set clock.cal.title label="$(printf "%-${WIDTH}s" "$(date '+%a %d %B · W%V')")"

# macOS `cal` prints: month title, weekday header, up to 6 week rows
LINES_OUT=()
while IFS= read -r line; do
	LINES_OUT+=("$line")
done < <(cal)

sketchybar --set clock.cal.head label="$(printf "%-${WIDTH}s" "${LINES_OUT[1]}")"

ARGS=()
for i in 1 2 3 4 5 6; do
	row="${LINES_OUT[$((i + 1))]}"
	name="clock.cal.w$i"

	if [ -z "${row// /}" ]; then
		ARGS+=(--set "$name" drawing=off)
		continue
	fi

	row="$(printf "%-${WIDTH}s" "$row")"
	if echo "$row" | grep -Eq "(^| )$TODAY( |$)"; then
		ARGS+=(--set "$name" drawing=on label="$row" label.color="$HIGHLIGHT_COLOR" \
			background.drawing=on background.color="$ITEM_ACTIVE_BG")
	else
		ARGS+=(--set "$name" drawing=on label="$row" label.color="$LABEL_COLOR" \
			background.drawing=off)
	fi
done

sketchybar "${ARGS[@]}"
