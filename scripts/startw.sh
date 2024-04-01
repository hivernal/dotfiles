#!/bin/bash

[[ -f "${HOME}/.wprofile" ]] && . "${HOME}/.wprofile"

wm="$(< "${HOME}/.wm")"
session="${1:-"${wm}"}"
session="${session:-qtile}"
case "${session}" in
    dwl) echo "dwl" > "${HOME}/.wm" && exec dwl > "${HOME}/.cache/dwlinfo";;
    sway) echo "sway" > "${HOME}/.wm" && exec sway;;
    qtile) echo "qtile" > "${HOME}/.wm" && qtile start -b wayland;;
    *) exec $1;;
esac
