set TMP=%LOCALAPPDATA%\Temp
set TEMP=%LOCALAPPDATA%\Temp
bash -lc "cd $PREFIX && gendef python${CONDA_PY}.dll && dlltool -l Libs/libpython${CONDA_PY}.a -d python${CONDA_PY}.def -k -A"
bash -lc "export PATH=$PATH:$PREFIX/Library/bin && autoreconf -fi && ./configure --enable-python-integration --prefix=`cygpath -u $PREFIX` PYTHON=`which python` && make && make install"
