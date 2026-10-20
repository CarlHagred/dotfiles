#!/usr/bin/env bash
# Month navigation for the calendar popup.
#   scroll over any row : previous / next month
#   click the title     : left = next month, right = previous month
#   click "Today"       : back to the current month

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"

STATE="$STATE_DIR/cal_offset"
OFFSET="$(cat "$STATE" 2>/dev/null || echo 0)"
case "$OFFSET" in '' | *[!0-9-]*) OFFSET=0 ;; esac

case "$SENDER" in
"mouse.scrolled")
	# Scroll events arrive in bursts, so only act on one every 200 ms
	NOW=$(perl -MTime::HiRes=time -e 'printf "%d", time*1000')
	LAST="$(cat "$STATE.t" 2>/dev/null || echo 0)"
	[ $((NOW - LAST)) -lt 200 ] && exit 0
	echo "$NOW" >"$STATE.t"
	if [ "${SCROLL_DELTA:-0}" -gt 0 ] 2>/dev/null; then
		OFFSET=$((OFFSET - 1))
	elif [ "${SCROLL_DELTA:-0}" -lt 0 ] 2>/dev/null; then
		OFFSET=$((OFFSET + 1))
	else
		exit 0
	fi
	;;
"mouse.clicked")
	case "$NAME" in
	clock.cal.today) OFFSET=0 ;;
	*)
		if [ "$BUTTON" = "right" ]; then OFFSET=$((OFFSET - 1)); else OFFSET=$((OFFSET + 1)); fi
		;;
	esac
	;;
*) exit 0 ;;
esac

echo "$OFFSET" >"$STATE"
"$PLUGIN_DIR/clock/popup.sh"
