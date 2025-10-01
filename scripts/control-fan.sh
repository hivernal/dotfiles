#!/usr/bin/bash

set_pwm() {
  local new_pwm=$1
  echo "${new_pwm}" > "${PWM_FILE}"
}

get_temp() {
  cat "${TEMP_FILE}"
}

interpolate_pwm() {
  local current_temp=$1
  local previous_temp=$2
  local -n temps=$3
  local -n pwms=$4
  local skeep_iter=$5
  if [[ ${previous_temp} -ge ${current_temp} ]] && [[ ${skeep_iter} -gt 0 ]]; then
    echo -1
    return
  fi

  if [[ ${current_temp} -le ${temps[0]} ]]; then
    echo ${pwms[0]}
    return
  elif [[ ${current_temp} -gt ${temps[-1]} ]]; then
    echo ${pwms[-1]}
    return
  fi

  i=0
  for i in "${!temps[@]}"; do
    if [[ ${current_temp} -gt ${temps[$i]} ]]; then
      continue
    fi
    local lower_temp=${temps[i-1]}
    local higher_temp=${temps[i]}
    local lower_pwm=${pwms[i-1]}
    local higher_pwm=${pwms[i]}
    local pwm=$(echo "((${current_temp} - ${lower_temp}) * (${higher_pwm} - ${lower_pwm}) / (${higher_temp} - ${lower_temp})) + ${lower_pwm}" | bc)
    echo ${pwm}
    return
  done
}

TEMPS=($(echo "${TEMPS}" | tr ',' ' '))
PWMS=($(echo "${PWMS}" | tr ',' ' '))

previous_temp=0
skeep_iter=${SKEEP_ITER}
while true; do
  current_temp=$(get_temp)
  pwm=$(interpolate_pwm ${current_temp} ${previous_temp} TEMPS PWMS ${skeep_iter})
  skeep_iter=$((--skeep_iter))
  if [[ ${pwm} -ge 0 ]]; then
    set_pwm ${pwm}
    previous_temp=${current_temp}
    skeep_iter=${SKEEP_ITER}
  fi
  sleep ${INTERVAL}
done
