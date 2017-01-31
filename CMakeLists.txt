cmake_minimum_required(VERSION 2.8)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread -std=c++11")

set(COMMONAPI_PATH /home/kolodiy/git/genivi)
set(capi-core-gen ${COMMONAPI_PATH}/capicxx-core-tools/org.genivi.commonapi.core.cli.product/target/products/org.genivi.commonapi.core.cli.product/linux/gtk/x86_64/commonapi-generator-linux-x86_64)
set(FIDL_PATH ${CMAKE_SOURCE_DIR}/fidl)

function(get_interface_path IName IPath)
  string(FIND ${IName} ":" DELIMITER_INDEX)
  string(SUBSTRING ${IName} 0 ${DELIMITER_INDEX} INTERFACE_NAME)
  string(REPLACE "." "/" INTERFACE_PATH ${INTERFACE_NAME})
  set(${IPath} ${INTERFACE_PATH} PARENT_SCOPE)
endfunction(get_interface_path)

function(get_interface_file IName IFile)
  string(FIND ${IName} ":" DELIMITER_INDEX)
  string(SUBSTRING ${IName} 0 ${DELIMITER_INDEX} INTERFACE_NAME)
  string(FIND ${INTERFACE_NAME} "." FDEPL_INDEX REVERSE)
  math(EXPR FILE_INDEX ${FDEPL_INDEX}+1)
  string(SUBSTRING ${INTERFACE_NAME} ${FILE_INDEX} -1 FILE_NAME)
  set(${IFile} ${FILE_NAME} PARENT_SCOPE)
endfunction(get_interface_file)

function(get_interface_version IName IVersion)
  string(FIND ${IName} ":" DELIMITER_INDEX)
  math(EXPR VERSION_INDEX ${DELIMITER_INDEX}+1)
  string(SUBSTRING ${IName} ${VERSION_INDEX} -1 INTERFACE_VERSION)
  set(${IVersion} ${INTERFACE_VERSION} PARENT_SCOPE)
endfunction(get_interface_version)

macro(append_fidl_file FileName)
  list(APPEND FIDL_FILES
    ${FIDL_PATH}/${FileName}.fidl
  )
endmacro(append_fidl_file)

macro(append_capi_interface Path Version)
  list(APPEND SOURCE_CAPI_FILES
    ${CMAKE_CURRENT_BINARY_DIR}/v${Version}/${Path}StubDefault.cpp
  )
endmacro(append_capi_interface)

# Type is formated string:
# <name>[.<name>...]:<major_version>
# For example: ford.rnd.types.VR:1

macro(add_capi_types Type...)
  message(STATUS "Configure collections of types for CommonAPI - [ ${ARGV} ]")
  foreach(iface ${ARGV})
    get_interface_path(${iface} INTERFACE_PATH)
    get_interface_version(${iface} INTERFACE_VERSION)
    get_interface_file(${iface} FILE_NAME)
    append_fidl_file(${FILE_NAME})
  endforeach(iface)
endmacro(add_capi_types)

# Interface is formated string:
# <name>[.<name>...]:<major_version>
# For example: ford.rnd.VR:1

macro(add_capi_interfaces Interface...)
  message(STATUS "Configure interfaces for CommonAPI - [ ${ARGV} ]")
  foreach(iface ${ARGV})
    get_interface_path(${iface} INTERFACE_PATH)
    get_interface_version(${iface} INTERFACE_VERSION)
    append_capi_interface(${INTERFACE_PATH} ${INTERFACE_VERSION})
    get_interface_file(${iface} FILE_NAME)
    append_fidl_file(${FILE_NAME})
  endforeach(iface)
endmacro(add_capi_interfaces)

macro(add_capi_library Target)
  find_package(CommonAPI 3.1.10 REQUIRED)
  include_directories(
    ${CMAKE_CURRENT_BINARY_DIR}
    ${COMMONAPI_INCLUDE_DIRS}
  )
  add_custom_command(OUTPUT ${SOURCE_CAPI_FILES}
    COMMAND ${capi-core-gen} --printfiles --skel --dest ${CMAKE_CURRENT_BINARY_DIR} ${FIDL_FILES}
    DEPENDS ${FIDL_FILES}
    COMMENT "Generate source files for ${Target} (CommonAPI) library"
  )
  add_library(${Target} ${SOURCE_CAPI_FILES})
  message(STATUS "Configure ${Target} (CommonAPI) library")
endmacro(add_capi_library)

install(DIRECTORY config
    DESTINATION ${CMAKE_BINARY_DIR}/build)

install(DIRECTORY scripts
    DESTINATION ${CMAKE_BINARY_DIR}/build
    FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE)

add_subdirectory(libraries)
add_subdirectory(service)
add_subdirectory(client)
