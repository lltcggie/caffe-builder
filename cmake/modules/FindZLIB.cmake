

message(STATUS "Using custom FindZLIB module")

find_package(zlib QUIET CONFIG)

if(NOT ZLIB_FOUND)
    set(ZLIB_ROOT "${CMAKE_INSTALL_PREFIX}")
    set(ZLIB_FOUND TRUE)
    set(ZLIB_INCLUDE_DIR "${ZLIB_ROOT}/include")
    set(ZLIB_LIBRARY_DEBUG "${ZLIB_ROOT}/lib/zlibstaticd.lib")
    set(ZLIB_LIBRARY_RELEASE "${ZLIB_ROOT}/lib/zlibstatic.lib")

    set(ZLIB_INCLUDE_DIRS ${ZLIB_INCLUDE_DIR})
    
    if(NOT TARGET ZLIB)
        add_library(ZLIB STATIC IMPORTED)
        set_target_properties(ZLIB PROPERTIES
                              IMPORTED_LOCATION_RELEASE "${ZLIB_LIBRARY_RELEASE}"
                              IMPORTED_LOCATION_DEBUG "${ZLIB_LIBRARY_DEBUG}"
                              INTERFACE_INCLUDE_DIRECTORIES "${ZLIB_INCLUDE_DIRS}")
    endif()

    set(ZLIB_LIBRARY ZLIB)
    set(ZLIB_LIBRARIES ZLIB)
else()
    if(NOT TARGET ZLIB)
        # Use only static library
        set(ZLIB_LIBRARIY zlibstatic)
        set(ZLIB_LIBRARIES zlibstatic)
    endif()
endif()
