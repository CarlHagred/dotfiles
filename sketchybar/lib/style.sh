# Shared style building blocks (arrays of SketchyBar properties). Sourced by sketchybarrc.
# Usage: sketchybar --set <item> "${ISLAND_STYLE[@]}" ...   (later arguments override earlier ones)

# --- Bar --------------------------------------------------------------------

# A standalone island: one item drawn as a rounded glass pill
ISLAND_STYLE=(
	background.drawing=on
	background.color="$ISLAND_BG"
	background.border_color="$ISLAND_BORDER"
	background.border_width="$BORDER_WIDTH"
	background.corner_radius="$CORNER_RADIUS"
	background.height="$ITEM_HEIGHT"
	background.shadow.drawing=off
	background.padding_left=0
	background.padding_right=0
)

# The shell a bracket draws around several items
BRACKET_STYLE=(
	background.drawing=on
	background.color="$ISLAND_BG"
	background.border_color="$ISLAND_BORDER"
	background.border_width="$BORDER_WIDTH"
	background.corner_radius="$CORNER_RADIUS"
	background.height="$ITEM_HEIGHT"
	background.shadow.drawing=off
)

# An item living inside a bracket: hover pill, transparent until hovered
PILL_STYLE=(
	background.drawing=on
	background.color="$TRANSPARENT"
	background.corner_radius="$PILL_RADIUS"
	background.height="$PILL_HEIGHT"
	background.border_width=0
	background.padding_left=3
	background.padding_right=3
	icon.padding_left=9
	icon.padding_right=5
	label.padding_left=0
	label.padding_right=9
)

# Thin vertical separator between pills
DIVIDER_STYLE=(
	icon.drawing=off
	label.drawing=off
	width=1
	background.drawing=on
	background.color="$DIVIDER_COLOR"
	background.height=14
	background.corner_radius=1
	background.padding_left=2
	background.padding_right=2
)

# spacer <name> <position>: invisible gap between islands
spacer() {
	sketchybar --add item "gap.$1" "$2" \
		--set "gap.$1" width="$GAP" icon.drawing=off label.drawing=off background.drawing=off
}

# --- Popups -----------------------------------------------------------------

# Popup attached to an island (clock, media) or to a pill inside the status island
POPUP_ISLAND_STYLE=(
	popup.y_offset=8
	popup.height=24
	popup.background.corner_radius="$POPUP_CORNER_RADIUS"
	popup.background.shadow.drawing="$POPUP_SHADOW"
)
POPUP_PILL_STYLE=(
	popup.y_offset=10
	popup.height=26
	popup.background.corner_radius="$POPUP_CORNER_RADIUS"
	popup.background.shadow.drawing="$POPUP_SHADOW"
)

# Generic popup row
POPUP_ROW_STYLE=(
	icon.font="$FONT:Bold:13.5"
	icon.color="$ACCENT"
	icon.padding_left=12
	icon.padding_right=4
	label.font="$FONT:Bold:13.0"
	label.color="$LABEL_COLOR"
	label.padding_left=4
	label.padding_right=12
	background.color="$TRANSPARENT"
	background.corner_radius=8
	background.height=24
	background.padding_left=6
	background.padding_right=6
	background.drawing=off
)

# Text-only row with a fixed width (network and battery popups)
INFO_ROW_STYLE=(
	"${POPUP_ROW_STYLE[@]}"
	icon.drawing=off
	label.padding_left=14
	label.padding_right=14
	label.width=230
	label.align=left
)

# Thin horizontal rule; pass the popup's width: --set <item> "${POPUP_RULE_STYLE[@]}" width=200
POPUP_RULE_STYLE=(
	icon.drawing=off
	label.drawing=off
	background.drawing=on
	background.height=1
	background.color="$DIVIDER_COLOR"
)

# Slider track and knob (volume and media progress); each popup sets height and radius
SLIDER_STYLE=(
	icon.drawing=off
	label.drawing=off
	slider.highlight_color="$ACCENT"
	slider.background.color=0x33ffffff
	slider.knob="●"
	slider.knob.color="$WHITE"
	background.padding_left=14
	background.padding_right=14
)
