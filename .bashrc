#
# ~/.bashrc
#

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

bash_completion() {
  complete -F _root_command doas
  source <(kubectl completion bash)
}

gpg_ssh_setup() {
  unset SSH_AGENT_PID
  if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
      export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  fi
  export GPG_TTY=$(tty)
  gpg-connect-agent updatestartuptty /bye > /dev/null
}

set_aliases() {
  alias ls="ls --color=auto"
  alias grep="grep --color=auto"
  alias mvi="mpv --player-operation-mode=pseudo-gui \
    --config-dir=${HOME}/.config/mvi"
  alias xclip="xclip -selection clipboard"
  alias bathelp="bat -p -l help"
  # alias cpuwatch="watch -n 1 'grep MHz /proc/cpuinfo'"
  alias cpuwatch="watch -n 1 'doas cpupower -c 0,1 frequency-info -mf'"
  alias picom="picom --config /dev/null --backend xrender --vsync --no-frame-pacing --no-fading-openclose --no-fading-destroyed-argb --use-ewmh-active-win"
  alias tnvim="nvim -c 'set nonumber | set norelativenumber | set signcolumn=no | set cmdheight=0 | set laststatus=0 | term' -c startinsert"
}

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

GREEN="\[$(tput setaf 2)\]"
BLUE="\[$(tput setaf 4)\]"
RESET="\[$(tput sgr0)\]"
PS1="\n$BLUE\w $GREEN> $RESET"

set_aliases
set -o vi
bash_completion
gpg_ssh_setup
