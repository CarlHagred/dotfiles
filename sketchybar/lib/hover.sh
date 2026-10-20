# Sourced by item scripts to animate hover. Expects lib/common.sh to be loaded and exits the
# calling script when it handled the event.
#   pills (default): a tinted background fades in on mouse.entered and out on mouse.exited
#   islands:         set HOVER_STYLE=island first; only the border brightens, the glass stays solid

case "$SENDER" in
"mouse.entered")
	if [ "$HOVER_STYLE" = "island" ]; then
		sketchybar --animate tanh 8 --set "$NAME" background.border_color="$ISLAND_BORDER_HOVER"
	else
		sketchybar --animate tanh 8 --set "$NAME" background.color="$HOVER_BG"
	fi
	exit 0
	;;
"mouse.exited")
	if [ "$HOVER_STYLE" = "island" ]; then
		sketchybar --animate tanh 8 --set "$NAME" background.border_color="$ISLAND_BORDER"
	else
		sketchybar --animate tanh 8 --set "$NAME" background.color="$TRANSPARENT"
	fi
	exit 0
	;;
esac
