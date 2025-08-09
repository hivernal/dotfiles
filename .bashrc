#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

setup_gpg_agent_for_ssh () {
  export GPG_TTY="$(tty)"
  unset SSH_AGENT_PID
  if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  fi
  # alias ssh="gpg-connect-agent updatestartuptty /bye >/dev/null && ssh"
  # gpgconf --launch gpg-agent
  gpg-connect-agent updatestartuptty /bye > /dev/null 2>&1
}

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

# man() {
#   nvim "+hide Man $1"
# }

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
alias cpuwatch="watch -n 1 'grep MHz /proc/cpuinfo'"
alias amdwatch="watch -n 1 sensors amdgpu-pci-0500"
alias torwatch="watch -n 1 transmission-remote -l"
# alias picom="picom --config /dev/null --backend xrender --vsync --no-frame-pacing --no-fading-openclose --no-fading-destroyed-argb --use-ewmh-active-win"
# alias tnvim="nvim -c 'set nonumber | set norelativenumber | set signcolumn=no | set cmdheight=0 | set laststatus=0 | term' -c startinsert"

complete -F _root_command doas

setup_gpg_agent_for_ssh
