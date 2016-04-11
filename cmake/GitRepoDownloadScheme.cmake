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
                                  
    ExternalProject_Add(${PROJECT_NAME}_download
                        GIT_REPOSITORY ${adt_URL}
                        GIT_TAG ${adt_TAG}
                        CONFIGURE_COMMAND "${adt_CONFIGURE_COMMAND}"
                        BUILD_COMMAND ""
                        INSTALL_COMMAND ""
                        BUILD_IN_SOURCE ${adt_BUILD_IN_SOURCE}
    )
endmacro()