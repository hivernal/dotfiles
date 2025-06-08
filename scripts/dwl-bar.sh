#!/bin/bash

while true; do
  # kb_layout="$(swaymsg -t get_inputs | jq '.[1].xkb_active_layout_name')"
  # [[ "${kb_layout}" == '"English (US)"' ]] && kb_layout="en" || kb_layout="ru"
  volume="$(volume.sh)"
  date="$(date +%H:%M:%S)"
  ram_usage="$(free -h | awk '(NR==2) {printf $3}')"
  echo " VOL ${volume} | MEM ${ram_usage} | ${date}"
  sleep 0.5
done
