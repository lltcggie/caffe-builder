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
	-DBLAS:STRING=Open
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
	)

set(depens_lib gflags glog Boost HDF5 snappy OpenBLAS protobuf)

if(USE_OPENCV)
	set(depens_lib ${depens_lib} OpenCV)
endif()
if(USE_LEVELDB)
	set(depens_lib ${depens_lib} leveldb)
endif()
if(USE_LMDB)
	set(depens_lib ${depens_lib} lmdb)
endif()

buildem_cmake_recipe(NAME Caffe
					DEPENDS ${depens_lib}
					SOURCE_DIR ${Caffe_SOURCE_DIR}
					CMAKE_ARGS ${Caffe_CMAKE_ARGS}
					)