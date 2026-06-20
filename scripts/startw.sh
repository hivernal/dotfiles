#!/bin/sh

if [ $# -eq 0 ]; then
  session="$(cat "${HOME}/.wm" 2> /dev/null)"
else
  session="$@"
fi

if [ -z "${session}" ]; then
  echo "Error: empty session command"
  exit 1
fi

[ -f "${HOME}/.wprofile" ] && . "${HOME}/.wprofile"
echo "${session}" > "${HOME}/.wm"
${session}
