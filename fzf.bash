# Setup fzf
# ---------
if [[ ! "$PATH" == *${HOME}/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}${HOME}/.fzf/bin"
fi

HISTORY_SIZE=50000

export FZF_DEFAULT_OPTS="
    --no-mouse --height=40% --reverse --multi --inline-info
    --history=${HOME}/.fzf_history --history-size=${HISTORY_SIZE}
    --preview-window=right,80%,hidden
    --bind=ctrl-/:toggle-preview
    --bind=ctrl-d:half-page-down
    --bind=ctrl-u:half-page-up
    --bind=ctrl-f:preview-half-page-down
    --bind=ctrl-b:preview-half-page-up
"

FD_OPTS="--follow --hidden --exclude .git"

export FZF_DEFAULT_COMMAND="fdfind --type=f ${FD_OPTS}"

export FZF_ALT_C_COMMAND="fdfind --type=d ${FD_OPTS}"

export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"

export FZF_CTRL_T_OPTS="
    --prompt='fd> ' \
    --bind='ctrl-t:transform:[[ ! $FZF_PROMPT =~ git ]] && echo \"change-prompt(git> )+reload(git ls-files)\" || echo \"change-prompt(fd> )+reload($FZF_DEFAULT_COMMAND)\"' \
    --preview='bat -n --color=always {}' \
"

export FZF_ALT_C_OPTS="--preview='tree -C {}'"

export FZF_CTRL_R_OPTS="
  --preview='echo {}' --preview-window=down:3:hidden:wrap
  --bind='ctrl-y:execute-silent(echo -n {2..} | xclip -sel clip)+abort'
"

eval "$(fzf --bash)"
