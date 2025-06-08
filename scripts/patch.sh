#!/usr/bin/bash

DESTDIR="/etc/portage/patches/app-emulation/wine-vanilla-10.0-r1"
PATCHES_DIR="${PATCHES_DIR:-"wine-staging/patches"}"
PATCH_EXT="patch"

get_patch_deps() {
  patch="$1"
  awk '/Depends/ {first = $1; $1=""; print $0}' "${PATCHES_DIR}/${patch}/definition" | sed 's/^ //g'
}

get_patches_deps() {
  local -n patches=$1
  for (( i=0; i < ${#patches[@]}; i++ )); do
    IFS=$'\n' deps=($(get_patch_deps "${patches[$i]}"))
    patches=("${patches[@]}" "${deps[@]}")
  done
}

copy_patches() {
  patches=("${@}")
#   counter=1
  for patch in "${patches[@]}"; do
    cp "${PATCHES_DIR}/${patch}/"*.${PATCH_EXT} "${DESTDIR}"
#     for file in "${PATCHES_DIR}/${patch}/"*.${PATCH_EXT}; do
#       filename="${file##*/}"
#       filename="${filename#*[0-9]-}"
#       cp "${file}" "${DESTDIR}/$(printf %.4d ${counter})-${filename}"
#      ((counter++))
#     done
  done
}

all_patches=("${@}")
get_patches_deps all_patches
copy_patches "${all_patches[@]}"
