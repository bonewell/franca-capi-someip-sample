cmake_minimum_required(VERSION 2.8)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread -std=c++11")

set(COMMONAPI_PATH /home/kolodiy/git/genivi)
set(capi-core-gen ${COMMONAPI_PATH}/capicxx-core-tools/org.genivi.commonapi.core.cli.product/target/products/org.genivi.commonapi.core.cli.product/linux/gtk/x86_64/commonapi-generator-linux-x86_64)
set(FIDL_PATH ${CMAKE_SOURCE_DIR}/fidl)

macro(generate_core_interface NameInterface)

add_custom_command(OUTPUT
    ${CMAKE_BINARY_DIR}/src-gen/v1/ford/rnd/${NameInterface}StubDefault.cpp
    COMMAND ${capi-core-gen} --dest ${CMAKE_BINARY_DIR}/src-gen --skel fidl/${NameInterface}.fidl
    DEPENDS fidl/${NameInterface}.fidl
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Generate core CommonAPI files for fidl/${NameInterface}.fidl")

endmacro(generate_core_interface)

# Interface is formated string:
# <name>[.<name>...]:<major_version>
# For example: ford.rnd.VR:1
# Use ${INTERFACE_LIBRARY} to build your project
macro(create_service LibraryName Interface1 ...)
  set(INTERFACES ${ARGV})
  list(REMOVE_AT INTERFACES 0)
  message(STATUS "Configure ${LibraryName} service with ${INTERFACES} interfaces")
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
    COMMAND ${capi-core-gen} --printfiles --no-proxy --skel --dest ${CMAKE_CURRENT_BINARY_DIR} ${FIDL_FILES}
    DEPENDS ${FIDL_FILES}
    COMMENT "Generate source files for ${LibraryName} service"
  )

  add_library(${LibraryName}Core ${SOURCE_FILES})
  set(INTERFACE_LIBRARY CommonAPI ${LibraryName}Core)
endmacro(create_service)

generate_core_interface(ML)
generate_core_interface(SmartML)

find_package(CommonAPI 3.1.10 REQUIRED)

include_directories(
    ${CMAKE_BINARY_DIR}/src-gen
    ${COMMONAPI_INCLUDE_DIRS}
)
 
add_executable(client
    client/client.cpp
)
target_link_libraries(client CommonAPI)

add_executable(service_old
    service/service.cpp
    service/stub.cpp
    ${CMAKE_BINARY_DIR}/src-gen/v1/ford/rnd/MLStubDefault.cpp
    ${CMAKE_BINARY_DIR}/src-gen/v1/ford/rnd/SmartMLStubDefault.cpp
)
target_link_libraries(service_old CommonAPI)

add_dependencies(client service_old)

install(TARGETS client service_old
    RUNTIME DESTINATION ${CMAKE_BINARY_DIR}/bin
    LIBRARY DESTINATION ${CMAKE_BINARY_DIR}/lib
    PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE)

install(DIRECTORY config
    DESTINATION ${CMAKE_BINARY_DIR})

install(DIRECTORY scripts
    DESTINATION ${CMAKE_BINARY_DIR}
    FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE)

install(FILES
    ${COMMONAPI_PATH}/capicxx-core-runtime/build/libCommonAPI.so
    ${COMMONAPI_PATH}/capicxx-core-runtime/build/libCommonAPI.so.3.1.9
    ${COMMONAPI_PATH}/capicxx-someip-runtime/build/libCommonAPI-SomeIP.so
    ${COMMONAPI_PATH}/capicxx-someip-runtime/build/libCommonAPI-SomeIP.so.3.1.9
    ${COMMONAPI_PATH}/vsomeip/build/libvsomeip.so
    ${COMMONAPI_PATH}/vsomeip/build/libvsomeip.so.2
    ${COMMONAPI_PATH}/vsomeip/build/libvsomeip.so.2.5.0
    ${COMMONAPI_PATH}/vsomeip/build/libvsomeip-sd.so
    ${COMMONAPI_PATH}/vsomeip/build/libvsomeip-sd.so.2
    ${COMMONAPI_PATH}/vsomeip/build/libvsomeip-sd.so.2.5.0
    ${COMMONAPI_PATH}/vsomeip/build/libvsomeip-cfg.so
    ${COMMONAPI_PATH}/vsomeip/build/libvsomeip-cfg.so.2
    ${COMMONAPI_PATH}/vsomeip/build/libvsomeip-cfg.so.2.5.0
    DESTINATION ${CMAKE_BINARY_DIR}/lib
    PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE)

install(FILES
    ${COMMONAPI_PATH}/vsomeip/build/daemon/vsomeipd
    DESTINATION ${CMAKE_BINARY_DIR}/bin
    PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE)

add_subdirectory(libraries)
add_subdirectory(service)
