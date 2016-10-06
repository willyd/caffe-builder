@echo off
:: Set python 2.7 with conda as the default python
set PATH=C:\Miniconda-x64;C:\Miniconda-x64\Scripts;C:\Miniconda-x64\Library\bin;%PATH%
:: Check that we have the right python version
python --version
:: Add the required channels
conda config --add channels conda-forge
:: Update conda
conda update conda -y
:: Install cmake and ninja
conda install --yes cmake ninja

:: Create build directory and configure cmake
mkdir build
pushd build
:: Setup the environement for VS 2013 or 2015 x64
call setenv.cmd %MSVC_TOOLSET% 64
:: configure
:: Don't build all packages
:: Build only selected packages
:: Use shared libraries when possible
cmake -G Ninja ^
      -D CB_BUILD_ALL:BOOL=OFF ^
      -D BUILD_ZLIB:BOOL=%BUILD_ZLIB% ^
      -D ZLIB_BUILD_SHARED_LIBS:BOOL=ON ^
      -D BUILD_GFLAGS:BOOL=%BUILD_GFLAGS% ^
      -D GFLAGS_BUILD_SHARED_LIBS:BOOL=ON ^
      -D BUILD_GLOG:BOOL=%BUILD_GLOG% ^
      -D GLOG_BUILD_SHARED_LIBS:BOOL=ON ^
      -D BUILD_HDF5:BOOL=%BUILD_HDF5% ^
      -D HDF5_BUILD_SHARED_LIBS:BOOL=ON ^
      -D BUILD_BOOST:BOOL=%BUILD_BOOST% ^
      -D BOOST_BUILD_SHARED_LIBS:BOOL=ON ^
      -D BUILD_LEVELDB:BOOL=%BUILD_LEVELDB% ^
      -D LEVELDB_BUILD_SHARED_LIBS:BOOL=OFF ^
      -D BUILD_LMDB:BOOL=%BUILD_LMDB% ^
      -D LMDB_BUILD_SHARED_LIBS:BOOL=OFF ^
      -D BUILD_OPENCV:BOOL=%BUILD_OPENCV% ^
      -D OPENCV_BUILD_SHARED_LIBS:BOOL=ON ^
      -D BUILD_PROTOBUF:BOOL=%BUILD_PROTOBUF% ^
      -D PROTOBUF_BUILD_SHARED_LIBS:BOOL=OFF ^
      -D BUILD_OPENBLAS:BOOL=%BUILD_OPENBLAS% ^
      -D OPENBLAS_BUILD_SHARED_LIBS:BOOL=ON ^
      -D BUILD_SNAPPY:BOOL=%BUILD_SNAPPY% ^
      -D SNAPPY_BUILD_SHARED_LIBS:BOOL=OFF ^
      ..\
:: build
cmake --build .
popd

