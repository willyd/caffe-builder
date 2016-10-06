cmake_minimum_required(VERSION 3.0)

project(boost VERSION 1.61.0)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

option(BUILD_${PROJECT_NAME_UPPER} "Build ${PROJECT_NAME}" ${CB_BUILD_ALL})
option(${PROJECT_NAME_UPPER}_BUILD_SHARED_LIBS "Build shared libraries for ${PROJECT_NAME}" ${BUILD_SHARED_LIBS})


set(${PROJECT_NAME_UPPER}_DEPENDS zlib)

if(BUILD_${PROJECT_NAME_UPPER})

    set(BOOST_ROOT ${CMAKE_INSTALL_PREFIX})
    set(BOOST_INCLUDEDIR ${CMAKE_INSTALL_PREFIX}/include/boost-${PROJECT_VERSION_MAJOR}_${PROJECT_VERSION_MINOR})
    set(BOOST_LIBRARYDIR ${CMAKE_INSTALL_PREFIX}/lib)
    set(Boost_USE_MULTITHREADED ON)
    if(${PROJECT_NAME_UPPER}_BUILD_SHARED_LIBS)
        set(Boost_USE_STATIC_LIBS OFF)
    else()
        set(Boost_USE_STATIC_LIBS ON)
    endif()
    set(Boost_USE_STATIC_RUNTIME OFF)

    set(BOOST_ROOT ${BOOST_ROOT} PARENT_SCOPE)
    set(BOOST_INCLUDEDIR ${BOOST_INCLUDEDIR} PARENT_SCOPE)
    set(BOOST_LIBRARYDIR ${BOOST_LIBRARYDIR} PARENT_SCOPE)
    set(Boost_USE_MULTITHREADED ${Boost_USE_MULTITHREADED} PARENT_SCOPE)
    set(Boost_USE_STATIC_LIBS ${Boost_USE_STATIC_LIBS} PARENT_SCOPE)
    set(Boost_USE_STATIC_RUNTIME ${Boost_USE_STATIC_RUNTIME} PARENT_SCOPE)

    set(${PROJECT_NAME_UPPER}_CONFIG
"
# ${PROJECT_NAME_UPPER} config
set(BOOST_ROOT \${CMAKE_CURRENT_LIST_DIR} CACHE PATH \"\")
set(BOOST_INCLUDEDIR \${BOOST_ROOT}/include/boost-${PROJECT_VERSION_MAJOR}_${PROJECT_VERSION_MINOR} CACHE PATH \"\")
set(BOOST_LIBRARYDIR \${BOOST_ROOT}/lib CACHE PATH \"\")
set(Boost_USE_MULTITHREADED ${Boost_USE_MULTITHREADED} CACHE BOOL \"\")
set(Boost_USE_STATIC_LIBS ${Boost_USE_STATIC_LIBS} CACHE BOOL \"\")
set(Boost_USE_STATIC_RUNTIME ${Boost_USE_STATIC_RUNTIME} CACHE BOOL \"\")
"
    PARENT_SCOPE)

    include(ExternalProject)
    ExternalProject_Add(
        ${PROJECT_NAME}_download
        URL https://sourceforge.net/projects/boost/files/boost/1.61.0/boost_1_61_0.7z
        DOWNLOAD_DIR ${CB_DOWNLOAD_DIR}
        CONFIGURE_COMMAND cmd /c bootstrap.bat
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
        BUILD_IN_SOURCE 1
    )
    list(APPEND ${PROJECT_NAME}_targets ${PROJECT_NAME}_download)

    ExternalProject_Get_Property("${PROJECT_NAME}_download" SOURCE_DIR)
    #set(SOURCE_DIR ${SOURCE_DIR}/hdf5-${PROJECT_VERSION})

    if(PYTHON_EXECUTABLE)

    endif()

    if(CMAKE_SIZEOF_VOID_P STREQUAL "8")
        set(_address_model_value "64")
        set(_address_model "address-model=64")
    else()
        set(_address_model_value "32")
        set(_address_model "address-model=32")
    endif()

    if(${PROJECT_NAME_UPPER}_BUILD_SHARED_LIBS)
        set(_link "link=shared")
    else()
        set(_link "link=static")
    endif()

    set(MSVC_VERSION_MAP_1600 msvc-10.0)
    set(MSVC_VERSION_MAP_1700 msvc-11.0)
    set(MSVC_VERSION_MAP_1800 msvc-12.0)
    set(MSVC_VERSION_MAP_1900 msvc-14.0)

    set(_toolset "toolset=${MSVC_VERSION_MAP_${MSVC_VERSION}}")

    foreach(_config ${CB_BUILD_CONFIGURATION_TYPES})
        string(TOLOWER ${_config} _config_lower)
        string(TOUPPER ${_config} _config_upper)
        set(_variant "variant=${_config_lower}")
        set(_target_name ${PROJECT_NAME}_${_config_lower})
        set(_build_dir ${CMAKE_CURRENT_BINARY_DIR}/${_target_name}-prefix/src/${_target_name}-build)
        file(TO_NATIVE_PATH ${_build_dir} _build_dir)
        set(_stagedir ${CMAKE_INSTALL_PREFIX})
        file(TO_NATIVE_PATH ${_stagedir} _stagedir)
        get_filename_component(_zlib_name ${ZLIB_LIBRARY_${_config_upper}} NAME_WE)
        get_filename_component(_zlib_path ${ZLIB_LIBRARY_${_config_upper}} DIRECTORY)
        set(_build_command b2
                           -j${NUMBER_OF_PROCESSORS}
                           runtime-link=shared
                           threading=multi
                           ${_address_model}
                           ${_link}
                           ${_toolset}
                           ${_variant}
                           ${_components}
                           ${_user_config}
                           --build-dir=${_build_dir}
                           --prefix=${_stagedir}
                           -s ZLIB_BINARY=${_zlib_name}
                           -s ZLIB_INCLUDE=${ZLIB_INCLUDE_DIR}
                           -s ZLIB_LIBPATH=${_zlib_path}
                           install
        )

        ExternalProject_Add(
            ${_target_name}
            DEPENDS ${PROJECT_NAME}_download ${${PROJECT_NAME_UPPER}_DEPENDS} ${${PROJECT_NAME}_targets}
            SOURCE_DIR ${SOURCE_DIR}
            DOWNLOAD_COMMAND ""
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ${_build_command}
            INSTALL_COMMAND ""
            BUILD_IN_SOURCE 1
        )

        list(APPEND ${PROJECT_NAME}_targets ${PROJECT_NAME}_${_config_lower})
    endforeach()

    add_custom_target(${PROJECT_NAME})
    add_dependencies(${PROJECT_NAME} ${${PROJECT_NAME}_targets} ) #${${PROJECT_NAME}_install_include})
    # Consuming projects need to use hdf5-shared, etc as libraries to link to
endif()
