#!/usr/bin/bash

WINE=${WINE:-"/usr/local/bin/wine-11.0-wow64"}
export WINEPREFIX="/opt/nv3000/wine/${USER}"
GAMES="${WINEPREFIX}/dosdevices/c:/Games"
GAME_DIR="${GAMES}/GAME_DIR"
ARGS=(GAME.exe "${@}")

ps -C Xwayland > /dev/null 2>&1 && unset DISPLAY
cd "${GAME_DIR}" && "${WINE}" "${ARGS[@]}"
