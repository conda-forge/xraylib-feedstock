if [ $(uname) = Darwin ] ; then
	CFLAGS+=" -Wno-error=deprecated-declarations "
fi

./configure --enable-python --disable-perl --disable-java --disable-ruby \
	    --disable-fortran2003 --disable-lua --prefix=$PREFIX
make
make install
