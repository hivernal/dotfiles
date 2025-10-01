#!/usr/bin/bash

# WINE_BUILD_OPTIONS="--without-oss --disable-win16 --disable-tests"

BUILD_DIR="${BUILD_DIR:-${HOME}/downloads/git}"
WINE_NAME="${WINE_NAME:-amd64}"
WINE_DIR="${BUILD_DIR}"/wine-"${WINE_NAME}"

WINE_SRC="${WINE_SRC:-${BUILD_DIR}/wine}"
if [ -z "${WINE_SRC}" ]; then
  WINE_SRC="${BUILD_DIR}/wine"
else
  WINE_SRC="$(realpath ${WINE_SRC})"
fi

# export CC="gcc"
# export CXX="g++"
# export i386_CC="i686-w64-mingw32-gcc"
# export i386_CXX="i686-w64-mingw32-g++"
# export x86_64_CC="x86_64-w64-mingw32-gcc"
# export x86_64_CXX="x86_64-w64-mingw32-g++"
CFLAGS_X64="-march=native -O2 -pipe"
CFLAGS_X32="-march=native -O2 -pipe"
# export LDFLAGS="-Wl,-O1,--sort-common,--as-needed"
# export CROSSLDFLAGS="${LDFLAGS}"

build64() {
  export CFLAGS="${CFLAGS_X64}"
  export CXXFLAGS="${CFLAGS_X64}"
  export CROSSCFLAGS="${CFLAGS_X64}"
  export CROSSCXXFLAGS="${CFLAGS_X64}"
  mkdir -p "${BUILD_DIR}/build64" &&
  cd "${BUILD_DIR}/build64" &&
  "${WINE_SRC}/configure" --prefix="${WINE_DIR}" --enable-win64 ${WINE_BUILD_OPTIONS} &&
  make -j$(nproc)
}

build32() {
  export CFLAGS="${CFLAGS_X32}"
  export CXXFLAGS="${CFLAGS_X32}"
  export CROSSCFLAGS="${CFLAGS_X32}"
  mkdir -p "${BUILD_DIR}"/build32 &&
  cd "${BUILD_DIR}/build32" &&
  PKG_CONFIG_PATH=/usr/lib/pkgconfig "${WINE_SRC}/configure" --prefix="${WINE_DIR}" --with-wine64="${BUILD_DIR}/build64" ${WINE_BUILD_OPTIONS} &&
  make -j$(nproc)
}

install() {
  cd "${BUILD_DIR}/build32"
  make -j$(nproc) install
  cd "${BUILD_DIR}/build64"
  make -j$(nproc) install
}

rm -rf "${WINE_DIR}"
build64 &&
build32 &&
install
rm -rf "${BUILD_DIR}/build64" "${BUILD_DIR}/build32"
