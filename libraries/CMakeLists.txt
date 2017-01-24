set(COMMONAPI_PATH /home/kolodiy/git/genivi)
set(capi-someip-gen ${COMMONAPI_PATH}/capicxx-someip-tools/org.genivi.commonapi.someip.cli.product/target/products/org.genivi.commonapi.someip.cli.product/linux/gtk/x86_64/commonapi-someip-generator-linux-x86_64)
set(FIDL_PATH ${CMAKE_SOURCE_DIR}/fidl)

# Interface is formated string:
# <name>[.<name>...]:<major_version>
# For example: ford.rnd.VR:1
macro(create_someip_library LibraryName Interface1 ...)
  set(INTERFACES ${ARGV})
  list(REMOVE_AT INTERFACES 0)
  message(STATUS "Configure ${LibraryName} library with ${INTERFACES} interfaces")
  # Generate list of names of files according with INTERFACES to add
  set(FDEPL_FILES)
  set(SOURCE_FILES)
  foreach(iface ${INTERFACES})
    string(FIND ${iface} ":" DELIMITER_INDEX)
    string(SUBSTRING ${iface} 0 ${DELIMITER_INDEX} INTERFACE_NAME)
    string(REPLACE "." "/" INTERFACE_PATH ${INTERFACE_NAME})

    math(EXPR VERSION_INDEX ${DELIMITER_INDEX}+1)
    string(SUBSTRING ${iface} ${VERSION_INDEX} -1 INTERFACE_VERSION)

    list(APPEND SOURCE_FILES
      ${CMAKE_CURRENT_BINARY_DIR}/v${INTERFACE_VERSION}/${INTERFACE_PATH}SomeIPStubAdapter.cpp
      ${CMAKE_CURRENT_BINARY_DIR}/v${INTERFACE_VERSION}/${INTERFACE_PATH}SomeIPDeployment.cpp
      ${CMAKE_CURRENT_BINARY_DIR}/v${INTERFACE_VERSION}/${INTERFACE_PATH}SomeIPProxy.cpp
    )

    string(FIND ${INTERFACE_NAME} "." FDEPL_INDEX REVERSE)
    math(EXPR FILE_INDEX ${FDEPL_INDEX}+1)
    string(SUBSTRING ${INTERFACE_NAME} ${FILE_INDEX} -1 FDEPL_NAME)
    list(APPEND FDEPL_FILES
      ${FIDL_PATH}/${FDEPL_NAME}.fdepl
    )
  endforeach(iface)

  add_custom_command(OUTPUT ${SOURCE_FILES}
    COMMAND ${capi-someip-gen} --printfiles --dest ${CMAKE_CURRENT_BINARY_DIR} ${FDEPL_FILES}
    DEPENDS ${FDEPL_FILES}
    COMMENT "Generate source files for ${LibraryName} library"
  )

  add_library(${LibraryName} SHARED ${SOURCE_FILES})
  target_link_libraries(${LibraryName} CommonAPI-SomeIP)
endmacro(create_someip_library)

find_package(vsomeip 2.5.2 REQUIRED)
find_package(CommonAPI-SomeIP 3.1.10 REQUIRED)

include_directories(
  ${CMAKE_CURRENT_BINARY_DIR}
  ${VSOMEIP_INCLUDE_DIRS}
  ${COMMONAPI_SOMEIP_INCLUDE_DIRS}
)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR})

include(ML)
