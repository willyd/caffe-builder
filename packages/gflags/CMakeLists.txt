cmake_minimum_required(VERSION 3.0)

project(gflags VERSION 2.1.2)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

include(GitRepoDownloadScheme)

# using cmake to build
include(CMakeScheme)

# a download target
add_download_target(URL https://github.com/gflags/gflags.git
		            TAG 74bcd20c0e5b904a67e37abf0c1262824ff9030c
					)

ExternalProject_Get_Property("${PROJECT_NAME}_download" SOURCE_DIR)

set(CMAKE_DEBUG_POSTFIX "d")
# add build targets
add_build_targets(CMAKE_ARGS -DGFLAGS_BUILD_gflags_nothreads_LIB=OFF)
                    
