:: Set a few cmake variables
call set_cmake_vars

mkdir build
pushd build

:: Configure
cmake -GNinja ^
      -D CB_BUILD_CONDA_PKG=ON ^
      -D BUILD_ZLIB=ON ^
      -D CMAKE_PREFIX_PATH=%CMAKE_PREFIX_PATH% ^
      -D CMAKE_INSTALL_PREFIX:PATH=%CMAKE_INSTALL_PREFIX_ALT% ^
      -D CMAKE_DEBUG_POSTFIX=d ^
      -D ZLIB_TARGET_NAME_PREFIX=alt- ^
      %SRC_DIR%

if errorlevel 1 exit 1

:: Build.
cmake --build . --target install --config %%B
if errorlevel 1 exit 1

popd

:: Copy dlls to Library/bin so they can be found on the path
copy /Y "%LIBRARY_PREFIX%\alt\bin\*zlib*.dll" "%LIBRARY_BIN%"
