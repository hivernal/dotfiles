#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ICONS_DIR="/usr/local/share/icons/Qogir/32/status"

if [ "$1" = "up" ]; then
  mixer_info="$(mixer -o vol.volume=+5%)"
elif [ "$1" = "down" ]; then
  mixer_info="$(mixer -o vol.volume=-5%)"
elif [ "$1"  = "mute" ]; then
  mixer_info="$(mixer -o vol.mute=^)"
else
  mixer_info="$(mixer -o)"
fi

volume="$(echo "${mixer_info}" | awk -F= '/vol\.volume=/ {print $2}' | cut -d':' -f1)"
muted="$(echo "${mixer_info}" | awk -F= '/vol\.mute=/ {print $2}')"
volume="$(echo "${volume} * 100" | bc)"
volume=${volume%.00}
if [ $# -eq 0 ]; then
  if [ "${muted}" = "on" ]; then
    echo "muted"
  else
    echo "${volume}%"
  fi
  exit 0
fi

if [ "${muted}" = "on" ]; then
    icon="audio-volume-muted.svg"
else
  if [ ${volume} -le 20 ]; then
    icon="audio-volume-low.svg"
  elif [ ${volume} -le 50 ]; then
    icon="audio-volume-medium.svg"
  else
    icon="audio-volume-high.svg"
  fi
fi

dunstify -t 2000 -i "${ICONS_DIR}/${icon}" -h string:x-canonical-private-synchronous:audio "${volume}%" -h int:value:${volume}
