#!/usr/bin/bash

GAMES="/opt/games"
PREFIXES="${GAMES}/prefixes"
WINE="${WINE:-wine}"
export WINEPREFIX="${WINEPREFIX:-${PREFIXES}/${USER}}"
GAME_DIR="${WINEPREFIX}/dosdevices/c:/Games/Devil May Cry HD Collection"
ARGS=("dmc3.exe" "${@}")
ps -C Xwayland -C sway -C dwl > /dev/null 2>&1 && unset DISPLAY
cd "${GAME_DIR}" &&
${WINE} "${ARGS[@]}"
