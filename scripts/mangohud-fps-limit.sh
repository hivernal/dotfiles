#!/bin/sh

get_desktop_resolution() {
  case "${XDG_CURRENT_DESKTOP}" in
    "niri") niri msg -j focused-output 2> /dev/null | jq -r '.modes[.current_mode] | "\(.width)x\(.height)"' 2> /dev/null ;;
  esac
}

get_fps_limit() {
  local resolution="$1"
  if [ -z "${resolution}" ]; then
    return
  fi
  shift 1
  for fps_limit in "$@"; do
    if [ "${resolution}" = "${fps_limit%%:*}" ]; then
      echo "${fps_limit#*:}"
      break
    fi
  done
}

main() {
  local default_fps_limit=135
  export DESKTOP_RESOLUTION="$(get_desktop_resolution)"
  local fps_limit=$(get_fps_limit "${DESKTOP_RESOLUTION}" "$@")
  export MANGOHUD_CONFIG="read_cfg,fps_limit=${fps_limit:-${default_fps_limit}}"
}

main "$@"
