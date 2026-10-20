#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh"
source "$HOME/.config/sketchybar/plugins/hover.sh"

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ "$PERCENTAGE" = "" ]; then
	exit 0
fi

case ${PERCENTAGE} in
9[0-9] | 100)
	ICON=""
	;;
[6-8][0-9])
	ICON=""
	;;
[3-5][0-9])
	ICON=""
	;;
[1-2][0-9])
	ICON=""
	;;
*) ICON="" ;;
esac

if [ "$CHARGING" != "" ]; then
	ICON=""
fi

if [ "$CHARGING" != "" ]; then
	COLOR=$GREEN
elif [ "$PERCENTAGE" -le 10 ]; then
	COLOR=$RED
elif [ "$PERCENTAGE" -le 20 ]; then
	COLOR=$ORANGE
else
	COLOR=$ICON_COLOR
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%"
