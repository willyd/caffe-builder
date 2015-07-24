option(BUILDEM_STATUS_DEBUG "Print debug information" ON)

file(GLOB _buildem_scripts ${CMAKE_CURRENT_LIST_DIR}/*buildem*.cmake)
source_group("Scripts" FILES ${_buildem_scripts})

file(GLOB _buildem_modules ${CMAKE_CURRENT_LIST_DIR}/modules/*.cmake)
source_group("Modules" FILES ${_buildem_modules})

file(GLOB _buildem_packages ${CMAKE_CURRENT_LIST_DIR}/packages/*.cmake)
source_group("Packages" FILES ${_buildem_packages})

add_custom_target(BuildEm                  
                  SOURCES ${_buildem_scripts} ${_buildem_modules} ${_buildem_packages})