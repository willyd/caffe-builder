mkdir build
pushd build

:: Configure
cmake -GNinja ^
      -D CB_BUILD_CONDA_PKG=ON ^
      -D CB_BUILD_ALL=OFF ^
      -D BUILD_OPENCV=ON ^
      -D OPENCV_BUILD_SHARED_LIBS=ON ^
      -D OPENCV_CLONE_FFMPEG=ON ^
      -D OPENCV_WITH_PYTHON=ON ^
      -D ZLIB_BUILD_SHARED_LIBS=ON ^
      -D ZLIB_LIB_PREFIX=caffe ^
      -D PYTHON_EXECUTABLE=%PYTHON% ^
      -D OPENCV_CMAKE_ARGS="-DPYTHON_LIBRARIES=%PREFIX%\libs\python%CONDA_PY%.lib" ^
      -D CMAKE_INSTALL_PREFIX:PATH=%LIBRARY_PREFIX% ^
      %SRC_DIR%

if errorlevel 1 exit 1

:: Build.
cmake --build .
if errorlevel 1 exit 1

if "%ARCH%" == "32" ( set "OPENCV_ARCH=86")
if "%ARCH%" == "64" ( set "OPENCV_ARCH=64")

robocopy %LIBRARY_PREFIX%\x%OPENCV_ARCH%\vc%VS_MAJOR%\bin %LIBRARY_PREFIX%\bin *.dll /E
if %ERRORLEVEL% GEQ 8 exit 1


popd

:: Remove confusing files
del %LIBRARY_PREFIX%\caffe-builder-config.cmake
del %LIBRARY_PREFIX%\prependpath.bat


