include(ExternalProject)
include(CMakeParseArguments)

macro(add_download_target)
    set(options BUILD_IN_SOURCE)
    set(oneValueArgs
	URL
	TAG
    CONFIGURE_COMMAND
	)
    set(multiValueArgs "")
    cmake_parse_arguments(adt "${options}" "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN} )
                          
    unset(_source_dir)
    unset(_source_dir_opt)
    if(DEFAULT_SOURCE_DIR)            
        set(_source_dir "${DEFAULT_SOURCE_DIR}/${PROJECT_NAME}")
        set(_source_dir_opt SOURCE_DIR "${_source_dir}")
    endif()
    
    if(EXISTS "${_source_dir}")
        message("Using previously downloaded sources")
        ExternalProject_Add(${PROJECT_NAME}_download                        
                        DOWNLOAD_COMMAND ""
                        ${_source_dir_opt}
                        CONFIGURE_COMMAND "${adt_CONFIGURE_COMMAND}"
                        BUILD_COMMAND ""
                        INSTALL_COMMAND ""
                        BUILD_IN_SOURCE ${adt_BUILD_IN_SOURCE}
        )    
    else()                                  
        ExternalProject_Add(${PROJECT_NAME}_download
                            GIT_REPOSITORY ${adt_URL}
                            GIT_TAG ${adt_TAG}
                            ${_source_dir_opt}
                            CONFIGURE_COMMAND "${adt_CONFIGURE_COMMAND}"
                            BUILD_COMMAND ""
                            INSTALL_COMMAND ""
                            BUILD_IN_SOURCE ${adt_BUILD_IN_SOURCE}
        )
    endif()
endmacro()