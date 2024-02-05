#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias mvi="mpv --player-operation-mode=pseudo-gui --config-dir=${HOME}/.config/mvi"

GREEN="\[$(tput setaf 2)\]"
BLUE="\[$(tput setaf 4)\]"
RESET="\[$(tput sgr0)\]"
PS1="\n$BLUE\w $GREEN> $RESET"

export VISUAL="/usr/bin/nvim"
export EDITOR="/usr/bin/nvim"
export NNN_BMS="p:~/documents/projects;d:~/downloads;c:~/.config;q:~/documents/qemu;o:~/documents/office;h:~;/:/;l:~/.local"
export NNN_PLUG="o:fzopen;x:!chmod +x ${nnn};c:fzcd;s:suedit"
export NNN_OPTS="AaioeEU"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"
export LANG="en_US.UTF-8"

set -o vi
# . ~/.config/nnn/misc/quitcd/quitcd.bash_sh_zsh

export FZF_DEFAULT_OPTS="--height 40%"
function fcd()
{
  root=${1:-.}
  dir="$(fd -E snapshots -Ha -t d . ${root} | fzf)"
  if [[ ${dir} != "" ]]; then
    cd ${dir}
  fi
}

function fcdedit()
{
  root=${1:-.}
  file="$(fd -E snapshots -Ha -t f . ${root} | fzf)"
  if [[ ${file} != "" ]]; then
    cd ${file%/*} && ${EDITOR} ${file}
  fi
}

function fedit()
{
  root=${1:-.}
  file="$(fd -E snapshots -Ha -t f . ${root} | fzf)"
  if [[ ${file} != "" ]]; then
    ${EDITOR} ${file}
  fi
}
