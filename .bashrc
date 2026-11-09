for f in /etc/bashrc /etc/bash.bashrc; do
    [ -f "$f" ] && { . "$f"; break; }
done
unset f

case $- in
    *i*) ;;
    *) return ;;
esac

[ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"

if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

for dir in "$HOME/.local/bin" "$HOME/bin"; do
    case ":$PATH:" in
        *":$dir:"*) ;;
        *) PATH="$dir:$PATH" ;;
    esac
done
unset dir
export PATH

export EDITOR="$(command -v vim || command -v vi)"

set -o vi
bind 'set show-mode-in-prompt on'
bind 'set completion-ignore-case on'
bind 'set vi-ins-mode-string "\1\e[38;5;245m\2[\1\e[92m\2I\1\e[38;5;245m\2]\1\e[0m\2 "'
bind 'set vi-cmd-mode-string "\1\e[38;5;245m\2[\1\e[95m\2N\1\e[38;5;245m\2]\1\e[0m\2 "'

__dotfiles_prompt() { PS1_CMD1=$(git branch --show-current 2>/dev/null); history -a; }
[[ " ${PROMPT_COMMAND[*]-} " == *" __dotfiles_prompt "* ]] || PROMPT_COMMAND+=(__dotfiles_prompt)
PS1='\[\e[92m\]\u\[\e[0m\]@\h:[\[\e[38;5;51m\]\W\[\e[0m\]] \[\e[95m\]${PS1_CMD1}\[\e[0m\] \$ '

HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:ignorespace
HISTTIMEFORMAT='%F %T '
shopt -s histappend

alias ls='ls --color=auto'
alias ll='ls -laAhF --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'

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
    if fzf_init=$(fzf --bash 2>/dev/null); then
        eval "$fzf_init"
    else
        for f in /usr/share/doc/fzf/examples/key-bindings.bash /usr/share/fzf/shell/key-bindings.bash; do
            [ -f "$f" ] && { . "$f"; break; }
        done
    fi
    unset fzf_init f
fi

[ -f ~/.bash_completion/alacritty ] && source ~/.bash_completion/alacritty

extract() {
    if [ ! -f "$1" ]; then
        echo "'$1' is not a valid file."
        return 1
    fi
    case "$1" in
        *.tar | *.tar.*) tar xf "$1" ;;
        *.bz2)           bunzip2 "$1" ;;
        *.gz)            gunzip "$1" ;;
        *.rar)           unrar x "$1" ;;
        *.zip)           unzip "$1" ;;
        *.7z)            7z x "$1" ;;
        *)               echo "Unsupported file type: $1" ;;
    esac
}

[ -z "${TMUX:-}" ] && echo "Welcome back, $(whoami)! Today is $(date +'%A, %B %d, %Y')."

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
[ -f "$HOME/.env" ] && . "$HOME/.env"
for rc in "$HOME"/.bashrc.d/*.sh; do
    [ -f "$rc" ] && . "$rc"
done
unset rc
