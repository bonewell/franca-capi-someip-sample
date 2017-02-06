project(MLClient)

set(CMAKE_MODULE_PATH ${MODULES_PATH})
include(IpcMacro)

add_capi_types(MLProxy com.ford.rnd.MLTypes:1)
add_capi_interfaces(MLProxy com.ford.rnd.ML:1 com.ford.rnd.SmartML:1)
add_capi_library(MLProxy)

set(SOURCE client.cpp)

add_executable(${PROJECT_NAME} ${SOURCE})
target_link_libraries(${PROJECT_NAME} MLProxy CommonAPI)

install(TARGETS ${PROJECT_NAME}
  RUNTIME DESTINATION ${CMAKE_BINARY_DIR}/build/bin
  LIBRARY DESTINATION ${CMAKE_BINARY_DIR}/build/lib
  PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
)
