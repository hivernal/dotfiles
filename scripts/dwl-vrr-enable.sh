#!/bin/sh

[ "${XDG_CURRENT_DESKTOP}" = "wlroots" ] && wlr-randr --output "${MONITOR}" --adaptive-sync enabled
