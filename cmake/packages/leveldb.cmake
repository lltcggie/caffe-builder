include(buildem_status)
include(buildem_download_package)
include(buildem_cmake_recipe)

buildem_download_package(GIT_REPOSITORY "https://github.com/lltcggie/leveldb.git"
                         GIT_BRANCH cmake
						 SOURCE_DIR leveldb_SOURCE_DIR)

set(leveldb_CMAKE_ARGS 
	-DBUILD_SHARED_LIBS=OFF
	-DCMAKE_DEBUG_POSTFIX=d
    -DBoost_USE_STATIC_LIBS=ON
    -DBoost_USE_MULTITHREAD=ON
    -DBoost_USE_STATIC_RUNTIME=${USE_STATIC_RUNTIME_LINK}
	-DBUILD_WITH_STATIC_CRT=${USE_STATIC_RUNTIME_LINK}
	)

buildem_cmake_recipe(NAME leveldb  
					 DEPENDS Boost
					 SOURCE_DIR ${leveldb_SOURCE_DIR}
				     CMAKE_ARGS ${leveldb_CMAKE_ARGS}
					)