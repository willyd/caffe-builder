cmake_minimum_required (VERSION 3.0 FATAL_ERROR)

set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/install" CACHE PATH "Path where to install binaries")

project (caffe-builder)

set(CB_DOWNLOAD_DIR "${CMAKE_CURRENT_BINARY_DIR}/download" CACHE STRING "Download directory")
set(CB_BUILD_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Build the given configs")
#set(CB_BUILD_CONDA_PKG OFF CACHE BOOL "Building a conda package")
option(BUILD_SHARED_LIBS "Build static or shared libs" OFF)
option(CB_BUILD_ALL "Build all packages" ON)

# install all Find<package>.cmake module to install_prefix/cmake
set(CB_CMAKE_MODULE_PATH ${CMAKE_INSTALL_PREFIX}/cmake/modules)
# install module can reference the installation path using this value
set(CB_MODULE_ROOT \${CMAKE_CURRENT_LIST_DIR}/../../)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(ProcessorCount)
ProcessorCount(NUMBER_OF_PROCESSORS)

find_package(PythonInterp)
if(NOT PYTHON_EXECUTABLE)
    message(WARNING "Cannot make packages relocatable since python was not found. Set PYTHON_EXECUTABLE to your python path.")
endif()

find_package(Git REQUIRED)

add_subdirectory(packages/zlib)
add_subdirectory(packages/gflags)
add_subdirectory(packages/glog)
add_subdirectory(packages/hdf5)
add_subdirectory(packages/boost)
add_subdirectory(packages/leveldb)
add_subdirectory(packages/lmdb)
add_subdirectory(packages/opencv)
add_subdirectory(packages/protobuf)
add_subdirectory(packages/openblas)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/caffe-builder-config.cmake.in ${CMAKE_INSTALL_PREFIX}/caffe-builder-config.cmake @ONLY)







