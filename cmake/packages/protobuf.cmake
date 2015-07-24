include(buildem_status)
include(buildem_download_package)
include(buildem_cmake_recipe)

buildem_download_package(GIT_REPOSITORY "https://github.com/willyd/protobuf.git"
                         GIT_TAG cmake
						 SOURCE_DIR protobuf_SOURCE_DIR)

set(protobuf_CMAKE_ARGS
    -DBUILD_SHARED_LIBS=OFF
    )
    
buildem_cmake_recipe(NAME protobuf
					 SOURCE_DIR ${protobuf_SOURCE_DIR}/vsprojects
                     CMAKE_ARGS ${protobuf_CMAKE_ARGS}
					)