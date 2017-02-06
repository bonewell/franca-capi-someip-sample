cmake_minimum_required(VERSION 2.8)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread -std=c++11")

set(COMMONAPI /home/kolodiy/git/genivi)
set(FIDL ${CMAKE_SOURCE_DIR}/fidl)

set(MODULES_PATH ${CMAKE_SOURCE_DIR}/cmake_modules)

install(DIRECTORY config
    DESTINATION ${CMAKE_BINARY_DIR}/build)

install(DIRECTORY scripts
    DESTINATION ${CMAKE_BINARY_DIR}/build
    FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE)

add_subdirectory(libraries)
add_subdirectory(service)
add_subdirectory(client)
