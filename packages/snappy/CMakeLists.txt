cmake_minimum_required(VERSION 3.0)

project(snappy VERSION 1.1.1)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

option(BUILD_${PROJECT_NAME_UPPER} "Build ${PROJECT_NAME}" ${CB_BUILD_ALL})
set(${PROJECT_NAME_UPPER}_BUILD_SHARED_LIBS OFF CACHE BOOL "Build shared libraries for ${PROJECT_NAME}" FORCE)

set(${PROJECT_NAME_UPPER}_CMAKE_ARGS
    -DZLIB_INCLUDE_DIR=${ZLIB_INCLUDE_DIR}
    -DZLIB_LIBRARY_RELEASE=${ZLIB_LIBRARY_RELEASE}
    -DZLIB_LIBRARY_DEBUG=${ZLIB_LIBRARY_DEBUG}
    )
set(${PROJECT_NAME_UPPER}_DEPENDS zlib)

if(BUILD_${PROJECT_NAME_UPPER})

	set(${PROJECT_NAME_UPPER}_CONFIG
"
# ${PROJECT_NAME_UPPER} config
set(${PROJECT_NAME_UPPER}_DIR \${CMAKE_CURRENT_LIST_DIR}/cmake)
set(${PROJECT_NAME}_DIR \${CMAKE_CURRENT_LIST_DIR}/cmake)
"
    PARENT_SCOPE)

    include(ExternalProject)
    ExternalProject_Add(
        ${PROJECT_NAME}_download
        GIT_REPOSITORY https://github.com/willyd/snappy.git
        GIT_TAG 2305ec8411cea1215d63ba344dba484937bfb80e
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
            DEPENDS ${PROJECT_NAME}_download ${${PROJECT_NAME_UPPER}_DEPENDS}
              # make it depend on other configure projects
            # so we don't conflict in configure some file
            ${${PROJECT_NAME}_targets}
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
            INSTALL_COMMAND ${CMAKE_COMMAND} --build . --target install --config ${_config}
        )
        ExternalProject_Add_StepTargets(${PROJECT_NAME}_${_config_lower} build install)

        list(APPEND ${PROJECT_NAME}_targets ${PROJECT_NAME}_${_config_lower})
    endforeach()

    add_custom_target(${PROJECT_NAME})
    add_dependencies(${PROJECT_NAME} ${${PROJECT_NAME}_targets})

endif()
