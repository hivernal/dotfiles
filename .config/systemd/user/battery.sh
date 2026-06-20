#!/bin/bash

BAT="BAT0"
bat_cap=$(< /sys/class/power_supply/${BAT}/capacity)
bat_status=$(< /sys/class/power_supply/${BAT}/status)
BAT_LOW=20

if (( ${bat_cap} <= ${BAT_LOW} )) && [[ $bat_status != "Charging" ]]; then
  dunstify -t 20000 -i /usr/share/icons/Qogir-dark/16/panel/battery-020.svg "$bat_cap% Battery is low!"
fi
