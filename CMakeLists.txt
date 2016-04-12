cmake_minimum_required (VERSION 3.0 FATAL_ERROR)

project (caffe-builder)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(ExternalProject)
include(ForceDependentOption)

option(BUILD_SHARED_LIBS "Build static or shared libs" OFF)
set(BUILD_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Build the given configs")
set (CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/install" CACHE PATH "Path where to install binaries" FORCE)
set (DEFAULT_SOURCE_DIR "" CACHE PATH "Path where the sources should be downloaded")
set(PYTHON27_PREFIX "" CACHE PATH "The prefix of your python 2.7 installation")

# copy all the Find*.cmake modules to the install directory
file(GLOB _find_modules ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules/*.cmake)
foreach(_find_module ${_find_modules})
    get_filename_component(_file_name ${_find_module} NAME)    
    # use configure_file
    configure_file(${_find_module} ${CMAKE_INSTALL_PREFIX}/cmake/${_file_name} @ONLY)
endforeach()

# glob all packages
file(GLOB _package_dirs LIST_DIRECTORIES true ${CMAKE_CURRENT_SOURCE_DIR}/packages/*)
foreach(_package_dir ${_package_dirs})
    get_filename_component(_package_name ${_package_dir} NAME)
    list(APPEND _packages ${_package_name})
endforeach()

# define an option to build the package or not
foreach(_package_name ${_packages})   
    string(TOUPPER ${_package_name} _package_upper)
    option(BUILD_${_package_upper} "Build ${_package_name}?" ON)    
endforeach()

# force dependencies to build if disable
add_package_dependency(HDF5 ZLIB)
add_package_dependency(glog gflags)
add_package_dependency(opencv ZLIB)
add_package_dependency(snappy ZLIB)
add_package_dependency(leveldb boost)

# add targets for selected packages
add_packages("${_packages}")

# generate the InitialCache.cmake
set(_CMAKE_PREFIX_PATH ${CMAKE_INSTALL_PREFIX})
set(_CMAKE_MODULE_PATH ${CMAKE_INSTALL_PREFIX}/cmake)
set(_config_in ${CMAKE_CURRENT_SOURCE_DIR}/cmake/InitialCache.cmake.in)
set(_config_out ${CMAKE_INSTALL_PREFIX}/InitialCache.cmake)

configure_file(${_config_in} ${_config_out} @ONLY)








