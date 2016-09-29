cmake_minimum_required(VERSION 3.0)

project(leveldb VERSION 1.1.18)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

option(BUILD_${PROJECT_NAME_UPPER} "Build ${PROJECT_NAME}" OFF)
# level db cannot be built as a shared library on Windows
set(${PROJECT_NAME_UPPER}_BUILD_SHARED_LIBS OFF CACHE BOOL "Build shared libraries for ${PROJECT_NAME}" FORCE)

set(${PROJECT_NAME_UPPER}_CMAKE_ARGS
    -DBOOST_ROOT:PATH=${BOOST_ROOT}
	-DBOOST_INCLUDEDIR:PATH=${BOOST_INCLUDEDIR}
	-DBOOST_LIBRARYDIR:PATH=${BOOST_LIBRARYDIR}
	-DBoost_USE_MULTITHREADED:BOOL=${Boost_USE_MULTITHREADED}
    -DBoost_USE_STATIC_LIBS:BOOL=${Boost_USE_STATIC_LIBS}
    -DBoost_USE_STATIC_RUNTIME:BOOL=${Boost_USE_STATIC_RUNTIME}
    )

# this version does not depend on snappy
set(${PROJECT_NAME_UPPER}_DEPENDS boost)

if(BUILD_${PROJECT_NAME_UPPER})

    include(ExternalProject)
    ExternalProject_Add(
        ${PROJECT_NAME}_download
        GIT_REPOSITORY  "https://github.com/willyd/leveldb.git"
		GIT_TAG 340813b7dc2e09794168fa089ceb321f4e3560a4
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
        ExternalProject_Add_Step(${PROJECT_NAME}_${_config_lower} relocate
        COMMAND ${PYTHON_EXECUTABLE}
                ${CMAKE_CURRENT_SOURCE_DIR}/../../replace_absolute_paths.py
                ${CMAKE_INSTALL_PREFIX}/cmake/leveldb-targets-${_config_lower}.cmake
        DEPENDEES build install
        COMMENT "Running relocation script"
        )

        ExternalProject_Add_StepTargets(${PROJECT_NAME}_${_config_lower} build install relocate)

        list(APPEND ${PROJECT_NAME}_targets ${PROJECT_NAME}_${_config_lower})
    endforeach()

    add_custom_target(${PROJECT_NAME})
    add_dependencies(${PROJECT_NAME} ${${PROJECT_NAME}_targets})
endif()

