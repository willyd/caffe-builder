cmake_minimum_required(VERSION 3.0)

project(protobuf VERSION 3.0.0)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

include(GitRepoDownloadScheme)

# using cmake to build
include(CMakeScheme)

# a download target
add_download_target(URL https://github.com/google/protobuf.git
		            TAG 89719f07a35bee3c20e746944773587ac2a47444			
					)

ExternalProject_Get_Property("${PROJECT_NAME}_download" SOURCE_DIR)
set(SOURCE_DIR ${SOURCE_DIR}/cmake)

# add build targets
add_build_targets(CMAKE_ARGS -DCMAKE_DEBUG_POSTFIX=d
				  -Dprotobuf_BUILD_TESTS=OFF
				  -Dprotobuf_MSVC_STATIC_RUNTIME=OFF
				  # make sure we use static libs (using shared libs is not recommended)
				  -DBUILD_SHARED_LIBS=OFF
				  )
				  
# make sure we keep the Release protobuf				  
if(TARGET ${PROJECT_NAME}_Release AND TARGET ${PROJECT_NAME}_Debug)
	add_dependencies(${PROJECT_NAME}_Release ${PROJECT_NAME}_Debug)
endif()                    
