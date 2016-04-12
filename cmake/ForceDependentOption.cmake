cmake_policy(SET CMP0057 NEW)

macro(force_dependent_option opt1 opt2)
    if(${opt1} AND NOT ${opt2})
        message(WARNING "Forcing ${opt2} to ON because of ${opt1}")
        set(${opt2} ON CACHE BOOL "" FORCE)
    endif()
endmacro()

macro(add_package_dependency package_name dependency_name)
    string(TOUPPER ${package_name} _package_name_upper)
    string(TOUPPER ${dependency_name} _dependency_name_upper)
    
    list(APPEND _${_package_name_upper}_dependencies ${dependency_name})
    force_dependent_option(BUILD_${_package_name_upper} BUILD_${_dependency_name_upper})
endmacro()

function(mark_package_as_added package_name)
    string(TOUPPER ${package_name} _package_name_upper)
    set(_added_packages ${_added_packages} ${_package_name_upper} CACHE INTERNAL "" FORCE)
endfunction()

function(add_package package_name)
    # get the upper case name
    string(TOUPPER ${package_name} _package_name_upper)
    # check if we need to build this project or if it has been added already    
    if(BUILD_${_package_name_upper} AND NOT (${_package_name_upper} IN_LIST _added_packages))
        # check for any dependencies that have not yet been added
        foreach(_dep ${_${_package_name_upper}_dependencies})
            # add the dependency            
            add_package(${_dep})
        endforeach()
        message(STATUS "Adding package: ${package_name}")
        add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/packages/${package_name})
        mark_package_as_added(${package_name})        
    endif() 
endfunction()

macro(add_packages _packages)    
    # create an empty list of added packages
    set(_added_packages "" CACHE INTERNAL "List of added packages" FORCE)
    foreach(_package_name ${_packages})
        add_package(${_package_name})        
    endforeach()    
endmacro()