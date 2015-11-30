include(buildem_status)
include(buildem_download_package)
include(buildem_cmake_recipe)

buildem_download_package(GIT_REPOSITORY "https://github.com/lltcggie/snappy.git"
                         GIT_BRANCH cmake
						 SOURCE_DIR snappy_SOURCE_DIR)

set(snappy_CMAKE_ARGS 
	-DBUILD_SHARED_LIBS=OFF
	-DCMAKE_DEBUG_POSTFIX=d
	-DBUILD_WITH_STATIC_CRT=${USE_STATIC_RUNTIME_LINK}
	)

buildem_cmake_recipe(NAME snappy  
					 SOURCE_DIR ${snappy_SOURCE_DIR}
				     CMAKE_ARGS ${snappy_CMAKE_ARGS}
					)