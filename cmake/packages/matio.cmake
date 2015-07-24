include(buildem_status)
include(buildem_download_package)
include(buildem_cmake_recipe)

buildem_download_package(GIT_REPOSITORY "https://github.com/willyd/matio.git"
                         GIT_TAG master
						 SOURCE_DIR matio_SOURCE_DIR)

set(matio_CMAKE_ARGS 
	-DBUILD_SHARED_LIBS=OFF
	-DCMAKE_DEBUG_POSTFIX=d
	)

buildem_cmake_recipe(NAME matio
                    DEPENDS ZLIB HDF5
					 SOURCE_DIR ${matio_SOURCE_DIR}
				     CMAKE_ARGS ${matio_CMAKE_ARGS}
					)