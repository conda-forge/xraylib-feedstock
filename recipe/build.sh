set -e -x

if [ $(uname) = Darwin ] ; then
	CFLAGS+=" -Wno-error=deprecated-declarations "
fi

if [[ "$target_platform" == win* ]]; then
	export CFLAGS+=" -Wno-error=unused-function "
	export GCC_ARCH=x86_64-w64-mingw32
	export EXTRA_FLAGS=-DMS_WIN64
	# install pcre
	curl -L -O https://ftp.pcre.org/pub/pcre/pcre-8.42.tar.bz2
	tar xfj pcre-8.42.tar.bz2
	cd pcre-8.42
	./configure --build=$GCC_ARCH --host=$GCC_ARCH --target=$GCC_ARCH --enable-utf8 --enable-pcre8 --disable-cpp --prefix=/mingw-w64
	patch_libtool
	make
	make install
	cd ..

	# install swig
	curl -L -O https://downloads.sourceforge.net/project/swig/swig/swig-3.0.12/swig-3.0.12.tar.gz
	tar xfz swig-3.0.12.tar.gz
	cd swig-3.0.12
	./configure --build=$GCC_ARCH --host=$GCC_ARCH --target=$GCC_ARCH --without-perl5 --without-guile --disable-ccache --prefix=/mingw-w64 CPPFLAGS="$CPPFLAGS -DPCRE_EXP_DECL=extern"
	make
	make install
	cd ..

	curl -L -O https://patch-diff.githubusercontent.com/raw/tschoonj/xraylib/pull/132.diff
	patch -p1 < 132.diff || true
	sed -i.bak "s/-Wl,-subsystem,windows//g" configure.ac
	autoreconf -fi
	./configure \
		--disable-output-def \
		--disable-static \
		--build=$GCC_ARCH --host=$GCC_ARCH --target=$GCC_ARCH \
		--enable-python-integration \
		--disable-perl \
		--disable-lua \
		--disable-ruby \
		--disable-fortran2003 \
		--enable-python \
		--prefix=`cygpath -u $PREFIX` \
		--bindir=`cygpath -u $LIBRARY_BIN` \
		--libdir=`cygpath -u $LIBRARY_LIB` \
		PYTHON=`which python` \
		SWIG=`which swig` \
		CPPFLAGS="$CPPFLAGS $EXTRA_FLAGS" \
		LIBS="$LIBS -L`cygpath -u $PREFIX`/../libs -llegacy_stdio_definitions" \
		|| (cat config.log && exit 1)
	patch_libtool
	make
	make install
	rm -rf $PREFIX/Library/tmp
	rm `cygpath -u $LIBRARY_LIB`/libxrl.la
	mv `cygpath -u $LIBRARY_LIB`/xrl.dll.lib `cygpath -u $LIBRARY_LIB`/xrl.lib
	rm `cygpath -u $SP_DIR`/*.la
	rm `cygpath -u $SP_DIR`/*.lib
	cd swig-3.0.12 && make uninstall && cd ..
	cd pcre-8.42 && make uninstall && cd ..
	rm -rf /mingw-w64/share/swig
	rm -rf /mingw-w64/share/doc/pcre
	rm -rf /mingw-w64/share/man/*/pcre*
else
	unset CC_FOR_BUILD
	unset CXX_FOR_BUILD
	unset HOST
	unset host_alias
	./configure --enable-python --disable-perl --disable-java --disable-ruby \
		    --disable-fortran2003 --disable-lua --prefix=$PREFIX
	make
	make install
fi
