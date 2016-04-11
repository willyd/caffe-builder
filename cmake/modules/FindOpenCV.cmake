if(@BUILD_SHARED_LIBS@)
  set(OpenCV_STATIC OFF)
else()
  set(OpenCV_STATIC ON)
endif()
if(OpenCV_STATIC)
    # if we built OpenCV as static libs
    # we need to resolve the ZLIB imported target
    include(CMakeFindDependencyMacro)
    find_dependency(ZLIB)
endif()
include(${CMAKE_CURRENT_LIST_DIR}/GenericFindModuleConfig.cmake)
