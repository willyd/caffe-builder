include(buildem_status)
include(buildem_download_package)
include(buildem_cmake_recipe)

buildem_download_package(URL "http://downloads.sourceforge.net/project/opencvlibrary/opencv-unix/2.4.11/opencv-2.4.11.zip"
						 SOURCE_DIR OpenCV_SOURCE_DIR
                         )

set(OpenCV_CMAKE_ARGS 
	-DBUILD_SHARED_LIBS=OFF
    -DBUILD_DOCS=OFF 
    -DBUILD_TESTS=OFF
    -DBUILD_PERF_TESTS=OFF
    -DBUILD_PACKAGE=OFF
    -DBUILD_WITH_STATIC_CRT=OFF
    -DBUILD_opencv_apps=OFF
    -DBUILD_opencv_gpu=OFF
    -DBUILD_opencv_python=OFF
    -DBUILD_opencv_ts=OFF
    -DBUILD_ZLIB=OFF
    -DWITH_CUDA=OFF
    )
    
buildem_cmake_recipe(NAME OpenCV
                     DEPENDS ZLIB
					 SOURCE_DIR ${OpenCV_SOURCE_DIR}
                     CMAKE_ARGS ${OpenCV_CMAKE_ARGS}
                     )


					