include(CMakeParseArguments)

macro(buildem_download_package)
	set(options )	
    set(oneValueArgs URL DESTINATION GIT_REPOSITORY GIT_TAG SOURCE_DIR)
	set(multiValueArgs )

    cmake_parse_arguments(buildem_dp_arg
						  "${options}" 
						  "${oneValueArgs}"
						  "${multiValueArgs}" 
						  ${ARGN} 
						)

	buildem_debug_arguments(buildem_download_package 
							buildem_dp_arg
							${options} ${oneValueArgs} ${multiValueArgs})
	
	if(buildem_dp_arg_URL AND buildem_dp_arg_GIT_REPOSITORY)
		message(FATAL_ERROR "Conflicting options URL and GIT_REPOSITORY. Please specify only a URL or GIT_REPOSITORY.")							
	endif()
	
	# Determine package destination
	if(NOT buildem_dp_arg_DESTINATION)
		if(NOT BUILDEM_DOWNLOAD_CACHE)
			message(FATAL_ERROR "No DESTINATION for package download. Use DESTINATION argument or set BUILDEM_DOWNLOAD_CACHE")							
		else()	
			set(buildem_dp_arg_DESTINATION ${BUILDEM_DOWNLOAD_CACHE})
		endif()	
	endif()
	get_filename_component(buildem_dp_arg_DESTINATION ${buildem_dp_arg_DESTINATION} ABSOLUTE)
	if(NOT EXISTS ${buildem_dp_arg_DESTINATION})
		buildem_debug_status("Creating directory '${buildem_dp_arg_DESTINATION}'")
		execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${buildem_dp_arg_DESTINATION})
	endif()
	
	if(buildem_dp_arg_URL OR buildem_dp_arg_GIT_REPOSITORY)					
		# Download archive
		if(buildem_dp_arg_URL)	
			# create a unique id to reference the download
			string(SHA1 _url_hash "${buildem_dp_arg_URL}")
						
			if(IS_DIRECTORY ${buildem_dp_arg_URL})
				# local directory case
				set(${_url_hash} "${buildem_dp_arg_URL}" CACHE INTERNAL "")
				# set output variable for caller
				if(buildem_dp_arg_SOURCE_DIR)
					set(${buildem_dp_arg_SOURCE_DIR} "${buildem_dp_arg_URL}")
				endif()
			else()
				# local or remote archive case
				get_filename_component(_file_name ${buildem_dp_arg_URL} NAME)
									
				if(_file_name MATCHES "(\\.|=)(7z|tar\\.bz2|tar\\.gz|tar\\.xz|tbz2|tgz|txz|zip)$")
					string(REPLACE "." "\\." _regex_ext "${CMAKE_MATCH_0}")	
					string(REGEX MATCH "(.*)${_regex_ext}" _file_name_we ${_file_name})
					set(_file_name_we ${CMAKE_MATCH_1})				
				
					set(_tar_args xfz)
				endif()

				if(_file_name MATCHES "(\\.|=)tar$")
					string(REPLACE "." "\\." _regex_ext "${CMAKE_MATCH_0}")	
					string(REGEX MATCH "(.*)${_regex_ext}" _file_name_we ${_file_name})
					set(_file_name_we ${CMAKE_MATCH_1})				
				
					set(_tar_args xf)
				endif()		
				
				if(args STREQUAL "")
					message(FATAL_ERROR "error: do not know how to extract '${filename}' -- known types are .7z, .tar, .tar.bz2, .tar.gz, .tar.xz, .tbz2, .tgz, .txz and .zip")
					return()
				endif()
				
				if(EXISTS ${buildem_dp_arg_URL})
					#local archive case
					set(_file_dst ${buildem_dp_arg_URL})
				else()
					# remote archive case
					set(_file_dst ${buildem_dp_arg_DESTINATION}/${_file_name})
					buildem_download_archive(${buildem_dp_arg_URL} ${_file_dst})
				endif()
								
				buildem_unpack_archive(${_file_dst} ${buildem_dp_arg_DESTINATION} ${_tar_args} ${_file_name_we} _output_directory)
				
				# set output variable for caller
				if(buildem_dp_arg_SOURCE_DIR)
					set(${buildem_dp_arg_SOURCE_DIR} "${_output_directory}")
				endif()
			endif()					
			

		# clone git repo			
		else()		
            if(NOT GIT_FOUND)	
                find_package(Git)
                if(NOT GIT_FOUND)
                    message(FATAL_ERROR "Could not find Git please add a cache variable GIT_EXECUTABLE pointing to your git executable.")
                else()
                    buildem_debug_status("git found: ${GIT_EXECUTABLE}")
                endif()
            endif()

			# get the git repo name
			get_filename_component(_file_name_we ${buildem_dp_arg_GIT_REPOSITORY} NAME_WE)		
			
			if(NOT EXISTS ${buildem_dp_arg_DESTINATION}/${_file_name_we}/.git)
				# clone the repo
				execute_process(COMMAND ${GIT_EXECUTABLE} clone ${buildem_dp_arg_GIT_REPOSITORY} ${_file_name_we}
								WORKING_DIRECTORY "${buildem_dp_arg_DESTINATION}"
								RESULT_VARIABLE _result
								OUTPUT_VARIABLE _output
								ERROR_VARIABLE _error
								)
				if(NOT ${_result} EQUAL 0)
					message(FATAL_ERROR "Error cloning git repository ${_result}\n${_output}\n${_error}")
				endif()
			endif()
			
			# checkout the tag if any
			if(buildem_dp_arg_GIT_TAG)
				execute_process(COMMAND ${GIT_EXECUTABLE} checkout ${buildem_dp_arg_GIT_TAG}
								WORKING_DIRECTORY "${buildem_dp_arg_DESTINATION}/${_file_name_we}")
			endif()
			
			# set output variable for caller
			if(buildem_dp_arg_SOURCE_DIR)
				set(${buildem_dp_arg_SOURCE_DIR} "${buildem_dp_arg_DESTINATION}/${_file_name_we}")
			endif()
			
		endif()		
	else()
		message(FATAL_ERROR "Please specify a URL or GIT_REPOSITORY")		    
	endif()
