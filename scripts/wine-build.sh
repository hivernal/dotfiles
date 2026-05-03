#!/usr/bin/env bash

BUILD_DIR="${BUILD_DIR:-${PWD}}"
BUILD64_DIR="${BUILD_DIR}/build64"
BUILD32_DIR="${BUILD_DIR}/build32"
BUILD_WOW64_DIR="${BUILD_DIR}/build_wow64"
WINE_NAME="${WINE_NAME:-amd64}"
PREFIX="${PREFIX:-${BUILD_DIR}/wine-${WINE_NAME}}"
WINE_SRC="${WINE_SRC:-${PWD}/wine}"
WINE_BUILD_OPTIONS="--prefix="${PREFIX}""
# WINE_BUILD_OPTIONS="--prefix='${PREFIX}' --without-oss --disable-win16 --disable-tests"
DEFAULT_CFLAGS="-march=native -O2 -pipe"

build() {
  mkdir -p "$1" && cd "$1"
  shift 1
  CC="${CC:-clang}" \
  CROSSCC="${CROSSCC:-$CC}" \
  CXX="${CXX:-clang++}" \
  CROSSCCXX="${CROSSCCXX:-$CXX}" \
  CFLAGS="${CFLAGS:-$DEFAULT_CFLAGS}" \
  CROSSCFLAGS="${CROSSCXXFLAGS:-$DEFAULT_CFLAGS}" \
  CXXFLAGS="${CXXFLAGS:-$DEFAULT_CFLAGS}" \
  CROSSCXXFLAGS="${CROSSCXXFLAGS:-$DEFAULT_CFLAGS}" \
  "${WINE_SRC}/configure" "${WINE_BUILD_OPTIONS}" "${@}" &&
  make -j$(nproc)
}

install() {
  cd "$1" && make -j$(nproc) install
}

build64() {
  build "${BUILD64_DIR}" --enable-win64 "${@}"
}

install64() {
  install "${BUILD64_DIR}"
}

build32() {
  build "${BUILD32_DIR}" "${@}"
}

install32() {
  install "${BUILD32_DIR}"
}

build_wow64() {
  build "${BUILD_WOW64_DIR}" --enable-archs=i386,x86_64 "${@}"
}

install_wow64() {
  install "${BUILD_WOW64_DIR}"
}

if [[ "${WINEARCH}" == "wow64" ]]; then
  build_wow64 "${@}" &&
  install_wow64
elif [[ "${WINEARCH}" == "win32" ]]; then
  build32 "${@}" &&
  install32
else
  build64 "${@}" &&
  PKG_CONFIG_PATH="${PKG_CONFIG_PATH:-/usr/lib/pkgconfig}" build32 --with-wine64="${BUILD64_DIR}" "${@}" &&
  install32  &&
  install64
fi
rm -rf "${BUILD64_DIR}" "${BUILD32_DIR}" "${BUILD_WOW64_DIR}"
