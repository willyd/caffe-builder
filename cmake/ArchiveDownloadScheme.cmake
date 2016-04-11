include(ExternalProject)
include(CMakeParseArguments)

macro(add_download_target)
    set(options BUILD_IN_SOURCE)
    set(oneValueArgs
	URL
	CONFIGURE_COMMAND
    PATCH_COMMAND
    NAME 
	)
    set(multiValueArgs "")
    cmake_parse_arguments(adt "${options}" "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN} )
    if(NOT adt_NAME)
        set(adt_NAME ${PROJECT_NAME}_download)
    endif()
    
    unset(_source_dir)
    unset(_source_dir_opt)
    if(DEFAULT_SOURCE_DIR)            
        set(_source_dir "${DEFAULT_SOURCE_DIR}/${PROJECT_NAME}")
        set(_source_dir_opt SOURCE_DIR "${_source_dir}")
    endif()
    
    if(EXISTS ${_source_dir})
        ExternalProject_Add(${adt_NAME}
                        ${_source_dir_opt}					
                        DOWNLOAD_COMMAND ""
                        CONFIGURE_COMMAND "${adt_CONFIGURE_COMMAND}"
                        PATCH_COMMAND "${adt_PATCH_COMMAND}"
                        BUILD_COMMAND ""
                        INSTALL_COMMAND ""
                        BUILD_IN_SOURCE ${adt_BUILD_IN_SOURCE}
        )                     
    else()           
        if(NOT IS_DIRECTORY "${adt_URL}") 
            ExternalProject_Add(${adt_NAME}					
                                URL ${adt_URL}
                                ${_source_dir_opt}
                                CONFIGURE_COMMAND "${adt_CONFIGURE_COMMAND}"
                                PATCH_COMMAND "${adt_PATCH_COMMAND}"
                                BUILD_COMMAND ""
                                INSTALL_COMMAND ""
                                BUILD_IN_SOURCE ${adt_BUILD_IN_SOURCE}            
            )
        else()
            ExternalProject_Add(${adt_NAME}
                                    SOURCE_DIR ${adt_URL}					
                                    DOWNLOAD_COMMAND ""
                                    CONFIGURE_COMMAND "${adt_CONFIGURE_COMMAND}"
                                    PATCH_COMMAND "${adt_PATCH_COMMAND}"
                                    BUILD_COMMAND ""
                                    INSTALL_COMMAND ""
                                    BUILD_IN_SOURCE ${adt_BUILD_IN_SOURCE}            
            )
        endif()
    endif()
endmacro()