cmake_minimum_required(VERSION 3.0)

project(LMDB VERSION 0.9.70)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

include(GitRepoDownloadScheme)

# using cmake to build
include(CMakeScheme)

# a download target
add_download_target(URL https://github.com/willyd/lmdb.git
		            TAG cmake2					
					)

ExternalProject_Get_Property("${PROJECT_NAME}_download" SOURCE_DIR)
set(SOURCE_DIR ${SOURCE_DIR}/libraries/liblmdb)

set(CMAKE_DEBUG_POSTFIX "d")
# add build targets
# LMDB cannot be built as a shared lib
add_build_targets(CMAKE_ARGS -DBUILD_SHARED_LIBS=OFF)
                    
