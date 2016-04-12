include(ExternalProject)
include(CMakeParseArguments)
include(ProcessorCount)
include(RobocopyTarget)

set(MSVC_VERSION_MAP_1600 msvc-10.0)
set(MSVC_VERSION_MAP_1700 msvc-11.0)
set(MSVC_VERSION_MAP_1800 msvc-12.0)
set(MSVC_VERSION_MAP_1900 msvc-14.0)

set(MSVC_CONFIGURATION_MAP_Debug debug)
set(MSVC_CONFIGURATION_MAP_Release release)

macro(add_convenience_target)
    add_custom_target(${PROJECT_NAME})
    add_dependencies(${PROJECT_NAME} ${PROJECT_NAME}_download ${_defined_targets} ${PROJECT_NAME}_install_include)
endmacro()

macro(add_build_targets )
    set(options)
    set(oneValueArgs
	)
    set(multiValueArgs DEPENDS)
    cmake_parse_arguments(adt "${options}" "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN} )
                          
                                  
    if(CMAKE_SIZEOF_VOID_P STREQUAL "8")
        set(_address_model_value "64")
        set(_address_model "address-model=64")               
    else()
        set(_address_model_value "32")
        set(_address_model "address-model=32")
    endif()
    
    unset(_user_config)
    if(PYTHON27_PREFIX)
        set(ADDRESS_MODEL ${_address_model_value})
        message("Configuring file: ${SOURCE_DIR}/user-config.jam")
        configure_file(${CMAKE_SOURCE_DIR}/cmake/user-config.jam.in ${SOURCE_DIR}/user-config.jam @ONLY)
    endif()
    
    if(BUILD_SHARED_LIBS)
        set(_link "link=shared")
    else()
        set(_link "link=static")
    endif()
    
    unset(_components)
    if(${PROJECT_NAME_UPPER}_COMPONENTS)
        foreach(_comp ${${PROJECT_NAME_UPPER}_COMPONENTS})
            list(APPEND _components --with-${_comp})
        endforeach()        
    endif()
    if(_components)
        message(STATUS "Build ${PROJECT_NAME} components: ${${PROJECT_NAME_UPPER}_COMPONENTS}")
    endif()
                                  
    set(_toolset "toolset=${MSVC_VERSION_MAP_${MSVC_VERSION}}")
    ProcessorCount(_n_cpus)
    message(STATUS "CPU count: ${_n_cpus}")                                  
    set(_defined_targets)  
    foreach(_config ${BUILD_CONFIGURATION_TYPES})
        set(_target_name ${PROJECT_NAME}_${_config})
        set(_variant "variant=${MSVC_CONFIGURATION_MAP_${_config}}")       
        set(_build_dir ${CMAKE_CURRENT_BINARY_DIR}/${_target_name}-prefix/src/${_target_name}-build)
        file(TO_NATIVE_PATH ${_build_dir} _build_dir)
        set(_stagedir ${CMAKE_INSTALL_PREFIX}/boost)
        file(TO_NATIVE_PATH ${_stagedir} _stagedir)
        set(_build_command b2 -j${_n_cpus} runtime-link=shared threading=multi ${_address_model} ${_link} ${_toolset} ${_variant} ${_components} --build-dir=${_build_dir} --stagedir=${_stagedir} stage)
        # set(_build_command b2 runtime-link=shared threading=multi ${_address_model} ${_link} ${_toolset} ${_variant} --build-dir=${_build_dir} --prefix=${_stagedir} install)
        
        ExternalProject_Add(${_target_name}
                            DEPENDS ${PROJECT_NAME}_download
                            DOWNLOAD_COMMAND ""
                            CONFIGURE_COMMAND ""
                            BUILD_COMMAND ${_build_command}
                            INSTALL_COMMAND ""
                            SOURCE_DIR ${SOURCE_DIR}
                            BUILD_IN_SOURCE 1
                            )                   
        # any dependencies on other libs
        foreach(_dep ${adt_DEPENDS})
            add_dependencies(${_target_name} ${_dep}_${_config})
        endforeach()
        # add dependencies to avoid failing concurrent installs of the
        # files in the same location                            
        # foreach(_target ${_defined_targets})
        #      ExternalProject_Add_StepDependencies(${_target_name} install ${_target})
        # endforeach()
        list(APPEND _defined_targets ${_target_name})        
    endforeach()
    
    # use robocopy to install boost headers
    add_robocopy_target(NAME ${PROJECT_NAME}_install_include
                        SOURCE ${SOURCE_DIR}/${PROJECT_NAME}
                        DESTINATION ${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}/include/${PROJECT_NAME}-${PROJECT_VERSION_MAJOR}_${PROJECT_VERSION_MINOR}/${PROJECT_NAME}
                        PATTERNS *.*
                        OPTIONS /S
                        DEPENDS ${_defined_targets}
                        ALL
                        )
       
    add_convenience_target()
endmacro()