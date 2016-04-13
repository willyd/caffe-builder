set(BUILD_SHARED_LIBS ON CACHE BOOL "" FORCE)
# build only the release config
set(BUILD_CONFIGURATION_TYPES "Release" CACHE BOOL "" FORCE)
# build only the release config
#set(DEFAULT_SOURCE_DIR "${CMAKE_BINARY_DIR}/sources" CACHE PATH "" FORCE)
# user profile installed
# file(TO_CMAKE_PATH "$ENV{APPDATA}" _app_data)
# set(PYTHON27_PREFIX "${_app_data}/../Local/Continuum/Anaconda2" CACHE PATH "" FORCE)
set(PYTHON27_PREFIX "C:/Python27-x64" CACHE PATH "" FORCE)
set(CMAKE_INSTALL_PREFIX "C:/projects/super-builder-libraries" CACHE PATH "" FORCE)
# build selected libraries these selected libraries only
# to fit inside the time limits on appveyor
set(BUILD_PART_1 ON)
set(BUILD_PART_2 OFF)

set(BUILD_ZLIB ${BUILD_PART_1} CACHE BOOL "" FORCE)
set(BUILD_HDF5 ${BUILD_PART_1} CACHE BOOL "" FORCE)
# build selected opencv components
set(BUILD_OPENCV ${BUILD_PART_1} CACHE BOOL "" FORCE)
set(OPENCV_COMPONENTS core highgui imgproc imgcodecs videoio CACHE STRING "" FORCE)
set(BUILD_SNAPPY ${BUILD_PART_1} CACHE BOOL "" FORCE)
set(BUILD_GFLAGS ${BUILD_PART_1} CACHE BOOL "" FORCE)
set(BUILD_GLOG ${BUILD_PART_1} CACHE BOOL "" FORCE)

# build these libraries afterwards
set(BUILD_LMDB ${BUILD_PART_2} CACHE BOOL "" FORCE)
set(BUILD_OPENBLAS ${BUILD_PART_2} CACHE BOOL "" FORCE)
set(BUILD_PROTOBUF ${BUILD_PART_2} CACHE BOOL "" FORCE)
set(BUILD_BOOST ${BUILD_PART_2} CACHE BOOL "" FORCE)
# build selected boost components
set(BOOST_COMPONENTS atomic chrono date_time filesystem python system thread CACHE STRING "" FORCE)
set(BUILD_LEVELDB ${BUILD_PART_2} CACHE BOOL "" FORCE)


