#!/usr/bin/bash

BUILD_DIR="${BUILD_DIR:-${PWD}}"
BUILD64_DIR="${BUILD_DIR}/build64"
BUILD32_DIR="${BUILD_DIR}/build32"
BUILD_WOW64_DIR="${BUILD_DIR}/build_wow64"
WINE_NAME="${WINE_NAME:-amd64}"
PREFIX="${PREFIX:-${BUILD_DIR}/wine-${WINE_NAME}}"
WINE_SRC="${WINE_SRC:-${PWD}/wine}"
WINE_BUILD_OPTIONS="--prefix="${PREFIX}""
# WINE_BUILD_OPTIONS="--prefix='${PREFIX}' --without-oss --disable-win16 --disable-tests"

# export CC="gcc"
# export CXX="g++"
# export i386_CC="i686-w64-mingw32-gcc"
# export i386_CXX="i686-w64-mingw32-g++"
# export x86_64_CC="x86_64-w64-mingw32-gcc"
# export x86_64_CXX="x86_64-w64-mingw32-g++"
CFLAGS64="-march=native -O2 -pipe"
CFLAGS32="-march=native -O2 -pipe"
# export LDFLAGS="-Wl,-O1,--sort-common,--as-needed"
# export CROSSLDFLAGS="${LDFLAGS}"

build() {
  export CFLAGS="$1"
  export CXXFLAGS="$1"
  export CROSSCFLAGS="$1"
  export CROSSCXXFLAGS="$1"
  mkdir -p "$2" && cd "$2"
  shift 2
  "${WINE_SRC}/configure" "${WINE_BUILD_OPTIONS}" "${@}" &&
  make -j$(nproc)
}

install() {
  cd "$1" && make -j$(nproc) install
}

build64() {
  build "${CFLAGS64}" "${BUILD64_DIR}" --enable-win64 "${@}"
}

install64() {
  install "${BUILD64_DIR}"
}

build32() {
  build "${CFLAGS32}" "${BUILD32_DIR}" "${@}"
}

install32() {
  install "${BUILD32_DIR}"
}

build_wow64() {
  build "${CFLAGS64}" "${BUILD_WOW64_DIR}" --enable-archs=i386,x86_64 "${@}"
}

install_wow64() {
  install "${BUILD_WOW64_DIR}"
}

rm -rf "${PREFIX}"
if [[ "${WINEARCH}" == "wow64" ]]; then
  build_wow64 "${@}" &&
  install_wow64
elif [[ "${WINEARCH}" == "win32" ]]; then
  build32 "${@}" &&
  install32
else
  build64 "${@}" &&
  PKG_CONFIG_PATH=/usr/lib/pkgconfig build32 --with-wine64="${BUILD64_DIR}" "${@}" &&
  install32  &&
  install64
fi

rm -rf "${BUILD64_DIR}" "${BUILD32_DIR}" "${BUILD_WOW64_DIR}"