endmacro()

macro(buildem_clone_git_repo)
endmacro()

macro(buildem_download_archive url destination )
	set(_file_dst ${destination})
	
	# generate a unique hash
	string(SHA1 _url_hash "${buildem_dp_arg_URL}")
        
	if(EXISTS "${${_url_hash}}")                
		# We already have downloaded the file so just skip download
		buildem_debug_status("File '${url}' already downloaded to '${${_url_hash}}'")
	else()
		# Download file
		buildem_debug_status("Downloading file '${url}' to '${_file_dst}'")
		file(DOWNLOAD ${url} ${_file_dst} 
				SHOW_PROGRESS 
				STATUS _file_download_status
				)
         
		# Get the download status
		list(GET _file_download_status 0 _file_download_success)
		if(NOT _file_download_success EQUAL 0)
			list(GET _file_download_status 1 _file_download_error)
			message(FATAL_ERROR "Failed to download file '${url}'. Error: ${_file_download_error}")
		else()
			# Create a cache variable so we know we don't need to re-download the package next time we come in here
			set(${_url_hash} "${_file_dst}" CACHE INTERNAL "")
		endif()
	endif()
endmacro()

macro(buildem_unpack_archive  archive destination tar_args archive_we output_directory)
	get_filename_component(archive ${archive} ABSOLUTE)
		
	# generate a unique hash
	string(SHA1 _archive_hash "${archive}")	
	if(EXISTS "${${_archive_hash}}")      
		# We already extracted the file so just skip unpack
		buildem_debug_status("File '${_file_dst}' already unpacked to '${${_archive_hash}}'")          
	else()
		# set unpack dir
		set(_unpack_dir ${destination}/${_archive_hash}) 
		if(NOT EXISTS ${_unpack_dir})
			buildem_debug_status("Creating directory '${_unpack_dir}'")
			execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${_unpack_dir})
		endif()
		buildem_debug_status("Unpacking file '${archive}'")
		execute_process(COMMAND ${CMAKE_COMMAND} -E tar ${tar_args} "${archive}"
						WORKING_DIRECTORY "${_unpack_dir}"
						OUTPUT_QUIET)
				
		# Analyze what came out of the tar file:
		#
		message(STATUS "extracting... [analysis]")
		file(GLOB contents "${_unpack_dir}/*")
		list(LENGTH contents n)
		if(NOT n EQUAL 1 OR NOT IS_DIRECTORY "${contents}")
			set(contents "${_unpack_dir}")
		endif()

		# Move \"the one\" directory to the final directory:
		#
		message(STATUS "extracting... [rename]")
		get_filename_component(contents ${contents} ABSOLUTE)
		file(RENAME ${contents} ${destination}/${archive_we})

		# Clean up:
		#
		message(STATUS "extracting... [clean up]")
		file(REMOVE_RECURSE "${_unpack_dir}")

		message(STATUS "extracting... done")
				
		set(${_archive_hash} "${destination}/${archive_we}" CACHE INTERNAL "")		
	endif()
	
	set(${output_directory} "${destination}/${archive_we}")
endmacro()