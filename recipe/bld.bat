bash -lc "cd $PREFIX && gendef python${PY}.dll && dlltool -l Libs/libpython${py}.a -d python${PY}.def -k -A"
