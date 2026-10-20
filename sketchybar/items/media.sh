#!/usr/bin/env bash
# Media island (Spotify and Apple Music), left of the notch. Fed by the apps' own change
# notifications. Popup: artwork, title, artist, progress slider and playback controls.

sketchybar --add event spotify_change "com.spotify.client.PlaybackStateChanged" \
	--add event music_change "com.apple.Music.playerInfo"

sketchybar --add item media q \
	--set media \
	"${ISLAND_STYLE[@]}" \
	drawing=off \
	scroll_texts=on \
	icon=󰎆 \
	icon.color="$ACCENT" \
	icon.padding_left=12 \
	icon.padding_right=6 \
	label.color="$LABEL_COLOR" \
	label.padding_left=0 \
	label.padding_right=14 \
	label.max_chars=23 \
	associated_display=active \
	updates=on \
	update_freq=2 \
	popup.align=center \
	"${POPUP_ISLAND_STYLE[@]}" \
	script="$PLUGIN_DIR/media/media.sh" \
	--subscribe media spotify_change music_change mouse.clicked mouse.entered mouse.exited

# Popup: artwork, title, artist, progress, controls (filled by plugins/media/popup.sh)
MEDIA_WIDTH=220
MEDIA_ROW=("${POPUP_ROW_STYLE[@]}"
	icon.drawing=off
	label.padding_left=14
	label.padding_right=14
	label.width="$MEDIA_WIDTH"
	label.align=center)

sketchybar \
	--add item media.art popup.media \
	--set media.art \
	icon.drawing=off label.drawing=off drawing=off \
	width="$MEDIA_WIDTH" \
	background.drawing=on \
	background.color="$TRANSPARENT" \
	background.height="$MEDIA_WIDTH" \
	background.corner_radius=12 \
	background.padding_left=12 \
	background.padding_right=12 \
	background.image.corner_radius=12 \
	background.image.scale=0.5 \
	background.image.drawing=on \
	\
	--add item media.title popup.media \
	--set media.title "${MEDIA_ROW[@]}" label.max_chars=26 \
	--add item media.artist popup.media \
	--set media.artist "${MEDIA_ROW[@]}" label.color="$ICON_DIM_COLOR" label.max_chars=28 \
	\
	--add slider media.progress popup.media 200 \
	--set media.progress \
	"${SLIDER_STYLE[@]}" \
	slider.background.height=6 \
	slider.background.corner_radius=3 \
	script="$PLUGIN_DIR/media/seek.sh" \
	--subscribe media.progress mouse.clicked \
	\
	--add item media.controls popup.media \
	--set media.controls "${MEDIA_ROW[@]}" \
	label="󰒮     󰐊     󰒭" \
	label.font="$FONT:Bold:18.0" \
	label.color="$LABEL_COLOR" \
	background.height=32 \
	click_script="$PLUGIN_DIR/media/control.sh"
