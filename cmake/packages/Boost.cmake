include(buildem_status)
include(buildem_download_package)
include(buildem_boost_recipe)


 buildem_download_package(URL "http://downloads.sourceforge.net/project/boost/boost/1.58.0/boost_1_58_0.7z"
						  SOURCE_DIR Boost_SOURCE_DIR
                          )

# Remove docs and tests to make the source folder copy smaller and faster
file(GLOB Boost_DOC_FOLDERS ${Boost_SOURCE_DIR}/libs/*/doc)
file(GLOB Boost_TEST_FOLDERS ${Boost_SOURCE_DIR}/libs/*/test)

if(Boost_TEST_FOLDERS)
	message(STATUS "Removing tests")
	file(REMOVE_RECURSE ${Boost_TEST_FOLDERS})
endif()

if(Boost_DOC_FOLDERS)
	message(STATUS "Removing docs")
	file(REMOVE_RECURSE ${Boost_DOC_FOLDERS} ${Boost_SOURCE_DIR}/doc)
endif()
    
 buildem_boost_recipe(NAME Boost
					  SOURCE_DIR ${Boost_SOURCE_DIR}
                      COMPONENTS system thread filesystem date_time python regex
                      )


					