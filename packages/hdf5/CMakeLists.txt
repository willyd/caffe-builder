cmake_minimum_required(VERSION 3.0)

project(hdf5 VERSION 1.8.16)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

option(BUILD_${PROJECT_NAME_UPPER} "Build ${PROJECT_NAME}" ${CB_BUILD_ALL})
option(${PROJECT_NAME_UPPER}_BUILD_SHARED_LIBS "Build shared libraries for ${PROJECT_NAME}" ${BUILD_SHARED_LIBS})
set(${PROJECT_NAME_UPPER}_LIB_PREFIX "" CACHE STRING "Library to prefix the binaries with to avoid name conflicts on windows")

set(${PROJECT_NAME_UPPER}_CMAKE_ARGS
    -DHDF5_ENABLE_Z_LIB_SUPPORT=ON
    -DBUILD_TESTING=OFF
    -DHDF5_BUILD_EXAMPLES=OFF
    -DHDF5_BUILD_TOOLS=OFF
    -DHDF5_EXTERNAL_LIB_PREFIX=${${PROJECT_NAME_UPPER}_LIB_PREFIX}
    -DZLIB_INCLUDE_DIR=${ZLIB_INCLUDE_DIR}
    -DZLIB_LIBRARY_RELEASE=${ZLIB_LIBRARY_RELEASE}
    -DZLIB_LIBRARY_DEBUG=${ZLIB_LIBRARY_DEBUG}
    )
set(${PROJECT_NAME_UPPER}_DEPENDS zlib)

if(BUILD_${PROJECT_NAME_UPPER})

	set(${PROJECT_NAME_UPPER}_CONFIG
"
# ${PROJECT_NAME_UPPER} config
set(${PROJECT_NAME_UPPER}_DIR \${CMAKE_CURRENT_LIST_DIR}/cmake CACHE PATH \"\")
set(${PROJECT_NAME}_DIR \${CMAKE_CURRENT_LIST_DIR}/cmake CACHE PATH \"\")
set(HDF5_ROOT_DIR \${CMAKE_CURRENT_LIST_DIR}/cmake CACHE PATH \"\")
"
    PARENT_SCOPE)

    include(ExternalProject)
    ExternalProject_Add(
        ${PROJECT_NAME}_download
        URL https://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8.16/src/CMake-hdf5-1.8.16.zip
        DOWNLOAD_DIR ${CB_DOWNLOAD_DIR}
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
    )
    list(APPEND ${PROJECT_NAME}_targets ${PROJECT_NAME}_download)

    ExternalProject_Get_Property("${PROJECT_NAME}_download" SOURCE_DIR)
    set(SOURCE_DIR ${SOURCE_DIR}/hdf5-${PROJECT_VERSION})

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
                    #-DCMAKE_DEBUG_POSTFIX=d
                    ${${PROJECT_NAME_UPPER}_CMAKE_ARGS}
            BUILD_COMMAND ${CMAKE_COMMAND} --build . --target install --config ${_config}
            INSTALL_COMMAND ${CMAKE_COMMAND} --build . --target install --config ${_config}
        )
        if(PYTHON_EXECUTABLE)
            ExternalProject_Add_Step(${PROJECT_NAME}_${_config_lower} relocate
            COMMAND ${PYTHON_EXECUTABLE}
                    ${CMAKE_CURRENT_SOURCE_DIR}/../../replace_absolute_paths.py
                    ${CMAKE_INSTALL_PREFIX}/cmake/hdf5-targets.cmake
            DEPENDEES build install
            COMMENT "Running relocation script"
            )
            ExternalProject_Add_StepTargets(${PROJECT_NAME}_${_config_lower} relocate)
        endif()

        ExternalProject_Add_StepTargets(${PROJECT_NAME}_${_config_lower} build install)

        list(APPEND ${PROJECT_NAME}_targets ${PROJECT_NAME}_${_config_lower})
    endforeach()

    add_custom_target(${PROJECT_NAME})
    add_dependencies(${PROJECT_NAME} ${${PROJECT_NAME}_targets})

    # Consuming projects need to use hdf5-shared, etc as libraries to link to
endif()
