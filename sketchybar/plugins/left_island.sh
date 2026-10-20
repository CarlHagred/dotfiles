#!/usr/bin/env bash

# (Re)builds the glass island around the workspaces, divider and front app.

source "$HOME/.config/sketchybar/variables.sh"
source "$HOME/.config/sketchybar/style.sh"

MEMBERS=$(sketchybar --query bar | jq -r '.items[]' | grep -E '^(space\..*|aerospace_arrow|front_app)$' | tr '\n' ' ')
[ -z "$MEMBERS" ] && exit 0

sketchybar --remove left_island >/dev/null 2>&1
sketchybar --add bracket left_island $MEMBERS --set left_island "${BRACKET_STYLE[@]}"
