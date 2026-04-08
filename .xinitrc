#!/bin/sh

export XDG_CURRENT_DESKTOP=dwm
feh --bg-scale /usr/share/pixmaps/dolomite-mountains-3840x2160-16232.png
dbus-update-activation-environment DISPLAY XDG_CURRENT_DESKTOP=dwm
xrdb -merge "${HOME}/.Xresources"
"${HOME}/.dwm/dwmrc" &
exec dwm
