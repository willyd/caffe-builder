cmake_minimum_required(VERSION 3.0)

project(cudnn VERSION 4.0.0)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

include(ArchiveDownloadScheme)
include(RobocopyTarget)
   					   
if(CMAKE_SIZEOF_VOID_P STREQUAL "8")
	# a download target
	file(GLOB _cudnn_archives "${CMAKE_CURRENT_SOURCE_DIR}/cudnn-7.[0-5]*x64*.zip")
	if(_cudnn_archives)
		# use the first element in list for now
		list(GET _cudnn_archives 0 _cudnn_url)
		add_download_target(URL ${_cudnn_url})
		
		# install openblas								
		ExternalProject_Get_Property("${PROJECT_NAME}_download" SOURCE_DIR)
		add_robocopy_target(NAME ${PROJECT_NAME}_install
					SOURCE ${SOURCE_DIR}
					DESTINATION ${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}
					PATTERNS *.*
					OPTIONS /S
					DEPENDS ${PROJECT_NAME}_download
					ALL)
		# add convenience target
		add_custom_target(${PROJECT_NAME})
		add_dependencies(${PROJECT_NAME} ${PROJECT_NAME}_install)
	else()
		message(WARNING "Could not find any cudnn archive in ${CMAKE_CURRENT_SOURCE_DIR}")
	endif()				
else()
	message(WARNING "CuDNN cannot is not supported in 32 bit") 	
endif()


