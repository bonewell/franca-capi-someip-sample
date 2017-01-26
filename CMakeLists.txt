cmake_minimum_required(VERSION 2.8)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread -std=c++11")

set(COMMONAPI_PATH /home/kolodiy/git/genivi)
set(capi-core-gen ${COMMONAPI_PATH}/capicxx-core-tools/org.genivi.commonapi.core.cli.product/target/products/org.genivi.commonapi.core.cli.product/linux/gtk/x86_64/commonapi-generator-linux-x86_64)
set(FIDL_PATH ${CMAKE_SOURCE_DIR}/fidl)

# Interface is formated string:
# <name>[.<name>...]:<major_version>
# For example: ford.rnd.VR:1
# Use ${INTERFACE_LIBRARY} to build your project
macro(create_core_library LibraryName Interface1...)
  set(CORE_NAME ${LibraryName}Core)
  set(INTERFACES ${ARGV})
  list(REMOVE_AT INTERFACES 0)
  message(STATUS "Configure ${CORE_NAME} library with ${INTERFACES} interfaces")
  set(SOURCE_FILES) 
  set(FIDL_FILES)
  foreach(iface ${INTERFACES})
    string(FIND ${iface} ":" DELIMITER_INDEX)
    string(SUBSTRING ${iface} 0 ${DELIMITER_INDEX} INTERFACE_NAME)
    string(REPLACE "." "/" INTERFACE_PATH ${INTERFACE_NAME})

    math(EXPR VERSION_INDEX ${DELIMITER_INDEX}+1)
    string(SUBSTRING ${iface} ${VERSION_INDEX} -1 INTERFACE_VERSION)

    list(APPEND SOURCE_FILES
      ${CMAKE_CURRENT_BINARY_DIR}/v${INTERFACE_VERSION}/${INTERFACE_PATH}StubDefault.cpp
    )
    
    string(FIND ${INTERFACE_NAME} "." FIDL_INDEX REVERSE)
    math(EXPR FILE_INDEX ${FIDL_INDEX}+1)
    string(SUBSTRING ${INTERFACE_NAME} ${FILE_INDEX} -1 FIDL_NAME)
    list(APPEND FIDL_FILES
      ${FIDL_PATH}/${FIDL_NAME}.fidl
    )
  endforeach(iface)

  find_package(CommonAPI 3.1.10 REQUIRED)

  include_directories(
    ${CMAKE_CURRENT_BINARY_DIR}
    ${COMMONAPI_INCLUDE_DIRS}
  )

  add_custom_command(OUTPUT ${SOURCE_FILES}
    COMMAND ${capi-core-gen} --printfiles --skel --dest ${CMAKE_CURRENT_BINARY_DIR} ${FIDL_FILES}
    DEPENDS ${FIDL_FILES}
    COMMENT "Generate source files for ${CORE_NAME} library"
  )

  add_library(${CORE_NAME} ${SOURCE_FILES})
  set(CORE_LIBRARY CommonAPI ${CORE_NAME})
endmacro(create_core_library)

install(DIRECTORY config
    DESTINATION ${CMAKE_BINARY_DIR}/build)

install(DIRECTORY scripts
    DESTINATION ${CMAKE_BINARY_DIR}/build
    FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE)

add_subdirectory(libraries)
add_subdirectory(service)
add_subdirectory(client)
