# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$HOME/.fzf/shell/key-bindings.bash"

export FZF_DEFAULT_OPTS="--no-mouse --height=40% --reverse --multi --inline-info
  --preview='[[ \$(file --mime {}) =~ binary ]] && echo ''No preview'' ||
    (bat {} --color=always || cat {}) 2>/dev/null | head -100'
  --preview-window='hidden:right:70%'
  --bind=ctrl-l:toggle-preview
  --bind=ctrl-d:half-page-down,ctrl-u:half-page-up
  --bind=ctrl-e:preview-down,ctrl-y:preview-up"

FD_DEFAULT_OPTIONS="--type f --hidden --exclude .git"
export FZF_DEFAULT_COMMAND="(fd $FD_DEFAULT_OPTIONS ||
                             fdfind $FD_DEFAULT_OPTIONS ||
                             find) 2> /dev/null"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d || find -type d"
