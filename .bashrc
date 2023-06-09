#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

GREEN="\[$(tput setaf 2)\]"
BLUE="\[$(tput setaf 4)\]"
RESET="\[$(tput sgr0)\]"
PS1="${BLUE}\w ${GREEN}> ${RESET}"

export VISUAL=/usr/bin/nvim
export EDITOR=/usr/bin/nvim
export NNN_BMS="p:~/documents/projects;d:~/downloads;c:~/.config;q:~/documents/qemu;o:~/documents/office;h:~"
export NNN_PLUG='x:!chmod +x $nnn;t:!&alacritty -e nvim $nnn'
export NNN_OPTS=AaioeE

set -o vi

source /home/nikita/.config/nnn/misc/quitcd/quitcd.bash_zsh
