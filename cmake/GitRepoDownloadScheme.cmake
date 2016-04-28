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
    
    unset(_use_already_downloaded_sources)
    if(EXISTS ${_source_dir})
        file(GLOB_RECURSE _source_dir_content LIST_DIRECTORIES FALSE ${_source_dir}/*.*)
        list(LENGTH _source_dir_content _n_files)
        if(_n_files GREATER 0)
            set(_use_already_downloaded_sources TRUE)
        endif()
    endif()
    
    if(_use_already_downloaded_sources)
        message(STATUS "Using already downloaded sources for: ${PROJECT_NAME}")
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