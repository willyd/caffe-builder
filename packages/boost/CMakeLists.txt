cmake_minimum_required(VERSION 3.0)

project(boost VERSION 1.60.0)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

include(ArchiveDownloadScheme)
# using b2 to build
include(BjamScheme)

# small workaround to avoid redownloading/extracting the sources
set(LOCATIONS "${CMAKE_CURRENT_SOURCE_DIR}/boost_1_60_0"
			  "${CMAKE_CURRENT_SOURCE_DIR}/boost_1_60_0.7z"
			  "http://downloads.sourceforge.net/project/boost/boost/1.60.0/boost_1_60_0.7z"
)
foreach(_loc ${LOCATIONS})
	if(EXISTS "${_loc}")
		set(PROJECT_URL "${_loc}")	
		break()
	endif()	
endforeach()

if(NOT PROJECT_URL)
	set(PROJECT_URL "${_loc}")
endif()

# a download target
 add_download_target(URL ${PROJECT_URL}
 		             CONFIGURE_COMMAND bootstrap.bat
					 BUILD_IN_SOURCE
 					)

ExternalProject_Get_Property("${PROJECT_NAME}_download" SOURCE_DIR)

# add build targets
add_build_targets()				 
                    
