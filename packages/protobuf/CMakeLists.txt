cmake_minimum_required(VERSION 3.0)

project(protobuf VERSION 3.2.0)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

option(BUILD_${PROJECT_NAME_UPPER} "Build ${PROJECT_NAME}" ${CB_BUILD_ALL})
option(${PROJECT_NAME_UPPER}_BUILD_SHARED_LIBS "Build shared libraries for ${PROJECT_NAME}" ${BUILD_SHARED_LIBS})
option(${PROJECT_NAME_UPPER}_WITH_PYTHON "Build ${PROJECT_NAME} with python support" OFF)

if(${PROJECT_NAME_UPPER}_BUILD_SHARED_LIBS)
    message(WARNING "Building protobuf as a shared library is not recommended")
endif()

set(${PROJECT_NAME_UPPER}_CMAKE_ARGS
    # TODO check if protobuf will require the ZLIB imported target
    # Disable ZLIB as we are not sure we actually need it
    -Dprotobuf_WITH_ZLIB=OFF
    -Dprotobuf_MSVC_STATIC_RUNTIME=OFF
    -Dprotobuf_BUILD_TESTS=OFF
    -Dprotobuf_BUILD_SHARED_LIBS=${${PROJECT_NAME_UPPER}_BUILD_SHARED_LIBS}
    # -DZLIB_INCLUDE_DIR=${ZLIB_INCLUDE_DIR}
    # -DZLIB_LIBRARY_RELEASE=${ZLIB_LIBRARY_RELEASE}
    # -DZLIB_LIBRARY_DEBUG=${ZLIB_LIBRARY_DEBUG}
    )
set(${PROJECT_NAME_UPPER}_DEPENDS )

if(BUILD_${PROJECT_NAME_UPPER})

    set(${PROJECT_NAME_UPPER}_CONFIG
"
# ${PROJECT_NAME_UPPER} config
set(${PROJECT_NAME_UPPER}_DIR \${CMAKE_CURRENT_LIST_DIR}/cmake CACHE PATH \"\")
set(${PROJECT_NAME}_DIR \${CMAKE_CURRENT_LIST_DIR}/cmake CACHE PATH \"\")
set(Protobuf_DIR \${CMAKE_CURRENT_LIST_DIR}/cmake CACHE PATH \"\")
set(protobuf_MODULE_COMPATIBLE ON CACHE BOOL \"\")
"
    PARENT_SCOPE)

    include(ExternalProject)
    ExternalProject_Add(
        ${PROJECT_NAME}_download
        URL https://github.com/google/protobuf/archive/v3.2.0/protobuf-v3.2.0.tar.gz
        URL_MD5 61d899b8369781f6dd1e62370813392d
        DOWNLOAD_DIR ${CB_DOWNLOAD_DIR}
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
    )
    list(APPEND ${PROJECT_NAME}_targets ${PROJECT_NAME}_download)

    ExternalProject_Get_Property("${PROJECT_NAME}_download" SOURCE_DIR)
    set(SOURCE_DIR ${SOURCE_DIR}/cmake)

    foreach(_config ${CB_BUILD_CONFIGURATION_TYPES})
        string(TOLOWER ${_config} _config_lower)
        ExternalProject_Add(
            ${PROJECT_NAME}_${_config_lower}
            DEPENDS ${PROJECT_NAME}_download ${${PROJECT_NAME_UPPER}_DEPENDS}
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

    if(${PROJECT_NAME_UPPER}_WITH_PYTHON AND PYTHON_EXECUTABLE)
        ExternalProject_Get_Property("${PROJECT_NAME}_download" SOURCE_DIR)
        ExternalProject_Add(
        ${PROJECT_NAME}_python
        DEPENDS ${PROJECT_NAME}_download ${${PROJECT_NAME}_targets}
        SOURCE_DIR ${SOURCE_DIR}
        DOWNLOAD_COMMAND ""
        DOWNLOAD_DIR ${CB_DOWNLOAD_DIR}
        PATCH_COMMAND ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND cd python && ${PYTHON_EXECUTABLE} setup.py install --single-version-externally-managed --record record.txt
        BUILD_IN_SOURCE 1
        )
        list(APPEND ${PROJECT_NAME}_targets ${PROJECT_NAME}_python)
    endif()

    add_custom_target(${PROJECT_NAME})
    add_dependencies(${PROJECT_NAME} ${${PROJECT_NAME}_targets})
endif()
