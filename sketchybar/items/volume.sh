#!/usr/bin/env bash

sketchybar \
	--add item volume right \
	--set volume \
	"${PILL_STYLE[@]}" \
	icon.color="$ICON_COLOR" \
	label.color="$LABEL_COLOR" \
	popup.align=right \
	popup.y_offset=10 \
	popup.height=26 \
	popup.background.corner_radius="$POPUP_CORNER_RADIUS" \
	popup.background.shadow.drawing="$POPUP_SHADOW" \
	script="$PLUGIN_DIR/sound.sh" \
	--subscribe volume volume_change mouse.clicked mouse.scrolled mouse.exited.global mouse.entered mouse.exited

# Popup: volume slider, mute toggle, then output devices (rebuilt by plugins/audio_devices.sh)
sketchybar \
	--add slider volume.slider popup.volume 190 \
	--set volume.slider \
	icon.drawing=off \
	label.drawing=off \
	slider.highlight_color="$ACCENT" \
	slider.background.height=8 \
	slider.background.corner_radius=4 \
	slider.background.color=0x33ffffff \
	slider.knob="●" \
	slider.knob.color="$WHITE" \
	background.padding_left=14 \
	background.padding_right=14 \
	script="$PLUGIN_DIR/volume_slider.sh" \
	--subscribe volume.slider mouse.clicked \
	\
	--add item volume.mute popup.volume \
	--set volume.mute "${POPUP_ROW_STYLE[@]}" \
	icon="󰖁" \
	label="Mute" \
	click_script="$PLUGIN_DIR/audio_mute.sh" \
	\
	--add item volume.sep popup.volume \
	--set volume.sep \
	icon.drawing=off \
	label.drawing=off \
	width=200 \
	background.drawing=on \
	background.height=1 \
	background.color="$DIVIDER_COLOR"
