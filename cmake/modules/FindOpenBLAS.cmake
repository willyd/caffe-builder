message(STATUS "Using custom OpenBLAS module")
set(_openblas_root ${CMAKE_CURRENT_LIST_DIR}/../openblas)
find_file(OPENBLAS_HEADER cblas.h ${_openblas_root}/include)
find_file(OPENBLAS_IMPLIB libopenblas.dll.a ${_openblas_root}/lib)
if(OPENBLAS_HEADER AND OPENBLAS_IMPLIB)
    if(NOT TARGET OpenBLAS)
        add_library(OpenBLAS SHARED IMPORTED)
        set_target_properties(OpenBLAS PROPERTIES IMPORTED_LOCATION ${_openblas_root}/bin/libopenblas.dll
												  IMPORTED_LOCATION_RELEASE ${_openblas_root}/bin/libopenblas.dll
												  IMPORTED_LOCATION_DEBUG ${_openblas_root}/bin/libopenblas.dll
                                                  IMPORTED_IMPLIB ${OPENBLAS_IMPLIB}
												  IMPORTED_IMPLIB_RELEASE ${OPENBLAS_IMPLIB}
												  IMPORTED_IMPLIB_DEBUG ${OPENBLAS_IMPLIB}
                                                  INTERFACE_INCLUDE_DIRECTORIES ${_openblas_root}/include                                              
                              )
    endif()
	set(OPENBLAS_LIBRARIES OpenBLAS)
	set(${CMAKE_FIND_PACKAGE_NAME}_LIBRARIES OpenBLAS)
    set(OPENBLAS_LIB OpenBLAS)
	set(${CMAKE_FIND_PACKAGE_NAME}_LIB OpenBLAS)
	
	set(OPENBLAS_INCLUDE_DIR ${_openblas_root}/include)
	set(OPENBLAS_INCLUDE_DIRS ${OPENBLAS_INCLUDE_DIR})
	set(${CMAKE_FIND_PACKAGE_NAME}_INCLUDE_DIR ${OPENBLAS_INCLUDE_DIR})
	set(${CMAKE_FIND_PACKAGE_NAME}_INCLUDE_DIRS ${OPENBLAS_INCLUDE_DIR})
	
	set(OPENBLAS_FOUND TRUE)
	set(${CMAKE_FIND_PACKAGE_NAME}_FOUND TRUE)
	
else()
	set(OPENBLAS_FOUND FALSE)
	set(${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
endif()
