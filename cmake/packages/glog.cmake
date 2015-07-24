include(buildem_status)
include(buildem_download_package)
include(buildem_cmake_recipe)

buildem_download_package(GIT_REPOSITORY "https://github.com/willyd/glog.git"
                         GIT_TAG cmake #latest commit as of writing
						 SOURCE_DIR glog_SOURCE_DIR)

set(glog_CMAKE_ARGS 
	-DBUILD_SHARED_LIBS=OFF
	-DCMAKE_DEBUG_POSTFIX=d
	)

buildem_cmake_recipe(NAME glog 
					 DEPENDS gflags
					 SOURCE_DIR ${glog_SOURCE_DIR}
				     CMAKE_ARGS ${glog_CMAKE_ARGS}
					)