# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./build-aux
set -e -x

export CI=true

if [[ $(uname) == Darwin ]]; then
  export FCFLAGS="-isysroot $CONDA_BUILD_SYSROOT $FCFLAGS"
  export PATH="${PATH}:${RECIPE_DIR}/fake-bin"
fi


mkdir build
cd build
meson --prefix=$PREFIX \
      --buildtype=release \
      --libdir=lib \
      --default-library=shared \
      -Dfortran-bindings=enabled \
      -Dpython-bindings=enabled \
      -Dpython-numpy-bindings=enabled \
      -Dpython=$PREFIX/bin/python \
      ..
ninja
ninja test
ninja install
