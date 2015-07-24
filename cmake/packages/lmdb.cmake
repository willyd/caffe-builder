include(buildem_status)
include(buildem_download_package)
include(buildem_cmake_recipe)

buildem_download_package(GIT_REPOSITORY "https://github.com/willyd/lmdb.git"
                         GIT_TAG cmake
						 SOURCE_DIR lmdb_SOURCE_DIR)

set(lmdb_CMAKE_ARGS 
	-DBUILD_SHARED_LIBS=OFF
	-DCMAKE_DEBUG_POSTFIX=d
	)

buildem_cmake_recipe(NAME lmdb  
					 SOURCE_DIR ${lmdb_SOURCE_DIR}/libraries/liblmdb
				     CMAKE_ARGS ${lmdb_CMAKE_ARGS}
					)