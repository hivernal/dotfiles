#!/bin/bash

dbus-update-activation-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
# swaybg -m fill -i "/usr/share/pixmaps/summit.png" &
openrc -U dwl
