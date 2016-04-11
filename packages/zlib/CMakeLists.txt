cmake_minimum_required(VERSION 3.0)

project(ZLIB VERSION 1.2.8)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

include(GitRepoDownloadScheme)

# using cmake to build
include(CMakeScheme)

# a download target
add_download_target(URL https://github.com/madler/zlib.git
		            TAG v1.2.8					
					)

ExternalProject_Get_Property("${PROJECT_NAME}_download" SOURCE_DIR)

# add build targets
add_build_targets()
                    
