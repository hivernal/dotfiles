#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ICON="${SCRIPT_DIR}/icons/icons8-sun.svg"

if [[ "$1" == "up" ]] then
  doas xbacklight -inc 5
elif [[ "$1" == "down" ]]; then
  doas xbacklight -dec 5
fi
brightness=$(doas xbacklight -get)
dunstify -t 2000 -i "${ICON}" -h string:x-canonical-private-synchronous:brightness "${brightness}%" -h int:value:${brightness}
