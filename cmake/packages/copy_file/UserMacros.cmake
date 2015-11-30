########################################################
#  Include file for user options
########################################################

# Include HDF5's default UserMacros
file(GLOB _user_macros_scripts ${CMAKE_CURRENT_LIST_DIR}/config/cmake/UserMacros/*.cmake)

foreach(_macro ${_user_macros_scripts})
	include("${_macro}")
endforeach()
