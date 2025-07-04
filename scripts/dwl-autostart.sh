#!/bin/bash

dbus-update-activation-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
/usr/libexec/polkit-gnome-authentication-agent-1 &
wlr-randr --output DP-1 --adaptive-sync=enabled > /dev/null 2>&1
wlr-randr --output DP-2 --adaptive-sync=enabled > /dev/null 2>&1
wlr-randr --output DP-3 --adaptive-sync=enabled > /dev/null 2>&1
swaybg -m fill -i "/usr/share/pixmaps/summit.png" &
ps -C wireplumber > /dev/null 2>&1 || gentoo-pipewire-launcher restart &
