cmake_minimum_required(VERSION 3.0)

project(gtest VERSION 1.8.0)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

option(BUILD_${PROJECT_NAME_UPPER} "Build ${PROJECT_NAME}" OFF)
set(${PROJECT_NAME_UPPER}_BUILD_SHARED_LIBS OFF CACHE BOOL "Build shared libraries for ${PROJECT_NAME}"  FORCE)
set(${PROJECT_NAME_UPPER}_CMAKE_ARGS -DBUILD_GTEST:BOOL=ON -DBUILD_GMOCK:BOOL=OFF -Dgtest_force_shared_crt:BOOL=ON)
if(BUILD_${PROJECT_NAME_UPPER})

set(GTEST_INCLUDE_DIR ${CMAKE_INSTALL_PREFIX}/include PARENT_SCOPE)

set(GTEST_LIBRARY_RELEASE ${CMAKE_INSTALL_PREFIX}/lib/gtest.lib PARENT_SCOPE)
set(GTEST_LIBRARY_DEBUG ${CMAKE_INSTALL_PREFIX}/lib/gtestd.lib PARENT_SCOPE)
set(GTEST_MAIN_LIBRARY_RELEASE ${CMAKE_INSTALL_PREFIX}/lib/gtest_main.lib PARENT_SCOPE)
set(GTEST_MAIN_LIBRARY_DEBUG ${CMAKE_INSTALL_PREFIX}/lib/gtest_maind.lib PARENT_SCOPE)

set(GTEST_LIBRARY ${GTEST_LIBRARY_RELEASE} PARENT_SCOPE)
set(GTEST_MAIN_LIBRARY ${GTEST_MAIN_LIBRARY_RELEASE} PARENT_SCOPE)

#     # TODO handle the case where we don't have release and debug
#     set(ZLIB_INCLUDE_DIR ${CMAKE_INSTALL_PREFIX}/include PARENT_SCOPE)
#     if(${PROJECT_NAME_UPPER}_BUILD_SHARED_LIBS)
#       set(ZLIB_LIBRARY_RELEASE ${CMAKE_INSTALL_PREFIX}/lib/${${PROJECT_NAME_UPPER}_LIB_PREFIX}zlib.lib)
#       set(ZLIB_LIBRARY_DEBUG   ${CMAKE_INSTALL_PREFIX}/lib/${${PROJECT_NAME_UPPER}_LIB_PREFIX}zlibd.lib)
#     else()
#       set(ZLIB_LIBRARY_RELEASE ${CMAKE_INSTALL_PREFIX}/lib/${${PROJECT_NAME_UPPER}_LIB_PREFIX}zlibstatic.lib)
#       set(ZLIB_LIBRARY_DEBUG ${CMAKE_INSTALL_PREFIX}/lib/${${PROJECT_NAME_UPPER}_LIB_PREFIX}zlibstaticd.lib)
#     endif()
#     set(ZLIB_LIBRARY_DEBUG ${ZLIB_LIBRARY_DEBUG} PARENT_SCOPE)
#     set(ZLIB_LIBRARY_RELEASE ${ZLIB_LIBRARY_RELEASE} PARENT_SCOPE)

#     get_filename_component(_dgb_lib ${ZLIB_LIBRARY_DEBUG} NAME)
#     get_filename_component(_rel_lib ${ZLIB_LIBRARY_RELEASE} NAME)
    set(${PROJECT_NAME_UPPER}_CONFIG
"
# gtest config
set(GTEST_INCLUDE_DIR \${CMAKE_CURRENT_LIST_DIR}/include CACHE PATH \"\")
set(GTEST_LIBRARY_RELEASE  \${CMAKE_CURRENT_LIST_DIR}/lib/gtest.lib CACHE FILEPATH \"\")
set(GTEST_LIBRARY_DEBUG  \${CMAKE_CURRENT_LIST_DIR}/lib/gtestd.lib CACHE FILEPATH \"\")
set(GTEST_MAIN_LIBRARY_RELEASE  \${CMAKE_CURRENT_LIST_DIR}/lib/gtest_main.lib CACHE FILEPATH \"\")
set(GTEST_MAIN_LIBRARY_DEBUG  \${CMAKE_CURRENT_LIST_DIR}/lib/gtest_maind.lib CACHE FILEPATH \"\")
set(GTEST_LIBRARY  \${GTEST_LIBRARY_RELEASE} CACHE FILEPATH \"\")
set(GTEST_MAIN_LIBRARY  \${GTEST_MAIN_LIBRARY_RELEASE} CACHE FILEPATH \"\")
"
    PARENT_SCOPE)

    include(ExternalProject)

    ExternalProject_Add(
        ${PROJECT_NAME}_download
        URL https://github.com/google/googletest/archive/release-1.8.0.tar.gz
        URL_MD5 16877098823401d1bf2ed7891d7dce36
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
            # prevent mutliple configs from building at the same time
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
            BUILD_COMMAND ${CMAKE_COMMAND} --build . --target all --config ${_config}
            INSTALL_COMMAND ${CMAKE_COMMAND} --build . --target install --config ${_config}
        )
        list(APPEND ${PROJECT_NAME}_targets ${PROJECT_NAME}_${_config_lower})
    endforeach()

    add_custom_target(${PROJECT_NAME})
    add_dependencies(${PROJECT_NAME} ${${PROJECT_NAME}_targets})

endif()