#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

has() {
    command -v "$1" >/dev/null 2>&1
}

link() {
    local src="$DOTFILES_DIR/$1" dst="$2"
    [ -e "$src" ] || { echo "missing $src" >&2; exit 1; }
    [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ] && return
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        mv "$dst" "$dst.bak.$(date +%Y%m%d-%H%M%S)"
        echo "Backed up: $dst"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "Linked: $dst"
}

link .bashrc    ~/.bashrc
link .gitconfig ~/.gitconfig
link .tmux.conf ~/.tmux.conf
link .vimrc     ~/.vimrc

mkdir -p ~/.local/bin ~/.vim/undo ~/.config/environment.d
chmod 700 ~/.vim/undo
printf 'PATH=%s/.local/bin:%s/bin:$PATH\n' "$HOME" "$HOME" > ~/.config/environment.d/paths.conf

if ! has fd && has fdfind; then ln -sf "$(command -v fdfind)" ~/.local/bin/fd; fi
if ! has bat && has batcat; then ln -sf "$(command -v batcat)" ~/.local/bin/bat; fi

packages="fzf:fzf rg:ripgrep fd:fd-find bat:bat tree:tree"

missing=()
for pair in $packages; do
    case "${pair%%:*}" in
        fd) has fd || has fdfind ;;
        bat) has bat || has batcat ;;
        *) has "${pair%%:*}" ;;
    esac || missing+=("${pair#*:}")
done
[ ${#missing[@]} -eq 0 ] || echo "Missing packages: ${missing[*]}"
