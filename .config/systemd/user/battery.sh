#!/bin/bash

BAT0_CAP=$(< /sys/class/power_supply/BAT0/capacity)
BAT0_STATUS=$(< /sys/class/power_supply/BAT0/status)
BAT0_LOW=20

if (( $BAT0_CAP <= $BAT0_LOW )) && [[ $BAT0_STATUS != "Charging" ]]; then
  dunstify -t 20000 -i /usr/share/icons/Qogir-dark/16/panel/battery-020.svg "Battery is low!"
fi
