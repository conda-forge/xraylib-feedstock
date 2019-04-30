which bash
autoreconf -i
./configure --enable-python --disable-perl --disable-java \
	    --disable-fortran2003 --disable-lua --prefix=$PREFIX SHELL=`which bash`
make
make install
