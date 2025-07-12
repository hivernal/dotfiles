#!/bin/bash

while true; do
  kb_layout="$(swaymsg -t get_inputs | jq '.[1].xkb_active_layout_name')"
  case "${kb_layout}" in
    '"English (US)"') kb_layout="en";;
    '"Russian"') kb_layout="ru";;
    *) kb_layout="n/a";;
  esac
  volume="$(volume.sh)"
  date="$(date +%H:%M:%S)"
  ram_usage="$(free -h | awk '(NR==2) {printf $3}')"
  echo " KEY ${kb_layout} | VOL ${volume} | MEM ${ram_usage} | ${date}"
  sleep 1
done
