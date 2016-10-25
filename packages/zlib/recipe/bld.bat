mkdir build
pushd build

:: Configure
cmake -GNinja ^
      -D CB_BUILD_CONDA_PKG=ON ^
      -D CB_BUILD_ALL=OFF ^
      -D BUILD_ZLIB=ON ^
      -D ZLIB_BUILD_SHARED_LIBS=ON ^
      -D ZLIB_LIB_PREFIX=caffe ^
      -D CMAKE_INSTALL_PREFIX:PATH=%LIBRARY_PREFIX% ^
      %SRC_DIR%

if errorlevel 1 exit 1

:: Build.
cmake --build .
if errorlevel 1 exit 1

popd

:: Remove confusing files
del %LIBRARY_PREFIX%\caffe-builder-config.cmake
del %LIBRARY_PREFIX%\prependpath.bat
