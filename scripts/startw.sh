#!/bin/bash

[[ -f "${HOME}/.wprofile" ]] && . "${HOME}/.wprofile"

session="$(cat "${HOME}/.wm")"

for arg in "${@}"; do
  case "${arg}" in
    *) session="${arg}" ;;
  esac
done

echo "${session}" > "${HOME}/.wm"
"${session}"
