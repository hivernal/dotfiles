#!/bin/sh

if [ $# -eq 0 ]; then
  session="$(cat "${HOME}/.wm" > /dev/null 2>&1 )"
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
