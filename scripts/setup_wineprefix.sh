#!/usr/bin/bash

GAMES="/opt/games"
PREFIXES="${GAMES}/prefixes"
GLOBAL_WINEPREFIX="${GLOBAL_WINEPREFIX:-${PREFIXES}/global}"
WINE="${WINE:-wine}"
SOFTWARE="${PREFIXES}/software"
SYMLINKS_USER_FOLDERS=("Desktop" "Documents" "Downloads" "Music" "Pictures" "Videos")
SYMLINKS_GLOBAL_FOLDERS=("Program Files" "Program Files (x86)" "ProgramData" "windows" "Games")

[[ -z "${WINEPREFIX}" ]] && WINEPREFIX="${HOME}/.wine"
export WINEPREFIX="$(realpath "${WINEPREFIX}")"

delete_symlinks_user_folders() {
  for folder in "${SYMLINKS_USER_FOLDERS[@]}"; do
    local user_folder="${WINEPREFIX}/dosdevices/c:/users/${USER}/${folder}"
    rm "${user_folder}"
    mkdir "${user_folder}"
  done
}

setup_symlinks_global_folders() {
  for folder in "${SYMLINKS_GLOBAL_FOLDERS[@]}"; do
    local global_folder="${GLOBAL_WINEPREFIX}/dosdevices/c:/${folder}"
    local user_folder="${WINEPREFIX}/dosdevices/c:/${folder}"
    rm -rf "${user_folder}"
    ln -s "${global_folder}" "${user_folder}"
  done
}

create_wineprefix() {
  symlink_to_global="$1"
  if [[ "${symlink_to_global}" == "-l" ]]; then
    mkdir -p "${WINEPREFIX}"
    ln -sf "${GLOBAL_WINEPREFIX}/dosdevices" "${WINEPREFIX}/"
    ln -sf "${GLOBAL_WINEPREFIX}/system.reg" "${WINEPREFIX}/"
  else
    "${WINE}" wineboot
    rm -rf "${WINEPREFIX}/dosdevices/c:/users/${USERS}"
  fi
}

DXVK_VKD3D_LIBS=(dxgi d3d8 d3d9 d3d10 d3d10core d3d11 d3d12 d3d12core)
LIB_LOAD_ORDER="native"
DXVK="${SOFTWARE}/dxvk"
VKD3D="${SOFTWARE}/vkd3d"

override_dll() {
  local lib="$1"
  local lib_data="$2"
  "${WINE}" reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' /v "${lib}" /d "${lib_data}" /f
}

SOFTWARE_SYSWOW64="${SOFTWARE}/syswow64"
SOFTWARE_SYSTEM32="${SOFTWARE}/system32"
WINEPREFIX_SYSTEM32="${WINEPREFIX}/dosdevices/c:/windows/system32"
WINEPREFIX_SYSWOW64="${WINEPREFIX}/dosdevices/c:/windows/syswow64"

setup_dxvk_vkd3d() {
  symlink_to_global="$1"
  if [[ "${symlink_to_global}" != "-l" ]]; then
    cp "${DXVK}"/x64/* "${WINEPREFIX_SYSTEM32}"
    cp "${DXVK}"/x32/* "${WINEPREFIX_SYSWOW64}"
    cp "${VKD3D}"/x64/* "${WINEPREFIX_SYSTEM32}"
    cp "${VKD3D}"/x86/* "${WINEPREFIX_SYSWOW64}"
  fi
  for lib in "${DXVK_VKD3D_LIBS[@]}"; do
    override_dll "${lib}" "${LIB_LOAD_ORDER}"
  done
}


import_dlls() {
  cp "${SOFTWARE_SYSTEM32}/"* "${WINEPREFIX_SYSTEM32}"
  cp "${SOFTWARE_SYSWOW64}/"* "${WINEPREFIX_SYSWOW64}"
}

setup_software() {
  symlink_to_global="$1"
  setup_dxvk_vkd3d "${symlink_to_global}"
  [[ "${symlink_to_global}" == -l ]] && return
  import_dlls
  for soft in $(ls "${SOFTWARE}"/*.exe); do
    "${WINE}" "${soft}"
  done
}

create_wineprefix "$1" &&
setup_software "$1"
