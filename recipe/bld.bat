setlocal EnableDelayedExpansion
@echo on

set CI=true

:: meson options
set ^"MESON_OPTIONS=^
  --prefix="%LIBRARY_PREFIX%" ^
  --default-library=shared ^
  --buildtype=release ^
  --backend=ninja ^
  -Dfortran-bindings=disabled ^
  -Dpython-bindings=enabled ^
  -Dpython-numpy-bindings=enabled ^
  -Dpython="%PYTHON%" ^
 ^"

:: configure build using meson
meson setup builddir !MESON_OPTIONS!
if errorlevel 1 exit 1

:: print results of build configuration
meson configure builddir
if errorlevel 1 exit 1

ninja -v -C builddir -j %CPU_COUNT%
if errorlevel 1 exit 1

ninja -C builddir install -j %CPU_COUNT%
if errorlevel 1 exit 1


@REM For some reason conda-build decides that the meson files in Scripts are new?
del %PREFIX%\Scripts\meson* %PREFIX%\Scripts\wraptool*

@REM Meson doesn't put the Python files in the right place.
cd %LIBRARY_PREFIX%\lib\python*
cd site-packages
move *xraylib* %PREFIX%\lib\site-packages\
