# Source global definitions
[ -f /etc/bashrc ] && . /etc/bashrc
[ -f /etc/bash.bashrc ] && . /etc/bash.bashrc

# Stop here for non-interactive shells
case $- in
    *i*) ;;
    *) return ;;
esac

# Bash completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Path
case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) PATH="$HOME/.local/bin:$PATH" ;;
esac

case ":$PATH:" in
    *":$HOME/bin:"*) ;;
    *) PATH="$HOME/bin:$PATH" ;;
esac

export PATH

# Source user files
[ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"
[ -f "$HOME/.bash_functions" ] && . "$HOME/.bash_functions"
[ -f "$HOME/.env" ] && . "$HOME/.env"

if [ -d "$HOME/.bashrc.d" ]; then
    for rc in "$HOME"/.bashrc.d/*; do
        [ -f "$rc" ] && . "$rc"
    done
    unset rc
fi

# Environment
export EDITOR='vi'

# Readline / vi mode
set -o vi
bind 'set show-mode-in-prompt on'
bind 'set completion-ignore-case on'
bind 'set vi-ins-mode-string "\1\e[38;5;245m\2[\1\e[92m\2I\1\e[38;5;245m\2]\1\e[0m\2 "'
bind 'set vi-cmd-mode-string "\1\e[38;5;245m\2[\1\e[95m\2N\1\e[38;5;245m\2]\1\e[0m\2 "'

# Prompt
PROMPT_COMMAND='PS1_CMD1=$(git branch --show-current 2>/dev/null)'
PS1='\[\e[92m\]\u\[\e[0m\]@\h:[\[\e[38;5;51m\]\W\[\e[0m\]] \[\e[95m\]${PS1_CMD1}\[\e[0m\] \$ '

# History
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:ignorespace
shopt -s histappend

# Globbing
shopt -s nocaseglob

# Aliases
alias ls='ls --color=auto'
alias ll='ls -laAhF --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'

# fzf
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'

export FZF_DEFAULT_OPTS="
  --height=80%
  --layout=reverse
  --border
  --info=inline
  --prompt='❯ '
  --pointer='➜'
  --marker='✓'
  --preview-window=right:60%:wrap
  --bind='ctrl-/:toggle-preview'
"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="
  --preview 'bat --style=numbers --color=always --line-range :500 {}'
"

export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="
  --preview 'tree -C {} | head -200'
"

export FZF_CTRL_R_OPTS="
  --preview 'echo {}'
  --preview-window=down:3:hidden:wrap
  --bind='ctrl-/:toggle-preview'
"

if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --bash)"
fi

# Alacritty completion
[ -f ~/.bash_completion/alacritty ] && source ~/.bash_completion/alacritty

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

echo "Welcome back, $(whoami)! Today is $(date +'%A, %B %d, %Y')."
