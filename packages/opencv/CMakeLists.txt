cmake_minimum_required(VERSION 3.0)

project(opencv VERSION 3.1.0)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

option(BUILD_${PROJECT_NAME_UPPER} "Build ${PROJECT_NAME}" ${CB_BUILD_ALL})
option(${PROJECT_NAME_UPPER}_BUILD_SHARED_LIBS "Build shared libraries for ${PROJECT_NAME}" ${BUILD_SHARED_LIBS})
option(${PROJECT_NAME_UPPER}_WITH_CUDA "Build ${PROJECT_NAME} with CUDA" OFF)
option(${PROJECT_NAME_UPPER}_CLONE_FFMPEG "Clone ffmpeg windows dependency instead of downloading it" OFF)
option(${PROJECT_NAME_UPPER}_WITH_PYTHON "Build ${PROJECT_NAME} with python support" OFF)

set(${PROJECT_NAME_UPPER}_CMAKE_ARGS
    -DBUILD_DOCS=OFF
    -DBUILD_PERF_TESTS=OFF
    -DBUILD_PACKAGE=OFF
    -DBUILD_WITH_STATIC_CRT=OFF
    -DWITH_CUDA:BOOL=${${PROJECT_NAME_UPPER}_WITH_CUDA}
    -DCUDA_ARCH_BIN="3.0 3.5 3.7 5.0 5.2"
    -DCUDA_ARCH_PTX="3.0"
    -DBUILD_ZLIB=OFF
    -DBUILD_opencv_python2:BOOL=${${PROJECT_NAME_UPPER}_WITH_PYTHON}
    -DBUILD_opencv_python3:BOOL=${${PROJECT_NAME_UPPER}_WITH_PYTHON}
    -DZLIB_INCLUDE_DIR=${ZLIB_INCLUDE_DIR}
    -DZLIB_LIBRARY_RELEASE=${ZLIB_LIBRARY_RELEASE}
    -DZLIB_LIBRARY_DEBUG=${ZLIB_LIBRARY_DEBUG}
    )

set(${PROJECT_NAME_UPPER}_DEPENDS zlib)

if(CMAKE_CL_64)
    set(OpenCV_ARCH x64)
    set(OpenCV_TBB_ARCH intel64)
elseif((CMAKE_GENERATOR MATCHES "ARM") OR ("${arch_hint}" STREQUAL "ARM") OR (CMAKE_VS_EFFECTIVE_PLATFORMS MATCHES "ARM|arm"))
# see Modules/CmakeGenericSystem.cmake
    set(OpenCV_ARCH ARM)
else()
    set(OpenCV_ARCH x86)
    set(OpenCV_TBB_ARCH ia32)
endif()

if(MSVC_VERSION EQUAL 1400)
    set(OpenCV_RUNTIME vc8)
elseif(MSVC_VERSION EQUAL 1500)
    set(OpenCV_RUNTIME vc9)
elseif(MSVC_VERSION EQUAL 1600)
    set(OpenCV_RUNTIME vc10)
elseif(MSVC_VERSION EQUAL 1700)
    set(OpenCV_RUNTIME vc11)
elseif(MSVC_VERSION EQUAL 1800)
    set(OpenCV_RUNTIME vc12)
elseif(MSVC_VERSION EQUAL 1900)
    set(OpenCV_RUNTIME vc14)
endif()

if(${PROJECT_NAME_UPPER}_BUILD_SHARED_LIBS)
    set(OpenCV_STATIC OFF)
    set(OpenCV_LIB_PREFIX lib)
else()
    set(OpenCV_STATIC ON)
    set(OpenCV_LIB_PREFIX staticlib)
endif()



if(BUILD_${PROJECT_NAME_UPPER})

    set(${PROJECT_NAME_UPPER}_CONFIG
"
# ${PROJECT_NAME_UPPER} config
set(${PROJECT_NAME_UPPER}_DIR \${CMAKE_CURRENT_LIST_DIR}  CACHE PATH \"\")
set(${PROJECT_NAME}_DIR \${CMAKE_CURRENT_LIST_DIR}  CACHE PATH \"\")
set(OpenCV_DIR \${CMAKE_CURRENT_LIST_DIR}  CACHE PATH \"\")
set(OpenCV_STATIC ${OpenCV_STATIC} CACHE BOOL \"\")
"
    PARENT_SCOPE)

    include(ExternalProject)
    set(_ext_proj_ffmpeg )
    if(${PROJECT_NAME_UPPER}_CLONE_FFMPEG)
        # workaround to get ffmpeg under firewall restrictions
        set(_ext_proj_ffmpeg ${PROJECT_NAME}_clone_ffmpeg)
        ExternalProject_Add(
            ${_ext_proj_ffmpeg}
            DOWNLOAD_COMMAND git clone https://github.com/opencv/opencv_3rdparty.git -c core.autocrlf=false
            UPDATE_COMMAND cd ${CB_DOWNLOAD_DIR}/opencv_3rdparty && git checkout ffmpeg/master_20150703
            DOWNLOAD_DIR ${CB_DOWNLOAD_DIR}
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ""
            INSTALL_COMMAND ""
        )
        ExternalProject_Get_Property("${_ext_proj_ffmpeg}" SOURCE_DIR)
        set(OPENCV_FFMPEG_URL file:///${CB_DOWNLOAD_DIR}/opencv_3rdparty/ffmpeg/)
        list(APPEND ${PROJECT_NAME_UPPER}_CMAKE_ARGS -DOPENCV_FFMPEG_URL=${OPENCV_FFMPEG_URL})
    endif()

    ExternalProject_Add(
        ${PROJECT_NAME}_download
        URL  "https://sourceforge.net/projects/opencvlibrary/files/opencv-unix/3.1.0/opencv-3.1.0.zip"
        DOWNLOAD_DIR ${CB_DOWNLOAD_DIR}
        PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different
                      "${CMAKE_CURRENT_SOURCE_DIR}/patches/CMakeListsPatch.txt"
                      "CMakeLists.txt"
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
            # make it depend on the clone of ffmpeg
            ${_ext_proj_ffmpeg}
            # make it depend on other configure projects
            # so we don't conflict in downloading ippcv and ffmpeg
            ${${PROJECT_NAME}_targets}
            ${${PROJECT_NAME_UPPER}_DEPENDS}
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
        if(PYTHON_EXECUTABLE)
            ExternalProject_Add_Step(${PROJECT_NAME}_${_config_lower} relocate
            COMMAND ${PYTHON_EXECUTABLE}
                    ${CMAKE_CURRENT_SOURCE_DIR}/../../replace_absolute_paths.py
                    ${CMAKE_INSTALL_PREFIX}/${OpenCV_ARCH}/${OpenCV_RUNTIME}/${OpenCV_LIB_PREFIX}/OpenCVModules-${_config_lower}.cmake
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

endif()
