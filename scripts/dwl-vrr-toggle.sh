#!/bin/sh

[ "${XDG_CURRENT_DESKTOP}" != "wlroots" ] && exit 1

vrr_status="$(wlr-randr --output "${MONITOR}" | awk -F": " '/Adaptive Sync/ {printf $2}')"
if [ "${vrr_status}" = "enabled" ]; then
  wlr-randr --output "${MONITOR}" --adaptive-sync disabled
else
  wlr-randr --output "${MONITOR}" --adaptive-sync enabled
fi
