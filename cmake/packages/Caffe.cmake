include(buildem_status)
include(buildem_download_package)
include(buildem_cmake_recipe)

buildem_download_package(GIT_REPOSITORY "https://github.com/lltcggie/caffe.git"
						GIT_BRANCH visualstudio
						SOURCE_DIR Caffe_SOURCE_DIR)

set(Caffe_CMAKE_ARGS
	-DBUILD_SHARED_LIBS:BOOL=OFF
	-DBoost_USE_STATIC_LIBS=ON
	-DBoost_USE_MULTITHREAD=ON
	-DBoost_USE_STATIC_RUNTIME=${USE_STATIC_RUNTIME_LINK}
	-DOpenCV_STATIC:BOOL=ON
	-DBLAS:STRING=${BLAS}
	-DPROTOBUF_SRC_ROOT_FOLDER:PATH=${CMAKE_INSTALL_PREFIX}
	-DOpenCV_DIR:PATH=${CMAKE_INSTALL_PREFIX}
	-DCPU_ONLY=${CPU_ONLY}
	-DUSE_CUDNN=${USE_CUDNN}
	-DCUDNN_ROOT=${CUDNN_ROOT}
	-DBUILD_python=${BUILD_python}
	-DBUILD_matlab=${BUILD_matlab}
	-DBUILD_docs=${BUILD_docs}
	-DBUILD_python_layer=${BUILD_python_layer}
	-DUSE_OPENCV=${USE_OPENCV}
	-DUSE_LEVELDB=${USE_LEVELDB}
	-DUSE_LMDB=${USE_LMDB}
	-DBUILD_WITH_STATIC_CRT=${USE_STATIC_RUNTIME_LINK}
	-DCMAKE_LIBRARY_ARCHITECTURE=${CMAKE_LIBRARY_ARCHITECTURE}
	-DMKL_USE_SINGLE_DYNAMIC_LIBRARY=${MKL_USE_SINGLE_DYNAMIC_LIBRARY}
	-DMKL_USE_STATIC_LIBS=${MKL_USE_STATIC_LIBS}
	-DMKL_MULTI_THREADED=${MKL_MULTI_THREADED}
	-DCUDA_ARCH_NAME=Manual
	"-DCUDA_ARCH_BIN=20 21(20) 30 35 50 52 53"
	-DCUDA_ARCH_PTX=53
	)

set(depens_lib gflags glog Boost HDF5 protobuf)

if(USE_OPENCV)
	set(depens_lib ${depens_lib} OpenCV)
endif()
if(USE_LEVELDB)
	set(depens_lib ${depens_lib} snappy)
	set(depens_lib ${depens_lib} leveldb)
endif()
if(USE_LMDB)
	set(depens_lib ${depens_lib} lmdb)
endif()
if(${BLAS} STREQUAL Open OR ${BLAS} STREQUAL open OR ${BLAS} STREQUAL OPEN)
	set(depens_lib ${depens_lib} OpenBLAS)
endif()

buildem_cmake_recipe(NAME Caffe
					DEPENDS ${depens_lib}
					SOURCE_DIR ${Caffe_SOURCE_DIR}
					CMAKE_ARGS ${Caffe_CMAKE_ARGS}
					)