cmake_minimum_required (VERSION 3.0 FATAL_ERROR)

set (CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/install" CACHE PATH "Path where to install binaries")

project (caffe-builder)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/modules")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/packages")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

set(BUILDEM_DOWNLOAD_CACHE ${CMAKE_CURRENT_BINARY_DIR}/DownloadCache)

option(BUILD_DebugAndRelease "Build both configuration in batch" ON)

include(buildem_all)

# order is important dependees go before dependers
include(ZLIB)
include(OpenCV) # depends on ZLIB
include(HDF5) # depends on ZLIB
include(Boost)
include(gflags)
include(glog) # depends (optionally) on gflags
include(lmdb)
include(snappy)
include(leveldb) # depends on Boost
include(protobuf) 
include(OpenBLAS) 
include(Caffe) # depends on all the above except cvmatio







