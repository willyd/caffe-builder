include(CMakeParseArguments)
include(ExternalProject)
include(buildem_status)

macro(buildem_cmake_recipe )
    set(options )	
    set(oneValueArgs NAME SOURCE_DIR)
	set(multiValueArgs CMAKE_ARGS DEPENDS)
	
	cmake_parse_arguments(buildem_cr_arg
						  "${options}" 
						  "${oneValueArgs}"
						  "${multiValueArgs}" 
						  ${ARGN} 
						)

	buildem_debug_arguments(buildem_cmake_recipe 
							buildem_cr_arg
							${options} ${oneValueArgs} ${multiValueArgs})
    
    message("${CMAKE_MODULE_PATH}")
	set(_default_cmake_args -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX} -DCMAKE_MODULE_PATH:PATH=${CMAKE_MODULE_PATH})
	set(_name ${buildem_cr_arg_NAME})
	set(_source_dir ${buildem_cr_arg_SOURCE_DIR})
    externalproject_add(${_name}
						DEPENDS ${buildem_cr_arg_DEPENDS}
						SOURCE_DIR ${_source_dir}
                        CMAKE_CACHE_ARGS ${_default_cmake_args}
						CMAKE_ARGS ${buildem_cr_arg_CMAKE_ARGS}
						)

	
	externalproject_get_property(${_name} BINARY_DIR)
	if(MSVC)		
		externalproject_add_step(${_name} BuildOtherConfig
							COMMAND ${CMAKE_COMMAND} --build ${BINARY_DIR} --config "$<$<CONFIG:Debug>:Release>$<$<CONFIG:Release>:Debug>" --target INSTALL
							DEPENDEES install
							)
	endif()
    

endmacro()