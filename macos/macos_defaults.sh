#!/usr/bin/env bash

# Fast key repeat for Vim editing
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

# macOS Spaces behavior (complements AeroSpace)

echo "Configuring Mission Control behavior..."
# Disable automatic rearranging of Spaces based on use
defaults write com.apple.dock mru-spaces -bool false

# Optional: make Spaces animation faster
defaults write com.apple.dock expose-animation-duration -float 0.1

# Restart Dock to apply
killall Dock

echo "✅ macOS defaults applied."
