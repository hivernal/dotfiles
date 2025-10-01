#!/usr/bin/bash

GAMES="/opt/games"
PREFIXES="${GAMES}/prefixes"
WINE="${WINE:-wine}"
export WINEPREFIX="${WINEPREFIX:-${PREFIXES}/${USER}}"
GAME_DIR="${WINEPREFIX}/dosdevices/c:/Games/DOOM Eternal"
ARGS=("DOOMEternalx64vk.exe" "${@}")
ps -C Xwayland > /dev/null 2>&1 && unset DISPLAY
cd "${GAME_DIR}" &&
${WINE} "${ARGS[@]}"
