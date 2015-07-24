include(buildem_status)
include(buildem_download_package)
include(buildem_cmake_recipe)

buildem_download_package(GIT_REPOSITORY "https://github.com/gflags/gflags.git"
                         GIT_TAG f0523f14a93cbb46fff9b318508aa1c6923158c7 #latest commit as of writing
						 SOURCE_DIR gflags_SOURCE_DIR)

set(gflags_CMAKE_ARGS 
	-DBUILD_SHARED_LIBS=OFF
	-DCMAKE_DEBUG_POSTFIX=d
	)

buildem_cmake_recipe(NAME gflags  
					 SOURCE_DIR ${gflags_SOURCE_DIR}
				     CMAKE_ARGS ${gflags_CMAKE_ARGS}
					)