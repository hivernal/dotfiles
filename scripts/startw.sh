#!/bin/bash

[[ -f "${HOME}/.wprofile" ]] && . "${HOME}/.wprofile"

wm="$(< "${HOME}/.wm")"
session="${1:-"${wm}"}"
session="${session:-dwl}"
doas xbacklight -set 10
case "${session}" in
    dwl) echo "dwl" > "${HOME}/.wm" && exec dbus-launch --sh-syntax --exit-with-session dwl > "${HOME}/.cache/dwlinfo";;
    sway) echo "sway" > "${HOME}/.wm" && exec sway;;
    qtile) echo "qtile" > "${HOME}/.wm" && qtile start -b wayland;;
    *) exec $1;;
esac
