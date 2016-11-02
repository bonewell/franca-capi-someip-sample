cmake_minimum_required(VERSION 2.8)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread -std=c++11")
 
include_directories(
    src-gen
    ../capicxx-core-runtime/include
    ../capicxx-someip-runtime/include
    ../vsomeip/interface
)
 
link_directories(
    /home/kolodiy/git/capicxx-core-runtime/build
    /home/kolodiy/git/capicxx-someip-runtime/build
)
 
add_executable(client
    src/client.cpp
)
target_link_libraries(client CommonAPI)

add_executable(service
    src/service.cpp
    src/stub.cpp
    src-gen/v1/ford/rnd/MLStubDefault.cpp
)
target_link_libraries(service CommonAPI)

add_library(ML SHARED
    src-gen/v1/ford/rnd/MLSomeIPStubAdapter.cpp
    src-gen/v1/ford/rnd/MLSomeIPDeployment.cpp
    src-gen/v1/ford/rnd/MLSomeIPProxy.cpp
)
target_link_libraries(ML CommonAPI-SomeIP)
