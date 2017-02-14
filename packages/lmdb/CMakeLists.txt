cmake_minimum_required(VERSION 3.0)

project(lmdb VERSION 0.9.70)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

option(BUILD_${PROJECT_NAME_UPPER} "Build ${PROJECT_NAME}" ${CB_BUILD_ALL})
set(${PROJECT_NAME_UPPER}_BUILD_SHARED_LIBS OFF CACHE BOOL "Build shared libraries for ${PROJECT_NAME}")

if(BUILD_${PROJECT_NAME_UPPER})

	set(${PROJECT_NAME_UPPER}_CONFIG
"
# ${PROJECT_NAME_UPPER} config
set(${PROJECT_NAME_UPPER}_DIR \${CMAKE_CURRENT_LIST_DIR}/cmake CACHE PATH \"\")
set(${PROJECT_NAME}_DIR \${CMAKE_CURRENT_LIST_DIR}/cmake  CACHE PATH \"\")
"
    PARENT_SCOPE)

    set(PATCH ${CMAKE_CURRENT_SOURCE_DIR}/lmdb_45a88275d2a410e683bae4ef44881e0f55fa3c4d.patch)

    include(ExternalProject)
    ExternalProject_Add(
        ${PROJECT_NAME}_download
        URL "https://github.com/LMDB/lmdb/archive/LMDB_0.9.18.zip"
        URL_HASH SHA512=46d7ba226af05443c871f83c6ae0ab2ddbeecd289df59c082e806e135fcaa69d9d9060a19a4a907c4f7046de30871126e91e540eca27fc94446e95ba5616155b
        PATCH_COMMAND
        COMMAND ${GIT_EXECUTABLE} --work-tree=. --git-dir=.git apply "${PATCH}" --ignore-whitespace --whitespace=nowarn --verbose
        DOWNLOAD_DIR ${CB_DOWNLOAD_DIR}
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
    )
    list(APPEND ${PROJECT_NAME}_targets ${PROJECT_NAME}_download)

    ExternalProject_Get_Property("${PROJECT_NAME}_download" SOURCE_DIR)
    set(SOURCE_DIR ${SOURCE_DIR}/libraries/liblmdb)

    set(_src "${CMAKE_CURRENT_SOURCE_DIR}/cmake/*")
    set(_dst "${SOURCE_DIR}")
    ExternalProject_Add(
        ${PROJECT_NAME}_patch
        DEPENDS ${PROJECT_NAME}_download
        DOWNLOAD_COMMAND ""
        SOURCE_DIR ${SOURCE_DIR}
        PATCH_COMMAND
        COMMAND powershell -exec bypass -noprofile -command "copy -force -recurse ${_src} ${_dst}"
        DOWNLOAD_DIR ${CB_DOWNLOAD_DIR}
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
        BUILD_IN_SOURCE 1
    )
    list(APPEND ${PROJECT_NAME}_targets ${PROJECT_NAME}_patch)

    foreach(_config ${CB_BUILD_CONFIGURATION_TYPES})
        string(TOLOWER ${_config} _config_lower)
        ExternalProject_Add(
            ${PROJECT_NAME}_${_config_lower}
            DEPENDS ${PROJECT_NAME}_download ${PROJECT_NAME}_patch ${${PROJECT_NAME_UPPER}_DEPENDS}
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

