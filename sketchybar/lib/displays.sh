# Display helpers. Source this file (after lib/common.sh).
#   main_display                -> SketchyBar display id of the main display (the one at 0,0)
#   display_for_screen <index>  -> SketchyBar display id for an AeroSpace / NSScreen index
#   apply_status_display        -> keeps the status island on the main display only

# Items that make up the status island
STATUS_ITEMS=(privacy div.0 network div.1 battery div.2 volume status_island)

main_display() {
	sketchybar --query displays |
		jq -r '[.[] | select(.frame.x == 0 and .frame.y == 0)][0]["arrangement-id"] // 1'
}

display_for_screen() {
	local x w
	read -r x w < <("$SB_HELPER" screens | awk -v i="$1" '$1 == i {print $2, $3}')
	[ -z "$x" ] && return
	sketchybar --query displays | jq -r --argjson x "$x" --argjson w "$w" \
		'[.[] | select((.frame.x | floor) == $x and (.frame.w | floor) == $w)][0]["arrangement-id"] // empty'
}

apply_status_display() {
	local main item args=()
	main="$(main_display)"
	for item in "${STATUS_ITEMS[@]}"; do
		args+=(--set "$item" display="$main")
	done
	sketchybar "${args[@]}" 2>/dev/null
}
