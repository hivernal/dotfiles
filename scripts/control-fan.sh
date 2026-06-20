#!/bin/sh

INTERVAL=1
SKIP_ITER=5

while [ $# -gt 0 ]; do
  case $1 in
    -t|--temps-pwms)
      TEMPS_PWMS="$(echo "$2" | tr ',' ' ')"
      MAX_TEMP_PWM=${TEMPS_PWMS##* }
      MIN_TEMP_PWM=${TEMPS_PWMS%% *}
      shift 2
      ;;
    -f|--temp-file)
      TEMP_FILE="$2"
      shift 2
      ;;
    -F|--pwm-file)
      PWM_FILE="$2"
      shift 2
      ;;
    -s|--skeep-iter)
      SKIP_ITER=$2
      shift 2
      ;;
    -i|--interval)
      INTERVAL=$2
      shift 2
      ;;
    *)
      shift 1
      ;;
  esac
done

set_pwm() {
  local new_pwm=$1
  echo "${new_pwm}" > "${PWM_FILE}"
}

get_temp() {
  cat "${TEMP_FILE}"
}

interpolate_pwm() {
  local cur_temp=$1
  if [ ${cur_temp} -le ${MIN_TEMP_PWM%:*} ]; then
    echo ${MIN_TEMP_PWM#*:}
    return
  elif [ ${cur_temp} -ge ${MAX_TEMP_PWM%:*} ]; then
    echo ${MAX_TEMP_PWM#*:}
    return
  fi

  prev_temp_pwm="0:0"
  for temp_pwm in ${TEMPS_PWMS}; do
    local higher_temp=${temp_pwm%:*}
    local higher_pwm=${temp_pwm#*:}
    if [ ${cur_temp} -eq ${higher_temp} ]; then
      echo ${higher_pwm}
      return
    fi
    if [ ${cur_temp} -gt ${higher_temp} ]; then
      prev_temp_pwm=${temp_pwm}
      continue
    fi
    local lower_temp=${prev_temp_pwm%:*}
    local lower_pwm=${prev_temp_pwm#*:}
    echo "((${cur_temp} - ${lower_temp}) * (${higher_pwm} - ${lower_pwm}) / (${higher_temp} - ${lower_temp})) + ${lower_pwm}" | bc
    return
  done
}

prev_temp=0
skip_iter=${SKIP_ITER}
while true; do
  cur_temp=$(get_temp)
  if [ ${cur_temp} -lt ${prev_temp} ] && [ ${skip_iter} -gt 0 ]; then
    skip_iter=$(( ${skip_iter} - 1 ))
  elif [ ${cur_temp} -ne ${prev_temp} ]; then
    pwm=$(interpolate_pwm ${cur_temp})
    set_pwm ${pwm}
    prev_temp=${cur_temp}
    skip_iter=${SKIP_ITER}
  fi
  sleep ${INTERVAL}
done
