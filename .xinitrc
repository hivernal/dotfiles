#!/bin/sh

autostart() {
"${HOME}/.dwm/dwmrc"
}

xrdb -merge "${HOME}/.Xresources"
"${HOME}/.dwm/dwmrc" &
exec dbus-launch --sh-syntax --exit-with-session dwm
