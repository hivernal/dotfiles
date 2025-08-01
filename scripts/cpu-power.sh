#!/usr/bin/bash
DEVICE="/sys/class/powercap/intel-rapl/intel-rapl:0"
ENERGY_FILE="${DEVICE}/energy_uj"
INTERVAL="${1:-1}"
CACHE="/tmp/cpu_powercap"

get_current_energy() {
  cat "${ENERGY_FILE}"
}

previous=$(get_current_energy)
while true; do
  sleep "${INTERVAL}"
  current=$(get_current_energy)
  result=$(( (${current} - ${previous}) / (1000000 * ${INTERVAL}) ))
  echo ${result} > "${CACHE}"
  echo ${result}
  previous=${current}
done
