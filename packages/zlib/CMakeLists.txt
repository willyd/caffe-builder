cmake_minimum_required(VERSION 3.0)

project(zlib VERSION 1.2.8)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

option(BUILD_${PROJECT_NAME_UPPER} "Build ${PROJECT_NAME}" ${CB_BUILD_ALL})
option(${PROJECT_NAME_UPPER}_BUILD_SHARED_LIBS "Build shared libraries for ${PROJECT_NAME}" ${BUILD_SHARED_LIBS})
set(${PROJECT_NAME_UPPER}_LIB_PREFIX "" CACHE STRING "Library to prefix the binaries with to avoid name conflicts on windows")

if(BUILD_${PROJECT_NAME_UPPER})

    # TODO handle the case where we don't have release and debug
    set(ZLIB_INCLUDE_DIR ${CMAKE_INSTALL_PREFIX}/include PARENT_SCOPE)
    if(${PROJECT_NAME_UPPER}_BUILD_SHARED_LIBS)
      set(ZLIB_LIBRARY_RELEASE ${CMAKE_INSTALL_PREFIX}/lib/${${PROJECT_NAME_UPPER}_LIB_PREFIX}zlib.lib)
      set(ZLIB_LIBRARY_DEBUG   ${CMAKE_INSTALL_PREFIX}/lib/${${PROJECT_NAME_UPPER}_LIB_PREFIX}zlibd.lib)
    else()
      set(ZLIB_LIBRARY_RELEASE ${CMAKE_INSTALL_PREFIX}/lib/${${PROJECT_NAME_UPPER}_LIB_PREFIX}zlibstatic.lib)
      set(ZLIB_LIBRARY_DEBUG ${CMAKE_INSTALL_PREFIX}/lib/${${PROJECT_NAME_UPPER}_LIB_PREFIX}zlibstaticd.lib)
    endif()
    set(ZLIB_LIBRARY_DEBUG ${ZLIB_LIBRARY_DEBUG} PARENT_SCOPE)
    set(ZLIB_LIBRARY_RELEASE ${ZLIB_LIBRARY_RELEASE} PARENT_SCOPE)

    get_filename_component(_dgb_lib ${ZLIB_LIBRARY_DEBUG} NAME)
    get_filename_component(_rel_lib ${ZLIB_LIBRARY_RELEASE} NAME)
    set(${PROJECT_NAME_UPPER}_CONFIG
"
# ZLIB config
set(ZLIB_INCLUDE_DIR \${CMAKE_CURRENT_LIST_DIR}/include CACHE PATH \"\")
set(ZLIB_LIBRARY_DEBUG  \${CMAKE_CURRENT_LIST_DIR}/lib/${_dgb_lib} CACHE FILEPATH \"\")
set(ZLIB_LIBRARY_RELEASE  \${CMAKE_CURRENT_LIST_DIR}/lib/${_rel_lib} CACHE FILEPATH \"\")
"
    PARENT_SCOPE)

    include(ExternalProject)

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
    endforeach()

    add_custom_target(${PROJECT_NAME})
    add_dependencies(${PROJECT_NAME} ${${PROJECT_NAME}_targets})

endif()