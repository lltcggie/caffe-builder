cmake_minimum_required (VERSION 3.0 FATAL_ERROR)

set (CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/install" CACHE PATH "Path where to install binaries")

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

if(CPU_ONLY)
	set(USE_CUDNN OFF)
endif()
if(NOT BUILD_python)
	set(BUILD_python_layer OFF)
endif()

include(buildem_all)

# order is important dependees go before dependers
include(ZLIB)
include(HDF5) # depends on ZLIB
include(snappy)
include(protobuf) 
include(OpenBLAS) 
include(gflags)
include(glog) # depends (optionally) on gflags
include(Boost)
if(USE_LMDB)
	include(lmdb)
endif()
if(USE_LEVELDB)
	include(leveldb) # depends on Boost
endif()
if(USE_OPENCV)
	include(OpenCV) # depends on ZLIB
endif()
include(Caffe) # depends on all the above except cvmatio
