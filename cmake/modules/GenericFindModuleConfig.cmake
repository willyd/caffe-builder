message(STATUS "Using custom Find${CMAKE_FIND_PACKAGE_NAME} module")

# determine the arguments passed to find_package
set(cmake_fd_quiet_arg)
if(${CMAKE_FIND_PACKAGE_NAME}_FIND_QUIETLY)
  set(cmake_fd_quiet_arg QUIET)
endif()

set(cmake_fd_required_arg)
if(${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED)
  set(cmake_fd_required_arg REQUIRED)
endif()

set(cmake_fd_exact_arg)
if(${CMAKE_FIND_PACKAGE_NAME}_FIND_VERSION_EXACT)
  set(cmake_fd_exact_arg EXACT)
endif()

set(cmake_fd_version)
if(${CMAKE_FIND_PACKAGE_NAME}_FIND_VERSION)
  set(cmake_fd_version ${${CMAKE_FIND_PACKAGE_NAME}_FIND_VERSION})
endif()

set(cmake_fd_components)
if(${CMAKE_FIND_PACKAGE_NAME}_COMPONENTS)
	message(STATUS ${${CMAKE_FIND_PACKAGE_NAME}_COMPONENTS})
	set(cmake_fd_components COMPONENTS ${${CMAKE_FIND_PACKAGE_NAME}_COMPONENTS})
endif()

# TODO handle OPTIONAL_COMPONENTS 

# find using the module command
find_package(${CMAKE_FIND_PACKAGE_NAME} ${cmake_fd_version}
	${cmake_fd_exact_arg}
	${cmake_fd_quiet_arg}
	${cmake_fd_required_arg}
	${cmake_fd_components}
	CONFIG NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
)

# needs to be after find package in case on package-config.cmake calls 
# find_package again. Example glog calls find_package gflags.
string(TOUPPER "${CMAKE_FIND_PACKAGE_NAME}" PACKAGE_NAME_UPPER)
string(TOLOWER "${CMAKE_FIND_PACKAGE_NAME}" PACKAGE_NAME_LOWER)

if(${CMAKE_FIND_PACKAGE_NAME}_FOUND)
    # CMake will set ${CMAKE_FIND_PACKAGE_NAME}_FOUND to TRUE if the package is found.
    # However the package config is responsible for setting the variables with proper 
    # case. Here we handle some inconsistencies from packagers.
    set(_names ${CMAKE_FIND_PACKAGE_NAME} ${PACKAGE_NAME_UPPER} ${PACKAGE_NAME_LOWER})
    set(_vars FOUND INCLUDE_DIR INCLUDE_DIRS LIBRARIES VERSION)
    foreach(_var ${_vars})
      # for each var find the first name that has a valid entry
      foreach(_name ${_names})
        if(${_name}_${_var})
          # the current _name defines _var
          # set the other _name's _var accordingly
          foreach(_other_name ${_names})
            if(NOT "${_other_name}" STREQUAL "${_name}")
              set(${_other_name}_${_var} ${${_name}_${_var}})
            endif()
          endforeach()
          # exit this loop. and go to next _var
          break()
        endif()
      endforeach()
    endforeach()
    
    # no handle the case where the package defines INCLUDE_DIR but not INCLUDE_DIRS
    # or vice versa
    foreach(_name ${_names})
      if(${_name}_INCLUDE_DIR AND NOT ${_name}_INCLUDE_DIRS)
        set(${_name}_INCLUDE_DIRS ${${_name}_INCLUDE_DIR})
      endif()
      if(${_name}_INCLUDE_DIRS AND NOT ${_name}_INCLUDE_DIR)
        set(${_name}_INCLUDE_DIR ${${_name}_INCLUDE_DIRS})
      endif()
    endforeach()    
    
    # Log the value of each _name, _var for debugging purposes    
    # foreach(_var ${_vars})      
      # # for each var find the first name that has a valid entry
      # foreach(_name ${_names})
        # message("${_name}_${_var} = ${${_name}_${_var}}")
      # endforeach()
    # endforeach()
endif()
