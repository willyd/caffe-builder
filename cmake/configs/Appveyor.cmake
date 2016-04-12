set(BUILD_SHARED_LIBS ON CACHE BOOL "" FORCE)
# build only the release config
set(BUILD_CONFIGURATION_TYPES "Release" CACHE BOOL "" FORCE)
# build only the release config
set(DEFAULT_SOURCE_DIR "${CMAKE_BINARY_DIR}/sources" CACHE PATH "" FORCE)
set(PYTHON27_PREFIX "C:/Users/user0804/AppData/Local/Continuum/Anaconda2" CACHE PATH "" FORCE)
# build only selected libraries for now
set(BUILD_ZLIB ON CACHE BOOL "" FORCE)
set(BUILD_HDF5 ON CACHE BOOL "" FORCE)
set(BUILD_BOOST OFF CACHE BOOL "" FORCE)
# build selected boost components
set(BOOST_COMPONENTS atomic chrono date_time filesystem python system thread CACHE STRING "" FORCE)
set(BUILD_LEVELDB OFF CACHE BOOL "" FORCE)
# build selected opencv components
set(BUILD_OPENCV OFF CACHE BOOL "" FORCE)
set(OPENCV_COMPONENTS core highgui imgproc imgcodecs videoio CACHE STRING "" FORCE)

set(BUILD_GFLAGS OFF CACHE BOOL "" FORCE)
set(BUILD_GLOG OFF CACHE BOOL "" FORCE)

set(BUILD_LMDB OFF CACHE BOOL "" FORCE)
set(BUILD_OPENBLAS OFF CACHE BOOL "" FORCE)

set(BUILD_PROTOBUF OFF CACHE BOOL "" FORCE)
set(BUILD_SNAPPY OFF CACHE BOOL "" FORCE)


