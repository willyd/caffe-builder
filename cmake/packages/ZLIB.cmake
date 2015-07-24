include(buildem_status)
include(buildem_download_package)
include(buildem_cmake_recipe)

buildem_download_package(URL "http://zlib.net/zlib-1.2.8.tar.gz"
						 SOURCE_DIR ZLIB_SOURCE_DIR)

buildem_cmake_recipe(NAME ZLIB
					 SOURCE_DIR ${ZLIB_SOURCE_DIR}
					)