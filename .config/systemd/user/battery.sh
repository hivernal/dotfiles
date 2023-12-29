#!/bin/bash

bat0_cap=$(< /sys/class/power_supply/BAT0/capacity)
bat0_status=$(< /sys/class/power_supply/BAT0/status)
BAT0_LOW=20

if (( $bat0_cap <= $BAT0_LOW )) && [[ $bat0_status != "Charging" ]]; then
  dunstify -t 20000 -i /usr/share/icons/Qogir-dark/16/panel/battery-020.svg "$bat0_cap% Battery is low!"
fi
