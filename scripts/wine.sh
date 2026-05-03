#!/bin/sh

WINE=${WINE:-"/usr/local/bin/wine"}
export WINEPREFIX="/opt/nv3000/wine/${USER}"
"${WINE}" "${@}"
