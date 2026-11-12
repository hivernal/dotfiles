#!/bin/sh

get_cpu_freq() {
  grep MHz /proc/cpuinfo
}

get_cpu_temp() {
  printf "it8613-isa-0a30\n%s\n\n%s" "$(sensors it8613-* | grep -E "(pwm|fan)")" "$(sensors amdgpu-* spd5118-* nvme-* k10temp-*)"
}

DEVICE="/sys/class/powercap/intel-rapl/intel-rapl:0"
ENERGY_FILE="${DEVICE}/energy_uj"
INTERVAL="${1:-1}"

get_energy() {
  cat "${ENERGY_FILE}"
}

get_time() {
  # echo ${EPOCHREALTIME}
  date +%s%3N
}

clear
while true; do
  prev_energy=$(get_energy)
  prev_time=$(get_time)
  sleep ${INTERVAL}
  echo -e "\e[100A"
  cur_energy=$(get_energy)
  cur_time=$(get_time)
  tdp=$(echo "(${cur_energy} - ${prev_energy}) / (1000 * (${cur_time} - ${prev_time}))" | bc)
  # printf "%s\n\n%s\n" "$(get_cpu_freq)" "$(get_cpu_temp)"
  printf "%s\n\n%s" "$(get_cpu_temp)"
  if [ ${tdp} -gt 0 ]; then
    printf "TDP: %3d W\n" ${tdp}
  fi
done
