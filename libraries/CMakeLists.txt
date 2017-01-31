project(Libraries)

set(COMMONAPI_PATH /home/kolodiy/git/genivi)
set(capi-core-gen ${COMMONAPI_PATH}/capicxx-core-tools/org.genivi.commonapi.core.cli.product/target/products/org.genivi.commonapi.core.cli.product/linux/gtk/x86_64/commonapi-generator-linux-x86_64)
set(capi-someip-gen ${COMMONAPI_PATH}/capicxx-someip-tools/org.genivi.commonapi.someip.cli.product/target/products/org.genivi.commonapi.someip.cli.product/linux/gtk/x86_64/commonapi-someip-generator-linux-x86_64)
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

macro(append_fdepl_file FileName)
  list(APPEND FDEPL_FILES
    ${FIDL_PATH}/${FileName}.fdepl
  )
endmacro(append_fdepl_file)

macro(append_someip_type_collection Path Version)
  list(APPEND SOURCE_SOMEIP_FILES
    ${CMAKE_CURRENT_BINARY_DIR}/v${Version}/${Path}SomeIPDeployment.cpp
  )
endmacro(append_someip_type_collection)

macro(append_someip_interface Path Version)
  list(APPEND SOURCE_SOMEIP_FILES
    ${CMAKE_CURRENT_BINARY_DIR}/v${Version}/${Path}SomeIPStubAdapter.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/v${Version}/${Path}SomeIPDeployment.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/v${Version}/${Path}SomeIPProxy.cpp
  )
endmacro(append_someip_interface)

# Type is formated string:
# <name>[.<name>...]:<major_version>
# For example: ford.rnd.types.VR:1

macro(add_someip_types Type...)
  message(STATUS "Configure collections of types for SOME/IP - [ ${ARGV} ]")
  foreach(iface ${ARGV})
    get_interface_path(${iface} INTERFACE_PATH)
    get_interface_version(${iface} INTERFACE_VERSION)
    append_someip_type_collection(${INTERFACE_PATH} ${INTERFACE_VERSION})
    get_interface_file(${iface} FILE_NAME)
    append_fidl_file(${FILE_NAME})
    append_fdepl_file(${FILE_NAME})
  endforeach(iface)
endmacro(add_someip_types)

# Interface is formated string:
# <name>[.<name>...]:<major_version>
# For example: ford.rnd.VR:1

macro(add_someip_interfaces Interface...)
  message(STATUS "Configure interfaces for SOME/IP - [ ${ARGV} ]")
  foreach(iface ${ARGV})
    get_interface_path(${iface} INTERFACE_PATH)
    get_interface_version(${iface} INTERFACE_VERSION)
    append_someip_interface(${INTERFACE_PATH} ${INTERFACE_VERSION})
    get_interface_file(${iface} FILE_NAME)
    append_fidl_file(${FILE_NAME})
    append_fdepl_file(${FILE_NAME})
  endforeach(iface)
endmacro(add_someip_interfaces)

macro(add_someip_library Target)
  add_custom_command(OUTPUT ${SOURCE_SOMEIP_FILES}
    COMMAND ${capi-core-gen} --printfiles --dest ${CMAKE_CURRENT_BINARY_DIR} ${FIDL_FILES}
    COMMAND ${capi-someip-gen} --printfiles --dest ${CMAKE_CURRENT_BINARY_DIR} ${FDEPL_FILES}
    DEPENDS ${FIDL_FILES} ${FDEPL_FILES}
    COMMENT "Generate source files for ${Target} (SOME/IP) library"
  )
  add_library(${Target} SHARED ${SOURCE_SOMEIP_FILES})
  target_link_libraries(${Target} CommonAPI-SomeIP)
  install(TARGETS ${Target}
    LIBRARY DESTINATION ${CMAKE_BINARY_DIR}/build/lib
    PERMISSIONS OWNER_READ OWNER_WRITE
  )
  message(STATUS "Configure ${Target} (SOME/IP) library")
endmacro(add_someip_library)

find_package(CommonAPI 3.1.10 REQUIRED)
find_package(vsomeip 2.5.2 REQUIRED)
find_package(CommonAPI-SomeIP 3.1.10 REQUIRED)

include_directories(
  ${CMAKE_CURRENT_BINARY_DIR}
  ${COMMONAPI_INCLUDE_DIRS}
  ${VSOMEIP_INCLUDE_DIRS}
  ${COMMONAPI_SOMEIP_INCLUDE_DIRS}
)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR})

include(ML)
