#!/bin/bash

[[ -f "${HOME}/.wprofile" ]] && . "${HOME}/.wprofile"

dbus_launch_wrapper() {
  exec dbus-launch --sh-syntax --exit-with-session "${@}"
}

session="$(cat "${HOME}/.wm")"
dbus_wrapper="dbus_launch_wrapper"

for arg in "${@}"; do
  case "${arg}" in
    -d) dbus_wrapper="dbus-run-session";;
    *) session="${arg}" ;;
  esac
done

case "${session}" in
    dwl) echo "dwl" > "${HOME}/.wm" && "${dbus_wrapper}" dwl.sh;;
    sway) echo "sway" > "${HOME}/.wm" && "${dbus_wrapper}" sway;;
    # qtile) echo "qtile" > "${HOME}/.wm" && qtile start -b wayland;;
    *) exec $1;;
esac
