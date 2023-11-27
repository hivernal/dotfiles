#!/bin/bash

BAT_CAP=$(< /sys/class/power_supply/BAT0/capacity)
BAT_LOW=20

if [[ $BAT_CAP -le $BAT_LOW ]]; then
  dunstify -i /usr/share/icons/Qogir-dark/16/panel/battery-020.svg "Battery is low"
fi
