cmake_minimum_required (VERSION 3.0 FATAL_ERROR)

set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/install" CACHE PATH "Path where to install binaries")

project (super-builder)

set(CB_DOWNLOAD_DIR "${CMAKE_CURRENT_BINARY_DIR}/download" CACHE STRING "Download directory")
set(CB_BUILD_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Build the given configs")
set(CB_BUILD_CONDA_PKG OFF CACHE BOOL "Building a conda package")
option(BUILD_SHARED_LIBS "Build static or shared libs" OFF)

# install all Find<package>.cmake module to install_prefix/cmake
set(CB_CMAKE_MODULE_PATH ${CMAKE_INSTALL_PREFIX}/cmake/modules)
# install module can reference the installation path using this value
set(CB_MODULE_ROOT \${CMAKE_CURRENT_LIST_DIR}/../../)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")


add_subdirectory(packages/zlib)
add_subdirectory(packages/gflags)
add_subdirectory(packages/glog)
add_subdirectory(packages/hdf5 )
# if(CMAKE_GENERATOR MATCHES "Ninja" AND MSVC)
#     set(_test_cl_file "${CMAKE_CURRENT_BINARY_DIR}/test_cl_in_path.cpp")
#     if(NOT EXISTS "${_test_cl_file}")
#         file(WRITE "${_test_cl_file}" "int main(int argc, char* argv[]) {return 0;}")
#     endif()
#     message(STATUS "Using Ninja")
#     try_compile(_cl_in_path ${CMAKE_CURRENT_BINARY_DIR} "${_test_cl_file}")
#     if(NOT _cl_in_path)
#         message(FATAL_ERROR "Failed to compile a simple source file. Please call the appropriate vcvarsall.bat file.")
#     endif()
# endif()

# include(ExternalProject)
# include(ForceDependentOption)

# option(BUILD_SHARED_LIBS "Build static or shared libs" OFF)
# set(BUILD_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Build the given configs")

# set (DEFAULT_SOURCE_DIR "" CACHE PATH "Path where the sources should be downloaded")
# set(PYTHON27_PREFIX "" CACHE PATH "The prefix of your python 2.7 installation")

# # copy all the Find*.cmake modules to the install directory
# file(GLOB _find_modules ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules/*.cmake)
# foreach(_find_module ${_find_modules})
#     get_filename_component(_file_name ${_find_module} NAME)
#     # use configure_file
#     configure_file(${_find_module} ${CMAKE_INSTALL_PREFIX}/cmake/${_file_name} @ONLY)
# endforeach()

# # glob all packages
# file(GLOB _package_dirs LIST_DIRECTORIES true ${CMAKE_CURRENT_SOURCE_DIR}/packages/*)
# foreach(_package_dir ${_package_dirs})
#     get_filename_component(_package_name ${_package_dir} NAME)
#     list(APPEND _packages ${_package_name})
# endforeach()

# # define an option to build the package or not
# foreach(_package_name ${_packages})
#     string(TOUPPER ${_package_name} _package_upper)
#     option(BUILD_${_package_upper} "Build ${_package_name}?" ON)
#     set(_package_spec ${CMAKE_CURRENT_SOURCE_DIR}/packages/${_package_name}/spec.cmake)
#     if(EXISTS ${_package_spec})
#         include(${_package_spec})
#     endif()
# endforeach()

# # TODO change this to spec.cmake
# # force dependencies to build if disable
# add_package_dependency(HDF5 ZLIB)
# add_package_dependency(glog gflags)
# add_package_dependency(opencv ZLIB)
# add_package_dependency(snappy ZLIB)
# add_package_dependency(leveldb boost)



# # add targets for selected packages
# add_packages("${_packages}")

# # generate the InitialCache.cmake
# set(_CMAKE_PREFIX_PATH ${CMAKE_INSTALL_PREFIX})
# set(_CMAKE_MODULE_PATH ${CMAKE_INSTALL_PREFIX}/cmake)
# set(_config_in ${CMAKE_CURRENT_SOURCE_DIR}/cmake/InitialCache.cmake.in)
# set(_config_out ${CMAKE_INSTALL_PREFIX}/InitialCache.cmake)

# configure_file(${_config_in} ${_config_out} @ONLY)








