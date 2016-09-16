cmake_minimum_required(VERSION 3.0)

project(zlib VERSION 1.2.8)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

option(${PROJECT_NAME_UPPER}_BUILD_SHARED_LIBS "Build shared libraries for ${PROJECT_NAME}" ${BUILD_SHARED_LIBS})

set(${PROJECT_NAME_UPPER}_LIB_PREFIX "caffe-" CACHE STRING "Library to prefix the binaries with to avoid name conflicts on windows")

include(ExternalProject)

set(ZLIB_ROOT ${CB_MODULE_ROOT})

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/patches/FindZLIB.cmake ${CB_CMAKE_MODULE_PATH}/FindZLIB.cmake @ONLY)

message(WARNING "Add patch to allow specifying prefix")

ExternalProject_Add(
	${PROJECT_NAME}_download	 
	URL https://github.com/madler/zlib/archive/v1.2.8.tar.gz	
	URL_MD5 1eabf2698dc49f925ce0ffb81397098f
	DOWNLOAD_NAME ${PROJECT_NAME}-v1.2.8.tar.gz
	DOWNLOAD_DIR ${CB_DOWNLOAD_DIR}
	CONFIGURE_COMMAND ""
	BUILD_COMMAND ""
	INSTALL_COMMAND ""
)
list(APPEND ${PROJECT_NAME}_targets ${PROJECT_NAME}_download)

ExternalProject_Get_Property("${PROJECT_NAME}_download" SOURCE_DIR)

foreach(_config ${CB_BUILD_CONFIGURATION_TYPES})
	string(TOLOWER ${_config} _config_lower)
	ExternalProject_Add(
		${PROJECT_NAME}_${_config_lower}
		DEPENDS ${PROJECT_NAME}_download
		SOURCE_DIR ${SOURCE_DIR}
		DOWNLOAD_COMMAND ""
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${_config}
		           -DBUILD_SHARED_LIBS=${${PROJECT_NAME_UPPER}_BUILD_SHARED_LIBS}
				   -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
				   -DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}
				   -DCMAKE_MODULE_PATH=${CB_CMAKE_MODULE_PATH}
				   -DCMAKE_DEBUG_POSTFIX=d
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --target install --config ${_config}
	)
	list(APPEND ${PROJECT_NAME}_targets ${PROJECT_NAME}_${_config_lower})

	ExternalProject_Get_Property("${PROJECT_NAME}_${_config_lower}" BINARY_DIR)
	set(CPACK_INSTALL_CMAKE_PROJECTS "${CPACK_INSTALL_CMAKE_PROJECTS};${BINARY_DIR};${PROJECT_NAME}_${_config_lower};ALL;/")
endforeach()

add_custom_target(${PROJECT_NAME})
add_dependencies(${PROJECT_NAME} ${${PROJECT_NAME}_targets})
                    
set(CPACK_GENERATOR "TBZ2")

include(CPack)