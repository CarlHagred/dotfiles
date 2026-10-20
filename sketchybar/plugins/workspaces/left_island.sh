#!/usr/bin/env bash
# (Re)builds the glass island around the workspaces, divider and front app.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"
source "$LIB_DIR/style.sh"

MEMBERS=$(sketchybar --query bar | jq -r '.items[]' | grep -E '^(space\..*|workspace_divider|front_app)$' | tr '\n' ' ')
[ -z "$MEMBERS" ] && exit 0

sketchybar --remove left_island >/dev/null 2>&1
# shellcheck disable=SC2086 # MEMBERS is a list of item names
sketchybar --add bracket left_island $MEMBERS --set left_island "${BRACKET_STYLE[@]}"
