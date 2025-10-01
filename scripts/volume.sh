#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ICONS_DIR="/usr/share/icons/Qogir/32/status"

if [[ "$1" == "up" ]] then
  wpctl set-volume @DEFAULT_SINK@ 5%+
elif [[ "$1" == "down" ]]; then
  wpctl set-volume @DEFAULT_SINK@ 5%-
elif [[ "$1"  == "mute" ]]; then
  wpctl set-mute @DEFAULT_SINK@ toggle
fi

volume="$(wpctl get-volume @DEFAULT_SINK@)"
muted="$(echo "${volume}" | grep MUTED)"
volume="${volume##*.}"; volume=${volume% *}; volume=${volume#0}
if [[ $# -eq 0 ]]; then
  if [[ ! -z "${muted}" ]]; then
    echo "muted"
  else
    echo "${volume}%"
  fi
  exit 0
fi

if [[ ! -z "${muted}" ]]; then
    icon="audio-volume-muted.svg"
else
  if (( ${volume} == 0 )); then
    icon="audio-volume-muted.svg"
  elif (( ${volume} <= 20 )); then
    icon="audio-volume-low.svg"
  elif (( ${volume} <= 50 )); then
    icon="audio-volume-medium.svg"
  else
    icon="audio-volume-high.svg"
  fi
fi

dunstify -t 2000 -i "${ICONS_DIR}/${icon}" -h string:x-canonical-private-synchronous:audio "${volume}%" -h int:value:${volume}
