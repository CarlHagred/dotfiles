#!/usr/bin/env bash
# Shows the next few calendar events (icalBuddy) at the bottom of the clock popup.
# Results are cached for a minute.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"

CACHE="$STATE_DIR/cal_events"
MAX=5

if [ ! -f "$CACHE" ] || [ -n "$(find "$CACHE" -mmin +1 2>/dev/null)" ]; then
	timeout 10 icalBuddy -n -nc -nrd -eed -iep "title,datetime" -po "datetime,title" \
		-ps "| ~ |" -b "" -ss "" -df "%a %d" -tf "%H:%M" eventsToday+7 2>/dev/null |
		sed -E 's/ - [0-9]{2}:[0-9]{2}//; s/ ~ /  /' >"$CACHE.tmp" && mv "$CACHE.tmp" "$CACHE"
fi

ARGS=()
count=0
while IFS= read -r line; do
	[ -z "$line" ] && continue
	count=$((count + 1))
	[ "$count" -gt "$MAX" ] && break
	ARGS+=(--set "clock.ev.$count" drawing=on label="$line")
done <"$CACHE"

for ((i = count + 1; i <= MAX; i++)); do
	ARGS+=(--set "clock.ev.$i" drawing=off)
done

if [ "$count" -eq 0 ]; then
	ARGS+=(--set clock.ev.hdr label="NO EVENTS THIS WEEK")
else
	ARGS+=(--set clock.ev.hdr label="UPCOMING")
fi

sketchybar "${ARGS[@]}" 2>/dev/null
