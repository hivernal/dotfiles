#!/usr/bin/bash

GAMES="/opt/games"
PREFIXES="${GAMES}/prefixes"
WINE="${WINE:-wine}"
export WINEPREFIX="${WINEPREFIX:-${PREFIXES}/${USER}}"
ARGS=("${@}")
export LANG="ru_RU.UTF-8"
# ps -C Xwayland > /dev/null 2>&1 && unset DISPLAY
${WINE} "${ARGS[@]}"
