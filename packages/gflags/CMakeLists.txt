cmake_minimum_required(VERSION 3.0)

project(gflags VERSION 2.1.2)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

option(BUILD_${PROJECT_NAME_UPPER} "Build ${PROJECT_NAME}" OFF)
option(${PROJECT_NAME_UPPER}_BUILD_SHARED_LIBS "Build shared libraries for ${PROJECT_NAME}" ${BUILD_SHARED_LIBS})
set(${PROJECT_NAME_UPPER}_CMAKE_ARGS -DGFLAGS_BUILD_gflags_nothreads_LIB=OFF)

if(BUILD_${PROJECT_NAME_UPPER})

    include(ExternalProject)
	ExternalProject_Add(
		${PROJECT_NAME}_download
		GIT_REPOSITORY  https://github.com/gflags/gflags.git
		GIT_TAG 74bcd20c0e5b904a67e37abf0c1262824ff9030c
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
					${${PROJECT_NAME_UPPER}_CMAKE_ARGS}
			BUILD_COMMAND ${CMAKE_COMMAND} --build . --target install --config ${_config}
		)
		list(APPEND ${PROJECT_NAME}_targets ${PROJECT_NAME}_${_config_lower})
	endforeach()

	add_custom_target(${PROJECT_NAME})
	add_dependencies(${PROJECT_NAME} ${${PROJECT_NAME}_targets})

endif()