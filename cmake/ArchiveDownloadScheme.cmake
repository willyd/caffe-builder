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
    if(NOT IS_DIRECTORY "${adt_URL}")
        ExternalProject_Add(${adt_NAME}					
                            URL ${adt_URL}
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
endmacro()