include(buildem_status)
include(buildem_download_package)
include(buildem_cmake_recipe)

buildem_download_package(GIT_REPOSITORY "https://github.com/willyd/caffe.git"
                         GIT_TAG visualstudio
						             SOURCE_DIR Caffe_SOURCE_DIR)

set(Caffe_CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=OFF
    -DBoost_USE_STATIC_LIBS=ON
    -DBoost_USE_MULTITHREAD=ON
    -DBoost_USE_STATIC_RUNTIME=OFF
    -DOpenCV_STATIC:BOOL=ON
    -DBLAS:STRING=Open
	  -DPROTOBUF_SRC_ROOT_FOLDER:PATH=${CMAKE_INSTALL_PREFIX}
	  -DOpenCV_DIR:PATH=${CMAKE_INSTALL_PREFIX}
    )              
           
buildem_cmake_recipe(NAME Caffe
                     DEPENDS gflags glog Boost OpenCV HDF5 lmdb leveldb snappy OpenBLAS protobuf
					 SOURCE_DIR ${Caffe_SOURCE_DIR}
					 CMAKE_ARGS ${Caffe_CMAKE_ARGS}
					)