include(ExternalProject)
include(CMakeParseArguments)

macro(add_convenience_target)
    add_custom_target(${PROJECT_NAME})
    add_dependencies(${PROJECT_NAME} ${PROJECT_NAME}_download ${_defined_targets})
endmacro()

macro(add_build_targets )
    message(STATUS "Adding targets for: ${PROJECT_NAME}")
    set(options)
    set(oneValueArgs
	)
    set(multiValueArgs CMAKE_ARGS DEPENDS)
    cmake_parse_arguments(adt "${options}" "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN} )  
    
    set(_override_opts BUILD_SHARED_LIBS CMAKE_DEBUG_POSTFIX)    
    foreach(_opt ${_override_opts})
        set(_${_opt}_arg -D${_opt}=${${_opt}})
        foreach(_adt_opt ${adt_CMAKE_ARGS})
            if("${_adt_opt}" MATCHES "-D${_opt}=(.*)")
                unset(_${opt}_arg)
                message(STATUS "${PROJECT_NAME}: Overriding ${_opt} with ${_adt_opt}")                                          
            endif()
        endforeach()        
    endforeach()
    
    set(_defined_targets)  
    foreach(_config ${BUILD_CONFIGURATION_TYPES})    
        if(${CMAKE_GENERATOR} MATCHES "Ninja")
            set(_build_type -DCMAKE_BUILD_TYPE=${_config})
        endif()
        
        set(_target_name ${PROJECT_NAME}_${_config})
        # any dependencies on other libs                
        unset(_deps)
        foreach(_dep ${adt_DEPENDS})            
            list(APPEND _deps ${_dep}_${_config})
        endforeach()        
        
        ExternalProject_Add(${_target_name}
                            DEPENDS ${PROJECT_NAME}_download ${_deps}
                            DOWNLOAD_COMMAND ""
                            SOURCE_DIR ${SOURCE_DIR}
                            CMAKE_ARGS
                            -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}
                            ${_BUILD_SHARED_LIBS_arg}
                            ${_CMAKE_DEBUG_POSTFIX_arg}
                            ${_build_type}
                            ${adt_CMAKE_ARGS}
                            -C ${CMAKE_INSTALL_PREFIX}/InitialCache.cmake
                            )
                            
        ExternalProject_Add_StepTargets(${_target_name} install)                                    
        # add dependencies to avoid failing concurrent installs of the
        # files in the same location                            
        foreach(_target ${_defined_targets})
             ExternalProject_Add_StepDependencies(${_target_name} install ${_target})
        endforeach()
        list(APPEND _defined_targets ${_target_name})        
    endforeach()
    
    add_convenience_target()
    
     foreach(_opt ${_override_opts})
        set(${_opt} ${_${_opt}_bak})
        unset(_${_opt}_bak)
     endforeach()
endmacro()




