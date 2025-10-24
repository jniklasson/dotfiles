# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Enable programmable completion features
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi
unset rc

# Source custom scripts
if [ -f "$HOME/.bash_aliases" ]; then
    . "$HOME/.bash_aliases"
fi

if [ -f "$HOME/.bash_functions" ]; then
    . "$HOME/.bash_functions"
fi

# Source environment variables
if [ -f ~/.env ]; then
    source ~/.env
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

export EDITOR='vi'

export GREP_OPTIONS='--color=auto'

set -o vi

bind 'set show-mode-in-prompt on'
bind 'set vi-ins-mode-string "\1\e[38;5;245m\2[\1\e[92m\2I\1\e[38;5;245m\2]\1\e[0m\2 "'
bind 'set vi-cmd-mode-string "\1\e[38;5;245m\2[\1\e[95m\2N\1\e[38;5;245m\2]\1\e[0m\2 "'

# Prompt
PROMPT_COMMAND='PS1_CMD1=$(git branch --show-current 2>/dev/null)' 
PS1='\[\e[92m\]\u\[\e[0m\]@\h:[\[\e[38;5;51m\]\W\[\e[0m\]] \[\e[95m\]${PS1_CMD1}\[\e[0m\] \\$ '

# History settings
HISTSIZE=10000
HISTFILESIZE=20000

# Ignore duplicate commands
export HISTCONTROL=ignoredups:ignorespace

# Append to the history file instead of overwriting it
shopt -s histappend

# Enable case-insensitive completion
shopt -s nocaseglob

# Alias
alias ls='ls --color=auto'
alias ll='ls -laAhF --color=auto'
alias ..='cd ..'  
alias ...='cd ../..'  
alias ~='cd ~'  

# Source fzf keybinds
if [ -f ~/.fzf.bash ]; then
    source ~/.fzf.bash
fi

# Alacritty completion
if [ -f ~/.bash_completion/alacritty ]; then
    source ~/.bash_completion/alacritty
fi
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)  tar xvjf "$1" ;;
            *.tar.gz)   tar xvzf "$1" ;;
            *.bz2)      bunzip2 "$1" ;;
            *.rar)      unrar x "$1" ;;
            *.gz)       gunzip "$1" ;;
            *.tar)      tar xvf "$1" ;;
            *.zip)      unzip "$1" ;;
            *.7z)       7z x "$1" ;;
            *)          echo "Unsupported file type: $1" ;;
        esac
    else
        echo "'$1' is not a valid file."
    fi
}

if [[ $- == *i* ]]; then
    echo "Welcome back, $(whoami)! Today is $(date +'%A, %B %d, %Y')."
fi
