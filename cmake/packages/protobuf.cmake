include(buildem_status)
include(buildem_download_package)
include(buildem_cmake_recipe)

buildem_download_package(GIT_REPOSITORY "https://github.com/google/protobuf.git"
                         GIT_TAG v3.0.0-beta-1-bzl-fix
                         SOURCE_DIR protobuf_SOURCE_DIR
                         DIR_NAME protobuf)

buildem_download_package(GIT_REPOSITORY "https://github.com/google/googlemock.git"
                         GIT_TAG release-1.7.0
                         SOURCE_DIR gmock_SOURCE_DIR
                         DESTINATION ${BUILDEM_DOWNLOAD_CACHE}/protobuf
                         DIR_NAME gmock)

buildem_download_package(GIT_REPOSITORY "https://github.com/google/googletest.git"
                         GIT_TAG release-1.7.0
                         SOURCE_DIR gtest_SOURCE_DIR
                         DESTINATION ${BUILDEM_DOWNLOAD_CACHE}/protobuf/gmock
                         DIR_NAME gtest)

set(protobuf_CMAKE_ARGS
    -DBUILD_SHARED_LIBS=OFF
    -Dprotobuf_BUILD_TESTS=OFF
    -Dprotobuf_MSVC_STATIC_RUNTIME=${USE_STATIC_RUNTIME_LINK}
    )
    
buildem_cmake_recipe(NAME protobuf
                     SOURCE_DIR ${protobuf_SOURCE_DIR}/cmake
                     CMAKE_ARGS ${protobuf_CMAKE_ARGS}
                     )