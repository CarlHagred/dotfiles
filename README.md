# 🛠️ My macOS Dotfiles

Welcome to my dotfiles! This repo sets up my macOS development environment, including:

- 💻 Shell (Fish)
- 🧰 CLI tools via Homebrew
- 🪟 Terminal (Ghostty)
- 🧠 Editor (Zed)
- ⚙️ Custom aliases and settings

Everything is organized under `~/.config/` and tracked here for portability and versioning.

---

## 📦 Requirements

Before using these dotfiles, make sure you have:

- macOS (tested on Sonoma or later)
- Xcode Command Line Tools:
  ```sh
  xcode-select --install
  ```
- Git
- Homebrew (install if missing):
  ```sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```

---

## 🚀 Installation

You can clone this repo into your `.config` directory:

```sh
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.config
```

> Or clone it anywhere and symlink the relevant files into `~/.config`.

---

## 🍺 Install Homebrew Packages

This installs all command-line tools and apps from your saved `Brewfile`:

```sh
brew bundle --file=~/.config/homebrew/Brewfile
```

Includes:

- Tools: `fish`, `fzf`, `eza`, `uv`, `zoxide`, `azure-cli`, `azure-functions-core-tools@4`
- GUI apps: `1Password`, `Raycast`, `Ghostty`, `Karabiner-Elements`, `Zed`, `Obsidian`, `Windows App`

---

## 🐟 Fish Shell Setup

Set Fish as your default shell (if not already):

```sh
chsh -s /opt/homebrew/bin/fish
```

Then link your config:

```sh
ln -sf ~/.config/fish/config.fish ~/.config/fish/config.fish
```

Your Fish config includes:

- Git and utility aliases
- Azure Functions helpers
- Starship prompt + Zoxide
- Custom `$PATH` additions

---

## 🪞 Terminal (Ghostty)

Your `~/.config/ghostty/config` includes:

- Font: JetBrainsMono Nerd Font
- Theme: Catppuccin Mocha
- Opacity: 85%

Install the font manually if needed:
https://www.nerdfonts.com/font-downloads

---

## 🧠 Zed Editor

Zed settings live in `~/.config/zed/settings.json`.

If Zed isn't installed:

```sh
brew install --cask zed
```

---

## 🧼 Recommended Extras

- [Starship Prompt](https://starship.rs): Fast, customizable shell prompt.
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads): For icons in terminal & Zed.
- [Karabiner Elements](https://karabiner-elements.pqrs.org): For advanced keyboard remapping.

---

## 📁 Directory Structure

```
.config/
├── fish/
│   └── config.fish
├── ghostty/
│   └── config
├── homebrew/
│   └── Brewfile
├── zed/
│   └── settings.json
```

---

## 🔄 Keeping It in Sync

After making changes:

```sh
cd ~/.config
git add .
git commit -m "Update dotfiles"
git push
```

---

## 💬 License & Attribution

This repo is for personal use, but feel free to fork or adapt!

- Theme: [Catppuccin](https://github.com/catppuccin)
- Fonts: [Nerd Fonts](https://www.nerdfonts.com)
