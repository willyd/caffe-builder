include(buildem_status)
include(buildem_download_package)

# download binaries. OpenBLAS needs MinGW to be compiled.
buildem_download_package(URL "http://downloads.sourceforge.net/project/openblas/v0.2.14/OpenBLAS-v0.2.14-Win64-int32.zip"
						 SOURCE_DIR OpenBLAS_SOURCE_DIR)

buildem_download_package(URL "http://downloads.sourceforge.net/project/openblas/v0.2.14/mingw64_dll.zip"
						 SOURCE_DIR OpenBLAS_MINGW64_SOURCE_DIR)

file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/OpenBLASInstall.cmake" 
"
file(GLOB MINGW64_SHARED_LIBS \"${OpenBLAS_MINGW64_SOURCE_DIR}/*.dll\")
file(GLOB OpenBLAS_SHARED_LIBS \"${OpenBLAS_SOURCE_DIR}/bin/*.dll\")
file(GLOB OpenBLAS_IMPORT_LIBS \"${OpenBLAS_SOURCE_DIR}/lib/*.dll.a\")
file(GLOB OpenBLAS_HEADERS \"${OpenBLAS_SOURCE_DIR}/include/*.h\")
file(GLOB OpenBLAS_CMAKE_FILES \"${OpenBLAS_SOURCE_DIR}/lib/cmake/openblas/*.*\")

file(INSTALL \${MINGW64_SHARED_LIBS} \${OpenBLAS_SHARED_LIBS} DESTINATION \"${CMAKE_INSTALL_PREFIX}/bin\")
file(INSTALL \${OpenBLAS_IMPORT_LIBS} DESTINATION \"${CMAKE_INSTALL_PREFIX}/lib\")
file(INSTALL \${OpenBLAS_HEADERS} DESTINATION \"${CMAKE_INSTALL_PREFIX}/include\")
file(INSTALL \${OpenBLAS_CMAKE_FILES} DESTINATION \"${CMAKE_INSTALL_PREFIX}/lib/cmake/openblas\")
#######################################################################################
"
)

add_custom_command( OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/OpenBLASStamp
					COMMAND ${CMAKE_COMMAND} -E touch ${CMAKE_CURRENT_BINARY_DIR}/OpenBLASStamp
					COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/OpenBLASInstall.cmake
				  )

add_custom_target( OpenBLAS SOURCES ${CMAKE_CURRENT_BINARY_DIR}/OpenBLASStamp ${CMAKE_CURRENT_BINARY_DIR}/OpenBLASInstall.cmake)