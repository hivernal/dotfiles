#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ICON="${SCRIPT_DIR}/icons/icons8-sun.svg"

if [ "$1" = "up" ]; then
  backlight incr 5
elif [ "$1" = "down" ]; then
  backlight decr 5
fi
brightness=$(backlight | cut -d' ' -f 2)
dunstify -t 2000 -i "${ICON}" -h string:x-canonical-private-synchronous:bbashrightness "${brightness}%" -h int:value:${brightness}
