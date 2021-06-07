set -e -x

export CI=true

if [[ $(uname) == Darwin ]]; then
  export FCFLAGS="-isysroot $CONDA_BUILD_SYSROOT $FCFLAGS"
  export PATH="${PATH}:${RECIPE_DIR}/fake-bin"
  export PKG_CONFIG=$BUILD_PREFIX/bin/pkg-config
fi

USE_FORTRAN=enabled

if [[ "$target_platform" == "osx-arm64" && "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  USE_FORTRAN=disabled
fi

if [ -z "$MESON_ARGS" ]; then
  # for some reason this is not set on Linux
  MESON_ARGS="--buildtype=release --prefix=${PREFIX} --libdir=lib"
fi

mkdir build
cd build
meson ${MESON_ARGS} \
      --default-library=shared \
      -Dfortran-bindings=${USE_FORTRAN} \
      -Dpython-bindings=enabled \
      -Dpython-numpy-bindings=enabled \
      -Dpython=$PYTHON \
      ..
ninja
if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
  ninja test
fi
ninja install
