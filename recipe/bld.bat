REM set TMP="%LOCALAPPDATA%\Temp"
REM set TEMP="%LOCALAPPDATA%\Temp"
REM set TMPDIR="%LOCALAPPDATA%\Temp"
IF "%ARCH%" == "64" (
set GCC_ARCH=x86_64-w64-mingw32
set EXTRA_FLAGS=-DMS_WIN64
) else (
set GCC_ARCH=i686-w64-mingw32
)
bash -lc "ln -s ${LOCALAPPDATA}/Temp /tmp"
bash -lc "curl -L -O https://ftp.pcre.org/pub/pcre/pcre-8.42.tar.bz2 && tar xfj pcre-8.42.tar.bz2 && cd pcre-8.42 && ./configure --build=$GCC_ARCH --host=$GCC_ARCH --target=$GCC_ARCH --enable-utf8 --enable-pcre8 --prefix=/mingw-w64 && make && make install"
bash -lc "curl -L -O https://downloads.sourceforge.net/project/swig/swig/swig-3.0.12/swig-3.0.12.tar.gz && tar xfz swig-3.0.12.tar.gz && cd swig-3.0.12 && ./configure --build=$GCC_ARCH --host=$GCC_ARCH --target=$GCC_ARCH --without-perl5 --without-guile --disable-ccache --prefix=/mingw-w64 && make && make install"
bash -lc "gendef ${PREFIX}/python${CONDA_PY}.dll && dlltool -l libpython${CONDA_PY}.a -d python${CONDA_PY}.def -k -A"
bash -lc "./configure --disable-static --build=$GCC_ARCH --host=$GCC_ARCH --target=$GCC_ARCH --enable-python-integration --disable-perl --disable-lua --disable-ruby --disable-fortran2003 --enable-python --prefix=`cygpath -u $PREFIX` --bindir=`cygpath -u $LIBRARY_BIN` --libdir=`cygpath -u $LIBRARY_LIB` PYTHON=`which python` SWIG=`which swig` CPPFLAGS=$EXTRA_FLAGS LIBS=-L$PWD"
bash -lc "make"
bash -lc "make install"
bash -lc "rm -rf $PREFIX/Library/tmp"
bash -lc "rm `cygpath -u $LIBRARY_LIB`/libxrl.la"
bash -lc "rm `cygpath -u $SP_DIR`/*.la"
bash -lc "cd swig-3.0.12 && make uninstall"
bash -lc "cd pcre-8.42 && make uninstall"
bash -lc "rm -rf /mingw-w64/share/swig"
bash -lc "rm -rf /mingw-w64/share/doc/pcre"
bash -lc "rm -rf /mingw-w64/share/man/*/pcre*"
