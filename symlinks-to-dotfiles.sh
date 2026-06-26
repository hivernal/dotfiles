#!/bin/sh

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
FILES=".config/MangoHud:.config/alacritty:.config/dunst:.config/hypr:.config/mpv:.config/mvi:.config/niri:.config/nvim:.config/pipewire:.config/rc:.config/sway:.config/user-dirs.dirs:.bashrc:.bash_profile:.wprofile:.xprofile:.profile:.xinitrc:.Xresources"

unset saved_IFS
[ -n "${IFS+set}" ] && { saved_IFS="${IFS}"; IFS=":"; }

for file in ${FILES}; do
  echo "${DOTFILES_DIR}/${file} -> ${HOME}/${file}"
  ln -sT "${DOTFILES_DIR}/${file}" "${HOME}/${file}"
done

unset IFS
[ -n "${saved_IFS+set}" ] && { IFS="${saved_IFS}"; unset saved_IFS; }
