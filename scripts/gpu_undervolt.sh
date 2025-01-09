#!/bin/bash

DEVICE="/sys/devices/pci0000:00/0000:00:03.0/0000:03:00.0"
# echo "s 0 300 230" > /sys/devices/pci0000:00/0000:00:02.0/0000:03:00.0/pp_od_clk_voltage
# echo "s 1 600 459" > /sys/devices/pci0000:00/0000:00:02.0/0000:03:00.0/pp_od_clk_voltage
# echo "s 2 900 689" > /sys/devices/pci0000:00/0000:00:02.0/0000:03:00.0/pp_od_clk_voltage
echo "s 3 1145 876" > "${DEVICE}/pp_od_clk_voltage" &&
echo "s 4 1215 930" > "${DEVICE}/pp_od_clk_voltage" &&
echo "s 5 1257 962" > "${DEVICE}/pp_od_clk_voltage" &&
echo "s 6 1300 995" > "${DEVICE}/pp_od_clk_voltage" &&
# echo "s 7 1300 995" > "${DEVICE}/pp_od_clk_voltage" &&
echo "s 7 1340 1025" > "${DEVICE}/pp_od_clk_voltage" &&
echo "c" > "${DEVICE}/pp_od_clk_voltage"
