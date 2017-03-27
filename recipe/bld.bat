REM set TMP="%LOCALAPPDATA%\Temp"
REM set TEMP="%LOCALAPPDATA%\Temp"
REM set TMPDIR="%LOCALAPPDATA%\Temp"
bash -lc "ln -s ${LOCALAPPDATA}/Temp /tmp"
bash -lc "curl -L -O https://downloads.sourceforge.net/project/swig/swig/swig-3.0.12/swig-3.0.12.tar.gz && tar xfz swig-3.0.12.tar.gz && cd swig-3.0.12 && ./configure && make && make install"
bash -lc "cd $PREFIX && gendef python${CONDA_PY}.dll && dlltool -l Libs/libpython${CONDA_PY}.a -d python${CONDA_PY}.def -k -A"
bash -lc "export PATH=$PATH:$PREFIX/Library/bin && autoreconf -fi && ./configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --enable-python-integration --disable-libxrl --disable-fortran2003 --prefix=`cygpath -u $PREFIX` PYTHON=`which python` SWIG=`which swig` LIBS=-L$PREFIX && make && make install"
bash -lc "rm -r $PREFIX/include/xraylib"
