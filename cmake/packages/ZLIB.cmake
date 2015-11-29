include(buildem_status)
include(buildem_download_package)
include(buildem_cmake_recipe)

buildem_download_package(GIT_REPOSITORY "https://github.com/lltcggie/zlib.git"
                         GIT_TAG cmake #latest commit as of writing
						 SOURCE_DIR ZLIB_SOURCE_DIR)

set(ZLIB_CMAKE_ARGS 
	-DBUILD_WITH_STATIC_CRT=${USE_STATIC_RUNTIME_LINK}
	)

buildem_cmake_recipe(NAME ZLIB
					 SOURCE_DIR ${ZLIB_SOURCE_DIR}
					 CMAKE_ARGS ${ZLIB_CMAKE_ARGS}
					)