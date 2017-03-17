bash -lc "cd $PREFIX && gendef python${PY}.dll && dlltool -l Libs/libpython${py}.a -d python${PY}.def -k -A"
bash -lc "export PATH=$PATH:$PREFIX/Library/bin && autoreconf -fi && ./configure --enable-python-integration --prefix=$PREFIX && make && make install"
