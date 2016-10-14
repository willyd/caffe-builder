@echo off
if NOT EXIST build_v140_x64 (
mkdir build_v140_x64
)

pushd build_v140_x64
:: Setup the environement for VS 2015 x64
call "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" amd64
:: configure
:: Build all packages
:: Use shared libraries when possible
cmake -G Ninja ^
      -D CB_BUILD_ALL:BOOL=ON ^
      -D ZLIB_LIB_PREFIX:STRING=caffe ^
      -D ZLIB_BUILD_SHARED_LIBS:BOOL=ON ^
      -D GFLAGS_BUILD_SHARED_LIBS:BOOL=ON ^
      -D GLOG_BUILD_SHARED_LIBS:BOOL=ON ^
      -D HDF5_BUILD_SHARED_LIBS:BOOL=ON ^
      -D HDF5_LIB_PREFIX:STRING=caffe ^
      -D BOOST_BUILD_SHARED_LIBS:BOOL=ON ^
      -D LEVELDB_BUILD_SHARED_LIBS:BOOL=OFF ^
      -D LMDB_BUILD_SHARED_LIBS:BOOL=OFF ^
      -D OPENCV_BUILD_SHARED_LIBS:BOOL=ON ^
      -D PROTOBUF_BUILD_SHARED_LIBS:BOOL=OFF ^
      -D OPENBLAS_BUILD_SHARED_LIBS:BOOL=ON ^
      -D SNAPPY_BUILD_SHARED_LIBS:BOOL=OFF ^
      %~dp0
:: build
cmake --build .
popd