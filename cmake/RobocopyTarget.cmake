# add a robocopy target to copy files to 
macro(add_robocopy_target)
    set(options ALL)
    set(oneValueArgs 
    NAME
    SOURCE
    DESTINATION
	)
    set(multiValueArgs PATTERNS OPTIONS DEPENDS)
    cmake_parse_arguments(add_robocopy "${options}" "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN} )
                          
    if(NOT add_robocopy_SOURCE)
        message(FATAL_ERROR "Missing robocopy SOURCE")
    endif()
    
    if(NOT add_robocopy_DESTINATION)
        message(FATAL_ERROR "Missing robocopy DESTINATION")
    endif()
    
    if(NOT add_robocopy_NAME)
        message(FATAL_ERROR "Missing robocopy NAME")
    endif()
    
    if(NOT add_robocopy_PATTERNS)
        set(add_robocopy_PATTERNS *.*)
    endif()
        
    file(TO_NATIVE_PATH ${add_robocopy_SOURCE} _robocopy_source)
    file(TO_NATIVE_PATH ${add_robocopy_DESTINATION} _robocopy_destination)
    set(_robocopy_patterns ${add_robocopy_PATTERNS})
    set(_robocopy_options ${add_robocopy_OPTIONS})
    
    set(_input_file ${CMAKE_BINARY_DIR}/robocopy.cmd.in)
    if(NOT EXISTS ${_input_file})
        # create the input file if it does not exist
        unset(_file_content)
        set(_file_content "${_file_content}\@echo off\n")
        set(_file_content "${_file_content}robocopy \"\@_robocopy_source\@\" \"\@_robocopy_destination\@\" \@_robocopy_patterns\@ \@_robocopy_options\@\n")
        set(_file_content "${_file_content}if NOT ERRORLEVEL 5 (set ERRORLEVEL=0)\n")
        file(WRITE ${_input_file} ${_file_content})               
    endif()    
    set(_output_file ${CMAKE_CURRENT_BINARY_DIR}/${add_robocopy_NAME}_robocopy.cmd)
    configure_file(${_input_file} ${_output_file} @ONLY)
    
    set(_stamp_file  ${CMAKE_CURRENT_BINARY_DIR}/${add_robocopy_NAME}_robocopy.stamp)
    add_custom_command(OUTPUT ${_stamp_file}
                       DEPENDS ${_input_file} ${_output_file}
                       COMMAND cmd /c "${_output_file}"
                       COMMAND ${CMAKE_COMMAND} -E touch ${_stamp_file}
                       VERBATIM
                       USES_TERMINAL
                       COMMENT "Copying from ${add_robocopy_SOURCE} to ${add_robocopy_DESTINATION}"
    )
    
    unset(_add_robocopy)
    if(add_robocopy_ALL)
        message(STATUS "Adding target ${add_robocopy_NAME} to ALL")
        set(_add_robocopy ALL)
    endif()
    
    add_custom_target(${add_robocopy_NAME} ${_add_robocopy}
                      DEPENDS ${_stamp_file} ${_output_file}
                     )
    
    if(add_robocopy_DEPENDS)
        add_dependencies(${add_robocopy_NAME} ${add_robocopy_DEPENDS})
    endif()    
endmacro()