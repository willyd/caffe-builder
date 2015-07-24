include(CMakeParseArguments)
include(ExternalProject)
include(buildem_status)

macro(buildem_boost_recipe )
    set(options )	
    set(oneValueArgs NAME SOURCE_DIR)
	set(multiValueArgs DEPENDS COMPONENTS)
	
	cmake_parse_arguments(buildem_br_arg
						  "${options}" 
						  "${oneValueArgs}"
						  "${multiValueArgs}" 
						  ${ARGN} 
						)

	buildem_debug_arguments(buildem_boost_recipe 
							buildem_br_arg
							${options} ${oneValueArgs} ${multiValueArgs})
    
	set(_default_cmake_args -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH})
	set(_name ${buildem_br_arg_NAME})
	set(_source_dir ${buildem_br_arg_SOURCE_DIR})

	set(Boost_TOOLSET_MAP_1600 10.0)
	set(Boost_TOOLSET_MAP_1700 11.0)
	set(Boost_TOOLSET_MAP_1800 12.0)
	
	set(Boost_TOOLSET msvc-${Boost_TOOLSET_MAP_${MSVC_VERSION}})
	set(Boost_LINK static)
	
	if(CMAKE_CL_64)
		set(Boost_ADDRESS_MODEL 64)
	else()
		set(Boost_ADDRESS_MODEL 32)
	endif()
	
    set(_binary_dir ${CMAKE_CURRENT_BINARY_DIR}/Boost-prefix/src/Boost-build)
	file(TO_NATIVE_PATH ${CMAKE_INSTALL_PREFIX} _prefix)
	set(Boost_OPTS threading=multi variant=debug,release runtime-link=shared link=${Boost_LINK} toolset=${Boost_TOOLSET} address-model=${Boost_ADDRESS_MODEL} install --prefix=${_prefix} --build-dir=${_binary_dir})
	
	if(buildem_br_arg_COMPONENTS)
		foreach(_component ${buildem_br_arg_COMPONENTS})
			set(Boost_OPTS ${Boost_OPTS} --with-${_component})
		endforeach()
	endif()
	
    externalproject_add(${_name}
						#URL ${_source_dir}
                        SOURCE_DIR ${_source_dir}
						DEPENDS ${buildem_br_arg_DEPENDS}
						CONFIGURE_COMMAND bootstrap.bat
						BUILD_COMMAND b2 ${Boost_OPTS}
						BUILD_IN_SOURCE 1
						INSTALL_COMMAND ""
						)

	


    

endmacro()