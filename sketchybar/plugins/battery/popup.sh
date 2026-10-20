#!/usr/bin/env bash
# Fills the battery popup. Everything comes from pmset / ioreg, which are fast.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"

row() { printf '%-9s%s' "$1" "$2"; }

BATT="$(pmset -g batt)"
SOURCE="$(echo "$BATT" | head -1 | sed -E "s/.*'(.*)'.*/\1/")"
PERCENT="$(echo "$BATT" | grep -Eo '[0-9]+%' | head -1)"
STATE="$(echo "$BATT" | sed -nE 's/.*[0-9]+%; ([a-z ]+);.*/\1/p' | head -1)"
REMAIN="$(echo "$BATT" | grep -Eo '[0-9]+:[0-9]+ remaining' | head -1 | awk '{print $1}')"

IO="$(ioreg -rn AppleSmartBattery)"
CYCLES="$(echo "$IO" | grep -Eo '"CycleCount" = [0-9]+' | awk '{print $3}')"
FULL="$(echo "$IO" | grep -Eo '"FullChargeCapacity"=[0-9]+' | head -1 | cut -d= -f2)"
DESIGN="$(echo "$IO" | grep -Eo '"DesignCapacity"=[0-9]+' | head -1 | cut -d= -f2)"

HEALTH="n/a"
if [ -n "$FULL" ] && [ -n "$DESIGN" ] && [ "$DESIGN" -gt 0 ]; then
	HEALTH="$((FULL * 100 / DESIGN))%"
fi

case "$STATE" in
charging) TIME_LABEL="To full" ;;
*) TIME_LABEL="Left" ;;
esac
[ -z "$REMAIN" ] && REMAIN="calculating…"
[ "$STATE" = "charged" ] || [ "$STATE" = "finishing charge" ] && REMAIN="—"

sketchybar --set battery.title label="$(tr '[:lower:]' '[:upper:]' <<<"${STATE:0:1}")${STATE:1} · $PERCENT" \
	--set battery.time label="$(row "$TIME_LABEL" "$REMAIN")" \
	--set battery.source label="$(row "Source" "$SOURCE")" \
	--set battery.health label="$(row "Health" "$HEALTH")" \
	--set battery.cycles label="$(row "Cycles" "${CYCLES:-n/a}")"
