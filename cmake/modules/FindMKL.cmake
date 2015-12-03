# Find the MKL libraries
#
# Options:
#
#   MKL_USE_SINGLE_DYNAMIC_LIBRARY  : use single dynamic library interface
#   MKL_USE_STATIC_LIBS             : use static libraries
#   MKL_MULTI_THREADED              : use multi-threading
#
# This module defines the following variables:
#
#   MKL_FOUND            : True mkl is found
#   MKL_INCLUDE_DIR      : unclude directory
#   MKL_LIBRARIES        : the libraries to link against.

message(STATUS "Using custom Find${CMAKE_FIND_PACKAGE_NAME} module")

# ---[ Options
option(MKL_USE_SINGLE_DYNAMIC_LIBRARY "Use single dynamic library interface" ON)
option(MKL_USE_STATIC_LIBS "Use static libraries" OFF)
option(MKL_MULTI_THREADED  "Use multi-threading" ON)

# ---[ Root folders
if(NOT MSVC)
  set(INTEL_ROOT "/opt/intel" CACHE PATH "Folder contains intel libs")
else()
if(NOT INTEL_ROOT)
  function(get_reg_key_sub_list key out_sub_key_list)
    string(LENGTH "${key}" key_length)
    math(EXPR subkey_start_pos "${key_length} + 1")

    execute_process(COMMAND reg query "${key}" /f * /k OUTPUT_VARIABLE reg_output)
    string(REPLACE "\n" ";" reg_list_tmp ${reg_output})
    set(reg_list)
    foreach(reg ${reg_list_tmp})
      if("${reg}" MATCHES HKEY.+)
        string(SUBSTRING "${reg}" ${subkey_start_pos} -1 sub_key)
        list(APPEND reg_list ${sub_key})
      endif()
    endforeach()

    set(${out_sub_key_list} "${reg_list}" PARENT_SCOPE)
  endfunction()

  function(get_intel_compoler_version key out_version)
    get_reg_key_sub_list("${key}" out_sub_key_list)

    set(IntelCompilerVersion)
    foreach(key ${out_sub_key_list})
      if("${key}" MATCHES "^[0-9]+$")
        set(IntelCompilerVersion ${key})
      endif()
    endforeach()
    
    set(${out_version} ${IntelCompilerVersion} PARENT_SCOPE)
  endfunction()

  set(intel_compoler_reg_key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Intel\\IDE\\C++")
  get_intel_compoler_version("${intel_compoler_reg_key}" intel_compoler_version)
  if(NOT intel_compoler_version)
    set(intel_compoler_reg_key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Intel\\IDE\\C++")
    get_intel_compoler_version("${intel_compoler_reg_key}" intel_compoler_version)
  endif()

  set(INTEL_MSVC_TOOLSET_MAP_1600 10)
  set(INTEL_MSVC_TOOLSET_MAP_1700 11)
  set(INTEL_MSVC_TOOLSET_MAP_1800 12)
  set(INTEL_MSVC_TOOLSET_MAP_1900 14)

  set(INTEL_MSVC_TOOLSET VS${INTEL_MSVC_TOOLSET_MAP_${MSVC_VERSION}})

  GET_FILENAME_COMPONENT(found_intel_root_path "[${intel_compoler_reg_key}\\${intel_compoler_version}\\${INTEL_MSVC_TOOLSET};ProductDir]"
                          ABSOLUTE)
  set(INTEL_ROOT "${found_intel_root_path}/windows" CACHE PATH "Folder contains intel libs")
  else()
    set(INTEL_ROOT "/opt/intel" CACHE PATH "Folder contains intel libs")
  endif()
endif()

find_path(MKL_ROOT include/mkl.h PATHS $ENV{MKL_ROOT} ${INTEL_ROOT}/mkl
                                   DOC "Folder contains MKL")

# ---[ Find include dir
find_path(MKL_INCLUDE_DIR mkl.h PATHS ${MKL_ROOT} PATH_SUFFIXES include)
set(__looked_for MKL_INCLUDE_DIR)

# ---[ Find libraries
if(CMAKE_SIZEOF_VOID_P EQUAL 4)
  set(__path_suffixes lib lib/ia32 lib/ia32_win)
else()
  set(__path_suffixes lib lib/intel64 lib/intel64_win)
endif()

set(__mkl_libs "")
if(MKL_USE_SINGLE_DYNAMIC_LIBRARY)
  list(APPEND __mkl_libs rt)
else()
  if(CMAKE_SIZEOF_VOID_P EQUAL 4)
    if(WIN32)
      list(APPEND __mkl_libs intel_c)
    else()
      list(APPEND __mkl_libs intel gf)
    endif()
  else()
    if(NOT WIN32)
      list(APPEND __mkl_libs intel_lp64 gf_lp64)
    else()
      list(APPEND __mkl_libs intel_lp64)
    endif()
  endif()

  if(MKL_MULTI_THREADED)
    list(APPEND __mkl_libs intel_thread)
  else()
     list(APPEND __mkl_libs sequential)
  endif()

  list(APPEND __mkl_libs core)
  
  if(NOT MSVC)
    list(APPEND __mkl_libs cdft_core)
  endif()
endif()


foreach (__lib ${__mkl_libs})
  set(__mkl_lib "mkl_${__lib}")
  string(TOUPPER ${__mkl_lib} __mkl_lib_upper)

  if(NOT MSVC)
    if(MKL_USE_STATIC_LIBS)
      set(__mkl_lib "lib${__mkl_lib}.a")
    endif()
  else()
    if(MKL_USE_STATIC_LIBS OR ${__mkl_lib} STREQUAL blas95_ilp64 OR ${__mkl_lib} STREQUAL blas95_lp64 OR ${__mkl_lib} STREQUAL rt)
      set(__mkl_lib "${__mkl_lib}.lib")
    else()
      set(__mkl_lib "${__mkl_lib}_dll.lib")
    endif()
  endif()

  find_library(${__mkl_lib_upper}_LIBRARY
        NAMES ${__mkl_lib}
        PATHS "${MKL_ROOT}/lib/intel64_win"
        #PATH_SUFFIXES ${__path_suffixes}
        )
        
  if(MSVC)
    if(MKL_USE_STATIC_LIBS OR "${${__mkl_lib_upper}_LIBRARY}" MATCHES ".*_dll.lib$")
      string(REGEX REPLACE "_dll.lib$" ".lib" new_lib "${${__mkl_lib_upper}_LIBRARY}")
      set(${__mkl_lib_upper}_LIBRARY "${new_lib}")
    endif()
  endif()

  mark_as_advanced(${__mkl_lib_upper}_LIBRARY)

  list(APPEND __looked_for ${__mkl_lib_upper}_LIBRARY)
  list(APPEND MKL_LIBRARIES ${${__mkl_lib_upper}_LIBRARY})
endforeach()


if(NOT MKL_USE_SINGLE_DYNAMIC_LIBRARY)
  set(__iomp5_libs iomp5 libiomp5md.lib)

  find_library(MKL_RTL_LIBRARY ${__iomp5_libs}
     PATHS ${INTEL_RTL_ROOT} ${INTEL_ROOT}/compiler ${MKL_ROOT}/.. ${MKL_ROOT}/../compiler
     PATH_SUFFIXES ${__path_suffixes}
     DOC "Path to Path to OpenMP runtime library")

  list(APPEND __looked_for MKL_RTL_LIBRARY)
  list(APPEND MKL_LIBRARIES ${MKL_RTL_LIBRARY})
endif()


include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MKL DEFAULT_MSG ${__looked_for})

if(MKL_FOUND)
  message(STATUS "Found MKL (include: ${MKL_INCLUDE_DIR}, lib: ${MKL_LIBRARIES}")
endif()
