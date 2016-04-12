cmake_minimum_required(VERSION 3.0)

project(HDF5 VERSION 1.8.16)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

include(ArchiveDownloadScheme)

# using cmake to build
include(CMakeScheme)

# a download target
add_download_target(URL "https://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8.16/src/CMake-hdf5-1.8.16.zip"
					)

ExternalProject_Get_Property("${PROJECT_NAME}_download" SOURCE_DIR)
set(SOURCE_DIR ${SOURCE_DIR}/hdf5-${PROJECT_VERSION})

# add build targets
add_build_targets(CMAKE_ARGS -DHDF5_ENABLE_Z_LIB_SUPPORT=ON
				  -DBUILD_TESTING=OFF
				  -DHDF5_BUILD_EXAMPLES=OFF
				  -DHDF5_BUILD_TOOLS=OFF
				   DEPENDS ZLIB
				  )
                    
