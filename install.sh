#!/bin/bash

# Define the source directory (where your dotfiles are located)
DOTFILES_DIR="$(pwd)"

# List of dotfiles to symlink
declare -a dotfiles=(
    ".bashrc"
    ".gitconfig"
    ".tmux.conf"
    ".vimrc"
)

# Create symbolic links for dotfiles
for file in "${dotfiles[@]}"; do
    if [ -f "$HOME/$file" ]; then
        echo "$HOME/$file already exists. Backing up..."
        mv "$HOME/$file" "$HOME/$file.bak"
    fi
    ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
    echo "Linked $file to $HOME/$file"
done

# Check and link Alacritty configuration if installed
if command -v alacritty &> /dev/null; then
    alacritty_config=".alacritty.toml"
    if [ -f "$HOME/$alacritty_config" ]; then
        echo "$HOME/$alacritty_config already exists. Backing up..."
        mv "$HOME/$alacritty_config" "$HOME/$alacritty_config.bak"
    fi
    ln -sf "$DOTFILES_DIR/$alacritty_config" "$HOME/$alacritty_config"
    echo "Linked $alacritty_config to $HOME/$alacritty_config"
else
    echo "Alacritty is not installed. Skipping .alacritty.toml link."
fi

# Check and link Conky configuration if installed
if command -v conky &> /dev/null; then
    conky_config=".conkyrc"
    if [ -f "$HOME/$conky_config" ]; then
        echo "$HOME/$conky_config already exists. Backing up..."
        mv "$HOME/$conky_config" "$HOME/$conky_config.bak"
    fi
    ln -sf "$DOTFILES_DIR/$conky_config" "$HOME/$conky_config"
    echo "Linked $conky_config to $HOME/$conky_config"
else
    echo "Conky is not installed. Skipping .conkyrc link."
fi

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
