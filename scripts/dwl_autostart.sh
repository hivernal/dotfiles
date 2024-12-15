#!/bin/bash

dbus-update-activation-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
/usr/libexec/polkit-gnome-authentication-agent-1 &
gentoo-pipewire-launcher &
yambar -c "${HOME}/.config/dwl/yambar/config-1.11.yml" &
swaybg -m fill -i "${HOME}/pictures/neboskreb.jpg" &
