cmake_minimum_required(VERSION 2.8)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread -std=c++11")
set(COMMONAPI_PATH /home/kolodiy/git)

set(capi-core-gen ${COMMONAPI_PATH}/capicxx-core-tools/org.genivi.commonapi.core.cli.product/target/products/org.genivi.commonapi.core.cli.product/linux/gtk/x86_64/commonapi-generator-linux-x86_64 --dest ${CMAKE_BINARY_DIR}/src-gen --skel fidl/ML.fidl)

add_custom_command(OUTPUT
    ${CMAKE_BINARY_DIR}/src-gen/v1/ford/rnd/MLStubDefault.cpp
    COMMAND ${capi-core-gen}
    DEPENDS fidl/ML.fidl
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Generate core CommonAPI files")

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
)
target_link_libraries(service CommonAPI)

add_dependencies(client service)

set(capi-someip-gen ${COMMONAPI_PATH}/capicxx-someip-tools/org.genivi.commonapi.someip.cli.product/target/products/org.genivi.commonapi.someip.cli.product/linux/gtk/x86_64/commonapi-someip-generator-linux-x86_64 --dest ${CMAKE_BINARY_DIR}/src-gen fidl/ML.fdepl)

add_custom_command(OUTPUT
    ${CMAKE_BINARY_DIR}/src-gen/v1/ford/rnd/MLSomeIPStubAdapter.cpp
    ${CMAKE_BINARY_DIR}/src-gen/v1/ford/rnd/MLSomeIPDeployment.cpp
    ${CMAKE_BINARY_DIR}/src-gen/v1/ford/rnd/MLSomeIPProxy.cpp
    COMMAND ${capi-someip-gen}
    DEPENDS fidl/ML.fdepl
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Generate SOME/IP CommonAPI files")


add_library(ML SHARED
    ${CMAKE_BINARY_DIR}/src-gen/v1/ford/rnd/MLSomeIPStubAdapter.cpp
    ${CMAKE_BINARY_DIR}/src-gen/v1/ford/rnd/MLSomeIPDeployment.cpp
    ${CMAKE_BINARY_DIR}/src-gen/v1/ford/rnd/MLSomeIPProxy.cpp
)
target_link_libraries(ML CommonAPI-SomeIP)

install(TARGETS client service ML
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
    ${COMMONAPI_PATH}/vsomeip/build/libvsomeip.so.2.4.2
    DESTINATION ${CMAKE_BINARY_DIR}/lib
    PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE)

install(FILES
    ${COMMONAPI_PATH}/vsomeip/build/daemon/vsomeipd
    DESTINATION ${CMAKE_BINARY_DIR}/bin
    PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE)
