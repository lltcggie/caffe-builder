cmake_minimum_required (VERSION 3.0 FATAL_ERROR)

set (CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/install" CACHE PATH "Path where to install binaries")
set (CUDNN_ROOT "${CMAKE_CURRENT_LIST_DIR}/cudnn" CACHE PATH "Path where cudnn liblary")

project (caffe-builder)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/modules")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/packages")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

set(BUILDEM_DOWNLOAD_CACHE ${CMAKE_CURRENT_BINARY_DIR}/DownloadCache)

option(USE_STATIC_RUNTIME_LINK "MSVC Runtime static link" OFF)

option(CPU_ONLY  "Build Caffe without CUDA support" OFF)
option(USE_CUDNN "Build Caffe with cuDNN library support" OFF)
option(BUILD_python "Build Python wrapper" ON)
option(BUILD_matlab "Build Matlab wrapper" OFF)
option(BUILD_docs   "Build documentation" ON)
option(BUILD_python_layer "Build the Caffe Python layer" ON)
option(USE_OPENCV "Build with OpenCV support" ON)
option(USE_LEVELDB "Build with levelDB" ON)
option(USE_LMDB "Build with lmdb" ON)
option(BLAS "Selected BLAS library" "Open")
option(MKL_USE_SINGLE_DYNAMIC_LIBRARY "Use single dynamic library interface" ON)
option(MKL_USE_STATIC_LIBS "Use static libraries" OFF)
option(MKL_MULTI_THREADED  "Use multi-threading" ON)

if(CPU_ONLY)
	set(USE_CUDNN OFF)
endif()
if(NOT BUILD_python)
	set(BUILD_python_layer OFF)
endif()

if(MSVC)
  if(CMAKE_CL_64)
    set(CMAKE_LIBRARY_ARCHITECTURE x64)
  else()
    set(CMAKE_LIBRARY_ARCHITECTURE x86)
  endif()
endif()

include(buildem_all)

# order is important dependees go before dependers
include(ZLIB)
include(HDF5) # depends on ZLIB
include(protobuf) 
include(gflags)
include(glog) # depends (optionally) on gflags
include(Boost)
if(USE_LMDB)
	include(lmdb)
endif()
if(USE_LEVELDB)
	include(snappy)
	include(leveldb) # depends on Boost
endif()
if(USE_OPENCV)
	include(OpenCV) # depends on ZLIB
endif()
if(${BLAS} STREQUAL Open OR ${BLAS} STREQUAL open OR ${BLAS} STREQUAL OPEN)
	include(OpenBLAS) 
endif()
include(Caffe) # depends on all the above except cvmatio
if(USE_CUDNN)
  include("${CUDNN_ROOT}/cuDNNInstall.cmake")
endif()
