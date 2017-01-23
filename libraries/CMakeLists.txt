set(COMMONAPI_PATH /home/kolodiy/git/genivi)
set(capi-someip-gen ${COMMONAPI_PATH}/capicxx-someip-tools/org.genivi.commonapi.someip.cli.product/target/products/org.genivi.commonapi.someip.cli.product/linux/gtk/x86_64/commonapi-someip-generator-linux-x86_64)
set(FIDL_PATH ${CMAKE_SOURCE_DIR}/fidl)

# Interfaces is list of strings which have format:
# <name>[.<name>...]:<major_version>
# For example: ford.rnd.VR:1
macro(create_someip_library NameLibrary Interfaces)
  # Generate list of names of files according with Interfaces to add
  set(SOURCE_FILES)
  foreach(iface ${Interfaces})
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
  endforeach(iface)

  add_custom_command(OUTPUT ${SOURCE_FILES}
    COMMAND ${capi-someip-gen} --printfiles --dest ${CMAKE_CURRENT_BINARY_DIR} --searchpath ${FIDL_PATH}/${NameLibrary}
    DEPENDS ${FIDL_PATH}/${NameLibrary}
    COMMENT "Generate SOME/IP CommonAPI files for ${NameLibrary} library"
  )

  add_library(${NameLibrary} SHARED ${SOURCE_FILES})
  target_link_libraries(${NameLibrary} CommonAPI-SomeIP)
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
