#!/bin/bash

# Define the source directory (where your dotfiles are located)
DOTFILES_DIR="$(pwd)"

# List of dotfiles to symlink
declare -a dotfiles=(
    ".alacritty.toml"
    ".tmux.conf"
    ".bashrc"
    ".vimrc"
    ".gitconfig"
)

# Create symbolic links
for file in "${dotfiles[@]}"; do
    if [ -f "$HOME/$file" ]; then
        echo "$HOME/$file already exists. Backing up..."
        mv "$HOME/$file" "$HOME/$file.bak"
    fi
    ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
    echo "Linked $file to $HOME/$file"
done

# Install fzf
if ! command -v fzf &> /dev/null; then
    echo "fzf not found. Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
else
    echo "fzf is already installed."
fi

# Install Vim plugins
if command -v vim &> /dev/null; then
    echo "Installing Vim plugins..."
    vim +PlugInstall +qall
fi

echo "Reloading .bashrc..."
source "$HOME/.bashrc"

echo "Dotfiles installation complete!"

