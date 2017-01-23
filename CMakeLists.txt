cmake_minimum_required(VERSION 2.8)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread -std=c++11")
set(COMMONAPI_PATH /home/kolodiy/git/genivi)

set(capi-core-gen ${COMMONAPI_PATH}/capicxx-core-tools/org.genivi.commonapi.core.cli.product/target/products/org.genivi.commonapi.core.cli.product/linux/gtk/x86_64/commonapi-generator-linux-x86_64)

macro(generate_core_interface NameInterface)

add_custom_command(OUTPUT
    ${CMAKE_BINARY_DIR}/src-gen/v1/ford/rnd/${NameInterface}StubDefault.cpp
    COMMAND ${capi-core-gen} --dest ${CMAKE_BINARY_DIR}/src-gen --skel fidl/ML/${NameInterface}.fidl
    DEPENDS fidl/ML/${NameInterface}.fidl
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Generate core CommonAPI files for fidl/${NameInterface}.fidl")

endmacro(generate_core_interface)

generate_core_interface(ML)
generate_core_interface(SmartML)

include_directories(
    ${CMAKE_BINARY_DIR}/src-gen
    ${COMMONAPI_PATH}/capicxx-core-runtime/include
    ${COMMONAPI_PATH}/capicxx-someip-runtime/include
    ${COMMONAPI_PATH}/vsomeip/interface
)
 
link_directories(
    ${COMMONAPI_PATH}/capicxx-core-runtime/build
    ${COMMONAPI_PATH}/capicxx-someip-runtime/build
)
 
add_executable(client
    src/client.cpp
)
target_link_libraries(client CommonAPI)

add_executable(service
    src/service.cpp
    src/stub.cpp
    ${CMAKE_BINARY_DIR}/src-gen/v1/ford/rnd/MLStubDefault.cpp
    ${CMAKE_BINARY_DIR}/src-gen/v1/ford/rnd/SmartMLStubDefault.cpp
)
target_link_libraries(service CommonAPI)

add_dependencies(client service)

install(TARGETS client service
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
