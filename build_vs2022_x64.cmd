@setlocal
@echo off
if NOT EXIST build_vs2022_x64 (
mkdir build_vs2022_x64
)

pushd build_vs2022_x64
:: Setup the environement for VS 2015 x64
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64
:: configure
:: Build all packages
:: Use shared libraries when possible
cmake -G Ninja ^
      -D CB_BUILD_ALL:BOOL=ON ^
      -D ZLIB_LIB_PREFIX:STRING=caffe ^
      -D ZLIB_BUILD_SHARED_LIBS:BOOL=ON ^
      -D GFLAGS_BUILD_SHARED_LIBS:BOOL=ON ^
      -D GLOG_BUILD_SHARED_LIBS:BOOL=ON ^
      -D HDF5_BUILD_SHARED_LIBS:BOOL=ON ^
      -D HDF5_LIB_PREFIX:STRING=caffe ^
      -D BOOST_BUILD_SHARED_LIBS:BOOL=ON ^
      -D LEVELDB_BUILD_SHARED_LIBS:BOOL=OFF ^
      -D LMDB_BUILD_SHARED_LIBS:BOOL=OFF ^
      -D OPENCV_BUILD_SHARED_LIBS:BOOL=OFF ^
      -D PROTOBUF_BUILD_SHARED_LIBS:BOOL=OFF ^
      -D OPENBLAS_BUILD_SHARED_LIBS:BOOL=ON ^
      -D SNAPPY_BUILD_SHARED_LIBS:BOOL=OFF ^
      -D BUILD_OPENCV:BOOL=OFF ^
      -D BUILD_LEVELDB:BOOL=OFF ^
      -D BUILD_LMDB:BOOL=OFF ^
      -D CB_BUILD_CONFIGURATION_TYPES=Release ^
      -D CMAKE_BUILD_TYPE:STRING=Release ^
      %~dp0
:: build
cmake --build .
popd
@endlocal
pause