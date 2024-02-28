#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

GREEN="\[$(tput setaf 2)\]"
BLUE="\[$(tput setaf 4)\]"
RESET="\[$(tput sgr0)\]"
PS1="\n$BLUE\w $GREEN> $RESET"

set -o vi

alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias mvi="mpv --player-operation-mode=pseudo-gui \
  --config-dir=${HOME}/.config/mvi"
alias xclip="xclip -selection clipboard"
alias bathelp="bat -p -l help"

help() {
  "$@" --help 2>&1 | bathelp
}

fcd() {
  local dir="$(fd -E snapshots -Ha -t d . "${1:-.}" | fzf -q  "${2:-}" \
    --preview "tree -L 1 -Ch {}")"
  cd "${dir:-.}"

}

fcdedit() {
  local file="$(fd -E snapshots -Ha -t f . "${1:-.}" | fzf -q  "${2:-}" \
    --height 70% --preview "bat {} --color=always")" 
  if [[ ${file} != "" ]]; then
    cd ${file%/*} && ${EDITOR} ${file}
  fi
}

fedit() {
  fd -E snapshots -Ha -t f . "${1:-.}" | fzf -q  "${2:-}" -m --height 70% \
    --preview "bat {} --color=always" --bind "enter:become(${EDITOR} {+})"
}
