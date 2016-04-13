set(BUILD_SHARED_LIBS ON CACHE BOOL "" FORCE)
# build only the release config
set(BUILD_CONFIGURATION_TYPES "Release" CACHE BOOL "" FORCE)
# build only the release config
#set(DEFAULT_SOURCE_DIR "${CMAKE_BINARY_DIR}/sources" CACHE PATH "" FORCE)
# user profile installed
# file(TO_CMAKE_PATH "$ENV{APPDATA}" _app_data)
# set(PYTHON27_PREFIX "${_app_data}/../Local/Continuum/Anaconda2" CACHE PATH "" FORCE)
set(PYTHON27_PREFIX "C:/Python27-x64" CACHE PATH "" FORCE)
set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install/super-builder-libraries" CACHE PATH "" FORCE)
# build selected libraries these selected libraries only
# to fit inside the time limits on appveyor
if($ENV{BUILD_PART_1} STREQUAL "1")
  set(BUILD_PART_1 ON CACHE BOOL "" FORCE)
  set(BUILD_PART_2 OFF CACHE BOOL "" FORCE)
else()
  set(BUILD_PART_1 OFF CACHE BOOL "" FORCE)
  set(BUILD_PART_2 ON CACHE BOOL "" FORCE)
endif()

# Part 1 libs
set(BUILD_ZLIB ${BUILD_PART_1} CACHE BOOL "" FORCE)
set(BUILD_HDF5 ${BUILD_PART_1} CACHE BOOL "" FORCE)
# build selected opencv components
set(BUILD_OPENCV ${BUILD_PART_1} CACHE BOOL "" FORCE)
set(OPENCV_COMPONENTS core highgui imgproc imgcodecs videoio CACHE STRING "" FORCE)
set(BUILD_SNAPPY ${BUILD_PART_1} CACHE BOOL "" FORCE)
set(BUILD_GFLAGS ${BUILD_PART_1} CACHE BOOL "" FORCE)
set(BUILD_GLOG ${BUILD_PART_1} CACHE BOOL "" FORCE)

# Part 2 libs
# build these libraries afterwards by changing BUILD_PART_1: 0
set(BUILD_LMDB ${BUILD_PART_2} CACHE BOOL "" FORCE)
set(BUILD_OPENBLAS ${BUILD_PART_2} CACHE BOOL "" FORCE)
set(BUILD_PROTOBUF ${BUILD_PART_2} CACHE BOOL "" FORCE)
set(BUILD_BOOST ${BUILD_PART_2} CACHE BOOL "" FORCE)
# build selected boost components
set(BOOST_COMPONENTS atomic chrono date_time filesystem python system thread CACHE STRING "" FORCE)
set(BUILD_LEVELDB ${BUILD_PART_2} CACHE BOOL "" FORCE)


