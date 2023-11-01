#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias mvi='mpv --player-operation-mode=pseudo-gui --config-dir=$HOME/.config/mvi'

GREEN="\[$(tput setaf 2)\]"
BLUE="\[$(tput setaf 4)\]"
RESET="\[$(tput sgr0)\]"
PS1="\n$BLUE\w $GREEN> $RESET"

export VISUAL=/usr/bin/nvim
export EDITOR=/usr/bin/nvim
export NNN_BMS="p:~/documents/projects;d:~/downloads;c:~/.config;q:~/documents/qemu;o:~/documents/office;h:~;/:/;l:~/.local"
export NNN_PLUG='o:fzopen;x:!chmod +x $nnn;c:fzcd;s:suedit'
export NNN_OPTS=AaioeEHU
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

set -o vi
. ~/.config/nnn/misc/quitcd/quitcd.bash_sh_zsh
. "$HOME/.cargo/env"

export FZF_DEFAULT_OPTS='--height 40%'
function fcd ()
{
  BASE=${1:-.}
  FILE=$(fd -E snapshots -Ha -t d . $BASE | fzf)
  if [[ $FILE != "" ]]; then
    cd $FILE
  fi
}

function fcdedit ()
{
  BASE=${1:-.}
  FILE=$(fd -E snapshots -Ha -t f . $BASE | fzf)
  if [[ $FILE != "" ]]; then
    cd ${FILE%/*}; $EDITOR $FILE
  fi
}

function fedit ()
{
  BASE=${1:-.}
  FILE=$(fd -E snapshots -Ha -t f . $BASE | fzf)
  if [[ $FILE != "" ]]; then
    $EDITOR $FILE
  fi
}
