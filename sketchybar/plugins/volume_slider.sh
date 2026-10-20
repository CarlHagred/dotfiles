#!/usr/bin/env bash

[ "$SENDER" = "mouse.clicked" ] || exit 0
case "$PERCENTAGE" in '' | *[!0-9]*) exit 0 ;; esac

osascript -e "set volume output volume $PERCENTAGE" -e "set volume without output muted"
