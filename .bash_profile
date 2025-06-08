#
# ~/.bash_profile
#

[[ -f "${HOME}/.bashrc" ]] && . "${HOME}/.bashrc" 
[[ -f "${HOME}/.profile" ]] && . "${HOME}/.profile"
[[ -f "${HOME}/.config/nnn/misc/quitcd/quitcd.bash_sh_zsh" ]] && . "${HOME}/.config/nnn/misc/quitcd/quitcd.bash_sh_zsh"

# if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
#   exec startx
# fi
#
