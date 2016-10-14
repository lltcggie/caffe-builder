message(STATUS "Using custom FindProtobuf module")
set(Protobuf_DIR "${CMAKE_INSTALL_PREFIX}/lib/cmake/protobuf" CACHE PATH "")
find_package(Protobuf CONFIG NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PACKAGE_REGISTRY)
