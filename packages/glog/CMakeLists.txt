cmake_minimum_required(VERSION 3.0)

project(glog VERSION 0.3.4.1)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

include(GitRepoDownloadScheme)

# using cmake to build
include(CMakeScheme)

# a download target
# temporarily reference my own repo until PR https://github.com/google/glog/pull/98
# is integrated
 add_download_target(URL https://github.com/willyd/glog.git
 		            TAG relocatable
 					)

ExternalProject_Get_Property("${PROJECT_NAME}_download" SOURCE_DIR)

set(CMAKE_DEBUG_POSTFIX "d")
# add build targets
add_build_targets(CMAKE_ARGS -DWITH_GFLAGS=ON
				  DEPENDS gflags
				  )				 
                    
