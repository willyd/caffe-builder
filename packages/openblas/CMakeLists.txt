cmake_minimum_required(VERSION 3.0)

project(openblas VERSION 0.2.14)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

include(ArchiveDownloadScheme)
include(RobocopyTarget)
   					   
if(CMAKE_SIZEOF_VOID_P STREQUAL "8")
	# 64 bit
	set(_openblas_url http://downloads.sourceforge.net/project/openblas/v0.2.14/OpenBLAS-v0.2.14-Win64-int32.zip)
	set(_mingw_url http://downloads.sourceforge.net/project/openblas/v0.2.14/mingw64_dll.zip)
	set(_mingw_locations ${CMAKE_CURRENT_SOURCE_DIR}/mingw64_dll.zip)
	foreach(_loc ${_mingw_locations})
		if(EXISTS ${_loc})
			set(_mingw_url ${_loc})
		endif()
	endforeach()
else()
 	# 32 bit
	set(_openblas_url http://downloads.sourceforge.net/project/openblas/v0.2.14/OpenBLAS-v0.2.14-Win32.zip)
	set(_mingw_url http://downloads.sourceforge.net/project/openblas/v0.2.14/mingw32_dll.zip)
endif()

# a download target
add_download_target(URL ${_openblas_url}
					)
					
add_download_target(NAME ${PROJECT_NAME}_download_mingw
					URL ${_mingw_url}
					)				

# install openblas								
ExternalProject_Get_Property("${PROJECT_NAME}_download" SOURCE_DIR)
add_robocopy_target(NAME install_openblas
					SOURCE ${SOURCE_DIR}
					DESTINATION ${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}
					PATTERNS *.*
					OPTIONS /S
					DEPENDS ${PROJECT_NAME}_download
					ALL)									


# install mingw								
ExternalProject_Get_Property("${PROJECT_NAME}_download_mingw" SOURCE_DIR)
add_robocopy_target(NAME install_openblas_mingw
					SOURCE ${SOURCE_DIR}
					DESTINATION ${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}/bin
					PATTERNS *.dll
					OPTIONS /S
					DEPENDS ${PROJECT_NAME}_download_mingw install_openblas
					ALL)	


# add convenience target
add_custom_target(${PROJECT_NAME})
add_dependencies(${PROJECT_NAME} install_openblas install_openblas_mingw) 			 
