#!/bin/sh
DEVICE="/sys/class/powercap/intel-rapl/intel-rapl:0"
ENERGY_FILE="${DEVICE}/energy_uj"
INTERVAL="${1:-1}"
CACHE="/tmp/cpu_powercap"

get_energy() {
  cat "${ENERGY_FILE}"
}

get_time() {
  # echo ${EPOCHREALTIME}
  date +%s%3N
}

while true; do
  prev_energy=$(get_energy)
  prev_time=$(get_time)
  sleep ${INTERVAL}
  cur_energy=$(get_energy)
  cur_time=$(get_time)
  tdp=$(echo "(${cur_energy} - ${prev_energy}) / (1000 * (${cur_time} - ${prev_time}))" | bc)
  echo "${tdp} W" > "${CACHE}"
done
