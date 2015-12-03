include(buildem_status)
include(buildem_download_package)

buildem_download_package(GIT_REPOSITORY "https://github.com/lltcggie/OpenBLAS.git"
                         GIT_BRANCH dev_install_cmake
						 SOURCE_DIR OpenBLAS_SOURCE_DIR)

set(OpenBLAS_CMAKE_ARGS 
	-DBUILD_SHARED_LIBS=OFF
	-DCMAKE_DEBUG_POSTFIX=d
	-DBUILD_WITH_STATIC_CRT=${USE_STATIC_RUNTIME_LINK}
	)

buildem_cmake_recipe(NAME OpenBLAS 
					 SOURCE_DIR ${OpenBLAS_SOURCE_DIR}
				     CMAKE_ARGS ${OpenBLAS_CMAKE_ARGS}
					)
