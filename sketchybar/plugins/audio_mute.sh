#!/usr/bin/env bash

osascript -e 'set volume output muted (not (output muted of (get volume settings)))'
NAME=volume SENDER=forced "$HOME/.config/sketchybar/plugins/sound.sh"
