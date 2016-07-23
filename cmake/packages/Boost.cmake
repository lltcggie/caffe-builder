include(buildem_status)
include(buildem_download_package)
include(buildem_boost_recipe)


 buildem_download_package(URL "http://downloads.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.7z"
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

if(BUILD_python)
	set(BOOST_BUILD_PYTHON_OPTION python)
endif()

if(USE_STATIC_RUNTIME_LINK)
	set(BOOST_RUNTIME_LINK static)
else()
	set(BOOST_RUNTIME_LINK shared)
endif()

 buildem_boost_recipe(NAME Boost
                      DEPENDS ZLIB
                      SOURCE_DIR ${Boost_SOURCE_DIR}
                      COMPONENTS system thread filesystem date_time iostreams ${BOOST_BUILD_PYTHON_OPTION} regex
                      RUNTIME_LINK ${BOOST_RUNTIME_LINK}
                      )


					