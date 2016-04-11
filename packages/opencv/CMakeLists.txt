cmake_minimum_required(VERSION 3.0)

project(opencv VERSION 3.1.0)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

include(ArchiveDownloadScheme)

# using cmake to build
include(CMakeScheme)

# a download target
add_download_target(URL "https://sourceforge.net/projects/opencvlibrary/files/opencv-unix/3.1.0/opencv-3.1.0.zip/download"
					)
										
ExternalProject_Get_Property("${PROJECT_NAME}_download" SOURCE_DIR)
set(SOURCE_DIR ${SOURCE_DIR})

ExternalProject_Add_Step(${PROJECT_NAME}_download custom_patch 
						 COMMAND ${CMAKE_COMMAND} -E copy_if_different 
						 "${CMAKE_CURRENT_SOURCE_DIR}/CMakeListsPatch.txt"
						 "${SOURCE_DIR}/CMakeLists.txt"
						 DEPENDEES download)

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/ffmpeg_version.cmake AND
   EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/opencv_ffmpeg.dll AND
   EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/opencv_ffmpeg_64.dll)
   set(OPENCV_FFMPEG_URL "file:///${CMAKE_CURRENT_SOURCE_DIR}/")
endif()

set(_cuda_components
cudaarithm       
cudabgsegm       
cudacodec        
cudafeatures2d   
cudafilters      
cudaimgproc      
cudalegacy       
cudaobjdetect    
cudaoptflow      
cudastereo       
cudawarping      
cudev 
)


set(_all_components
apps             
calib3d          
core             
${_cuda_components}
features2d       
flann            
highgui          
imgcodecs        
imgproc          
ml               
objdetect        
photo            
python2          
python3          
shape            
stitching        
superres         
ts               
video            
videoio          
videostab        
world
)

set(_default_components             
calib3d          
core             
${_cuda_components}            
features2d       
flann            
highgui          
imgcodecs        
imgproc          
ml               
objdetect        
photo                   
shape            
stitching        
superres         
video            
videoio          
videostab        
)

unset(_components_arg)
cmake_policy(SET CMP0057 NEW) 


if(${PROJECT_NAME_UPPER}_COMPONENTS)
	set(_components ${${PROJECT_NAME_UPPER}_COMPONENTS})
else()
	set(_components ${_default_components})
endif()

foreach(_comp ${_all_components})
	if(${_comp} IN_LIST _components)
		list(APPEND _components_arg "-DBUILD_opencv_${_comp}:BOOL=ON")
	else()
		list(APPEND _components_arg "-DBUILD_opencv_${_comp}:BOOL=OFF")
	endif()
endforeach()

# set WITH_CUDA appropriately if we have any cuda components
set(WITH_CUDA OFF)
foreach(_comp ${_cuda_components})
	if(${_comp} IN_LIST _components)
		set(WITH_CUDA ON)
		break()
	endif()
endforeach()


message(STATUS "Build ${PROJECT_NAME} components: ${_components}")

# add build targets
add_build_targets(CMAKE_ARGS
				  -DBUILD_DOCS=OFF
				  -DBUILD_PERF_TESTS=OFF
				  -DBUILD_PACKAGE=OFF
				  -DBUILD_WITH_STATIC_CRT=OFF
				  -DWITH_CUDA:BOOL=${WITH_CUDA}				
				  -DCUDA_ARCH_BIN="3.0 3.5 3.7 5.0 5.2"
				  -DCUDA_ARCH_PTX="3.0"
				  -DBUILD_ZLIB=OFF
				  -DOPENCV_FFMPEG_URL=${OPENCV_FFMPEG_URL}
				  -DCMAKE_DEBUG_POSTFIX=d
				  ${_components_arg}
				   DEPENDS ZLIB
				  )
				  
# let the first configure go first. Since it tries do download 
# files from the internet.				  
list(GET BUILD_CONFIGURATION_TYPES 0 _first_config)
foreach(_config ${BUILD_CONFIGURATION_TYPES})
	if(NOT ${_config} STREQUAL ${_first_config})
		add_dependencies(${PROJECT_NAME}_${_config} ${PROJECT_NAME}_${_first_config})
	endif()	
endforeach()

# set(_libdir staticlib)
# if(BUILD_SHARED_LIBS)
#   set(_libdir lib)
# endif()

# # patch opencv module files to remove the linker path to 
# # cuda 
# if(CMAKE_CL_64)
# set(OpenCV_ARCH x64)
# set(OpenCV_TBB_ARCH intel64)
# elseif((CMAKE_GENERATOR MATCHES "ARM") OR ("${arch_hint}" STREQUAL "ARM") OR (CMAKE_VS_EFFECTIVE_PLATFORMS MATCHES "ARM|arm"))
# # see Modules/CmakeGenericSystem.cmake
# set(OpenCV_ARCH ARM)
# else()
# set(OpenCV_ARCH x86)
# set(OpenCV_TBB_ARCH ia32)
# endif()
# if(MSVC_VERSION EQUAL 1400)
# set(OpenCV_RUNTIME vc8)
# elseif(MSVC_VERSION EQUAL 1500)
# set(OpenCV_RUNTIME vc9)
# elseif(MSVC_VERSION EQUAL 1600)
# set(OpenCV_RUNTIME vc10)
# elseif(MSVC_VERSION EQUAL 1700)
# set(OpenCV_RUNTIME vc11)
# elseif(MSVC_VERSION EQUAL 1800)
# set(OpenCV_RUNTIME vc12)
# elseif(MSVC_VERSION EQUAL 1900)
# set(OpenCV_RUNTIME vc14)
# endif()
	
# foreach(_config ${BUILD_CONFIGURATION_TYPES})
# 	string(TOLOWER ${_config} _config_lower)
# 	set(_file ${CMAKE_INSTALL_PREFIX}/opencv/${OpenCV_ARCH}/${OpenCV_RUNTIME}/${_libdir}/OpenCVModules-${_config_lower}.cmake)
# 	file(TO_NATIVE_PATH ${_file} _file)
# 	set(_cmd_file ${CMAKE_CURRENT_BINARY_DIR}/patch_module_file_${_config_lower}.cmd)
# 	configure_file(${CMAKE_CURRENT_SOURCE_DIR}/patch_module_file.cmd ${_cmd_file} @ONLY)
# 	add_custom_target(${PROJECT_NAME}_patch_module_file_${_config_lower} ALL
# 					  DEPENDS ${_cmd_file}
# 					  COMMAND cmd /c ${_cmd_file}
# 					  VERBATIM
# 					  USES_TERMINAL
# 					  COMMENT "Patching the OpenCVModules*.cmake files"
# 					  )
# 	add_dependencies(${PROJECT_NAME}_patch_module_file_${_config_lower} ${PROJECT_NAME}_${_config})
# 	add_dependencies(${PROJECT_NAME} ${PROJECT_NAME}_patch_module_file_${_config_lower})
# endforeach()				  
                    
