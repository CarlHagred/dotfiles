#!/usr/bin/env bash
# Orange dot: microphone or camera in use. Red dot: both.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"

PRIVACY="$("$SB_HELPER" privacy)" # "mic=<0|1> cam=<0|1>"
MIC="${PRIVACY#mic=}"
MIC="${MIC%% *}"
CAM="${PRIVACY##*cam=}"

if [ "$MIC" = "1" ] && [ "$CAM" = "1" ]; then
	sketchybar --set privacy drawing=on icon.color="$RED" --set div.0 drawing=on
elif [ "$MIC" = "1" ] || [ "$CAM" = "1" ]; then
	sketchybar --set privacy drawing=on icon.color="$ORANGE" --set div.0 drawing=on
else
	sketchybar --set privacy drawing=off --set div.0 drawing=off
fi
