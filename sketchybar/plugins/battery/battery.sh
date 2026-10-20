#!/usr/bin/env bash
# Battery pill: icon and percentage, coloured by state, hover and popup.
# Left click toggles the popup, right click opens Battery settings.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"
source "$LIB_DIR/hover.sh"

if [ "$SENDER" = "mouse.clicked" ]; then
	source "$LIB_DIR/popups.sh"
	if [ "$BUTTON" = "right" ]; then
		popup_close_all
		open_settings Battery
	else
		popup_toggle "$NAME" "$PLUGIN_DIR/battery/popup.sh"
	fi
	exit 0
fi

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
