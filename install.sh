#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
    src="$1"
    dst="$2"

    [ -e "$src" ] || return 0

    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        echo "Already linked: $dst"
        return 0
    fi

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        mv "$dst" "$dst.bak.$(date +%Y%m%d-%H%M%S)"
    fi

    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "Linked: $dst"
}

echo "Linking dotfiles..."

link "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
link "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
link "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
link "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"

command -v alacritty >/dev/null 2>&1 && \
    link "$DOTFILES_DIR/.alacritty.toml" "$HOME/.alacritty.toml"

command -v conky >/dev/null 2>&1 && \
    link "$DOTFILES_DIR/.conkyrc" "$HOME/.conkyrc"

echo
echo "Checking tools..."

missing=()

has() {
    command -v "$1" >/dev/null 2>&1
}

has fzf || missing+=("fzf")
has rg || missing+=("ripgrep")
has tree || missing+=("tree")

if ! has fd && ! has fdfind; then
    missing+=("fd/fd-find")
fi

if ! has bat && ! has batcat; then
    missing+=("bat")
fi

if [ "${#missing[@]}" -gt 0 ]; then
    echo "Missing: ${missing[*]}"
    echo
    echo "Fedora:"
    echo "  sudo dnf install -y fzf fd-find bat ripgrep tree"
    echo
    echo "Ubuntu:"
    echo "  sudo apt-get update && sudo apt-get install -y fzf fd-find bat ripgrep tree"
else
    echo "All tools found."
fi

echo
echo "Creating compatibility symlinks..."

mkdir -p "$HOME/.local/bin"

if ! has fd && has fdfind; then
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    echo "Created: ~/.local/bin/fd"
fi

if ! has bat && has batcat; then
    ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
    echo "Created: ~/.local/bin/bat"
fi

echo
echo "Done. Open a new shell or run:"
echo "  source ~/.bashrc"
