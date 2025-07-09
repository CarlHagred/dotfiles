#!/usr/bin/env bash

set -e

echo "🔧 Setting up your macOS environment..."

# Install Xcode Command Line Tools if missing
if ! xcode-select -p &>/dev/null; then
  echo "🛠 Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "ℹ️ Please re-run this script after the tools finish installing."
  exit 1
else
  echo "✅ Xcode Command Line Tools already installed."
fi

# Ensure Homebrew is installed
if ! command -v brew &>/dev/null; then
  echo "🍺 Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew already installed."
fi

# Install packages from Brewfile
echo "📦 Installing Homebrew packages..."
brew bundle --file="$HOME/.config/homebrew/Brewfile"

# Set Fish as default shell if not already
if [ "$SHELL" != "/opt/homebrew/bin/fish" ]; then
  echo "🐟 Setting Fish as default shell..."
  chsh -s /opt/homebrew/bin/fish
fi

echo "✅ All done! Restart your terminal to apply changes."
