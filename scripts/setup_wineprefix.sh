#!/usr/bin/bash

GAMES="/opt/games"
PREFIXES="${GAMES}/prefixes"
GLOBAL_WINEPREFIX="${GLOBAL_WINEPREFIX:-${PREFIXES}/global}"
WINE="${WINE:-wine}"
SOFTWARE="${PREFIXES}/software"
SYMLINKS_USER_FOLDERS=("Desktop" "Documents" "Downloads" "Music" "Pictures" "Videos")
SYMLINKS_GLOBAL_FOLDERS=("Program Files" "Program Files (x86)" "ProgramData" "windows" "Games")

export WINEPREFIX="${WINEPREFIX:-${HOME}/.wine}"

delete_symlinks_user_folders() {
  for folder in "${SYMLINKS_USER_FOLDERS[@]}"; do
    local user_folder="${WINEPREFIX}/drive_c/users/${USER}/${folder}"
    rm "${user_folder}"
    mkdir "${user_folder}"
  done
}

setup_symlinks_global_folders() {
  for folder in "${SYMLINKS_GLOBAL_FOLDERS[@]}"; do
    local global_folder="${GLOBAL_WINEPREFIX}/drive_c/${folder}"
    local user_folder="${WINEPREFIX}/drive_c/${folder}"
    rm -rf "${user_folder}"
    ln -s "${global_folder}" "${user_folder}"
  done
}

create_wineprefix() {
  symlink_to_global="$1"
  "${WINE}" wineboot
  delete_symlinks_user_folders
  if [[ "${symlink_to_global}" == "-l" ]]; then
    setup_symlinks_global_folders
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

setup_dxvk_vkd3d() {
  local system32="${WINEPREFIX}/dosdevices/c:/windows/system32"
  local syswow64="${WINEPREFIX}/dosdevices/c:/windows/syswow64"
  cp "${DXVK}"/x64/* "${system32}"
  cp "${DXVK}"/x32/* "${syswow64}"
  cp "${VKD3D}"/x64/* "${system32}"
  cp "${VKD3D}"/x86/* "${syswow64}"
  for lib in "${DXVK_VKD3D_LIBS[@]}"; do
    override_dll "${lib}" "${LIB_LOAD_ORDER}"
  done
}

setup_software() {
  for soft in $(ls "${SOFTWARE}"/*.exe); do
    wine "${soft}"
  done
}

create_wineprefix "$1" &&
setup_dxvk_vkd3d  &&
setup_software
