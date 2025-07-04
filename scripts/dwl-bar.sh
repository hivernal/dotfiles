#!/bin/bash

while true; do
  kb_layout="$(cat /tmp/dwl-keymap 2> /dev/null)"
  if [[ "${kb_layout}" == "English (US)" ]]; then
    kb_layout="en"
  elif [[ "${kb_layout}" == "Russian" ]]; then
    kb_layout="ru"
  else
    kb_layout="n/a"
  fi
  volume="$(volume.sh)"
  date="$(date +%H:%M:%S)"
  ram_usage="$(free -h | awk '(NR==2) {printf $3}')"
  echo " KEY ${kb_layout} | VOL ${volume} | MEM ${ram_usage} | ${date}"
  sleep 0.5
done
