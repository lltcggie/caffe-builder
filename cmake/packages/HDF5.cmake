include(buildem_status)
include(buildem_download_package)
include(buildem_cmake_recipe)


buildem_download_package(URL  "https://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8.17/src/hdf5-1.8.17.zip"
                         SOURCE_DIR HDF5_SOURCE_DIR
                        )

file(COPY ${CMAKE_CURRENT_LIST_DIR}/copy_file/UserMacros.cmake
     DESTINATION ${HDF5_SOURCE_DIR})

set(HDF5_CMAKE_ARGS 
    -DBUILD_SHARED_LIBS=OFF
    -DHDF5_ENABLE_Z_LIB_SUPPORT=ON
    -DBUILD_TESTING=OFF
    -DHDF5_BUILD_EXAMPLES=OFF
    -DHDF5_BUILD_TOOLS=ON
    -DBUILD_USER_DEFINED_LIBS=ON
    -DBUILD_STATIC_CRT_LIBS=${USE_STATIC_RUNTIME_LINK}
    )
                  
 buildem_cmake_recipe(NAME HDF5
                      DEPENDS ZLIB
					  SOURCE_DIR ${HDF5_SOURCE_DIR}
                      CMAKE_ARGS ${HDF5_CMAKE_ARGS}
                      )


					