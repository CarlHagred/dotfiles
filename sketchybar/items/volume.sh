#!/usr/bin/env bash

COLOR="$ICON_COLOR"

sketchybar \
	--add item volume right \
	--set volume \
	icon.color="$COLOR" \
	icon.padding_left=10 \
	label.color="$COLOR" \
	label.padding_right=10 \
	background.height=26 \
	background.corner_radius="$CORNER_RADIUS" \
	background.padding_right=5 \
	background.border_width="$BORDER_WIDTH" \
	background.border_color="$ITEM_BORDER_COLOR" \
	background.color="$ITEM_BG_COLOR" \
	background.shadow.drawing=off \
	background.drawing=on \
	popup.align=right \
	popup.y_offset=6 \
	popup.height=26 \
	script="$PLUGIN_DIR/sound.sh" \
	--subscribe volume volume_change mouse.clicked mouse.scrolled mouse.exited.global

# Popup: volume slider, mute toggle, then output devices (rebuilt by plugins/audio_devices.sh)
POPUP_ROW_DEFAULTS=(
	icon.font="$FONT:Bold:13.5"
	icon.color="$HIGHLIGHT_COLOR"
	icon.padding_left=12
	icon.padding_right=4
	label.font="$FONT:Bold:13.0"
	label.color="$LABEL_COLOR"
	label.padding_left=4
	label.padding_right=12
	background.color="$TRANSPARENT"
	background.corner_radius=6
	background.height=22
	background.padding_left=6
	background.padding_right=6
	background.drawing=off
)

sketchybar \
	--add slider volume.slider popup.volume 180 \
	--set volume.slider \
	icon.drawing=off \
	label.drawing=off \
	slider.highlight_color="$HIGHLIGHT_COLOR" \
	slider.background.height=6 \
	slider.background.corner_radius=3 \
	slider.background.color=0x44ffffff \
	slider.knob="●" \
	slider.knob.color="$WHITE" \
	background.padding_left=12 \
	background.padding_right=12 \
	script="$PLUGIN_DIR/volume_slider.sh" \
	--subscribe volume.slider mouse.clicked \
	\
	--add item volume.mute popup.volume \
	--set volume.mute "${POPUP_ROW_DEFAULTS[@]}" \
	icon="󰖁" \
	label="Mute" \
	click_script="$PLUGIN_DIR/audio_mute.sh" \
	\
	--add item volume.sep popup.volume \
	--set volume.sep \
	icon.drawing=off \
	label.drawing=off \
	width=190 \
	background.drawing=on \
	background.height=1 \
	background.color="$ITEM_BORDER_COLOR"
