#!/bin/sh

export XDG_CURRENT_DESKTOP=dwm
xrdb -merge "${HOME}/.Xresources"
"${HOME}/.dwm/dwmrc"
# exec dbus-launch --sh-syntax --exit-with-session dwm
exec dwm
