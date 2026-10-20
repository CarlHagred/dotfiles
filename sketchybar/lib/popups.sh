# Shared popup handling. Source this file (after lib/common.sh), then call
# popup_toggle <item> [refresh command...].
#   - opening a popup closes all the others
#   - lib/popup_watch.sh closes it once the mouse has been away from the item and its popup

POPUP_PARENTS=(clock volume network battery media)

popup_close_others() {
	local p args=()
	for p in "${POPUP_PARENTS[@]}"; do
		[ "$p" = "$1" ] || args+=(--set "$p" popup.drawing=off)
	done
	sketchybar "${args[@]}" 2>/dev/null
}

popup_close_all() {
	popup_close_others ""
}

popup_toggle() {
	local name="$1"
	shift
	if popup_is_open "$name"; then
		sketchybar --set "$name" popup.drawing=off
		return
	fi
	popup_close_others "$name"
	"$@"
	sketchybar --set "$name" popup.drawing=on
	nohup "$LIB_DIR/popup_watch.sh" "$name" >/dev/null 2>&1 &
}
