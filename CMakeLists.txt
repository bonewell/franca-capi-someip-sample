cmake_minimum_required(VERSION 2.8)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread")

set(COMMONAPI /home/kolodiy/git/genivi)
set(FIDL ${CMAKE_SOURCE_DIR}/fidl)

set(MODULES_PATH ${CMAKE_SOURCE_DIR}/cmake_modules)

# Remove path to QNX JVM
string(REGEX REPLACE
    "/[^:]+/qnx660/jre/bin:"
    ""
    NEW_PATH
    $ENV{PATH}
)
set(ENV{PATH} ${NEW_PATH})

find_package(Java 1.8 REQUIRED)

install(DIRECTORY config
    DESTINATION ${CMAKE_BINARY_DIR}/build)

install(DIRECTORY scripts
    DESTINATION ${CMAKE_BINARY_DIR}/build
    FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE)

add_subdirectory(libraries)
add_subdirectory(service)
add_subdirectory(client)
