message(STATUS "Using custom OpenBLAS module")

set(OpenBLAS "${CMAKE_INSTALL_PREFIX}/lib/cmake/openblas" CACHE PATH "")
find_package(OpenBLAS CONFIG NO_CMAKE_PACKAGE_REGISTRY NO_CMAKE_SYSTEM_PACKAGE_REGISTRY)

if(OpenBLAS_FOUND)
  if(NOT TARGET ZLIB)
      # Use only static library
      set(OpenBLAS_LIBRARIES openblas_static)
      set(OPENBLAS_LIBRARIES openblas_static)
  endif()

  set(OpenBLAS_LIB "${OpenBLAS_LIBRARIES}")
  set(OPENBLAS_LIB "${OPENBLAS_LIBRARIES}")
endif()
