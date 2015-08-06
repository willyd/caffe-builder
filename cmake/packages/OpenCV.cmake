include(buildem_status)
include(buildem_download_package)
include(buildem_cmake_recipe)

option(BUILD_OPENCV_3 "Build OpenCV 3.x instead of 2.4.x" ON)
if(BUILD_OPENCV_3)
    buildem_download_package(URL "http://downloads.sourceforge.net/project/opencvlibrary/opencv-unix/3.0.0/opencv-3.0.0.zip"
						     SOURCE_DIR OpenCV_SOURCE_DIR
                             )
else()
    buildem_download_package(URL "http://downloads.sourceforge.net/project/opencvlibrary/opencv-unix/2.4.11/opencv-2.4.11.zip"
						     SOURCE_DIR OpenCV_SOURCE_DIR
                             )
endif()


set(OpenCV_CMAKE_ARGS 
	-DBUILD_SHARED_LIBS=OFF
    -DBUILD_DOCS=OFF 
    -DBUILD_TESTS=OFF
    -DBUILD_PERF_TESTS=OFF
    -DBUILD_PACKAGE=OFF
    -DBUILD_WITH_STATIC_CRT=OFF
    -DBUILD_opencv_apps=OFF

    -DBUILD_opencv_python=OFF
    -DBUILD_opencv_python2=OFF
    -DBUILD_opencv_python3=OFF
    -DBUILD_opencv_ts=OFF
    -DBUILD_ZLIB=OFF
    # enable these if you want GPU support in OpenCV
    -DWITH_CUDA=OFF
    -DBUILD_opencv_gpu=OFF
    # change according to your GPU
    -DCUDA_ARCH_BIN=5.2
    -DCUDA_ARCH_PTX=""
    )
    
buildem_cmake_recipe(NAME OpenCV
                     DEPENDS ZLIB
					 SOURCE_DIR ${OpenCV_SOURCE_DIR}
                     CMAKE_ARGS ${OpenCV_CMAKE_ARGS}
                     )


					