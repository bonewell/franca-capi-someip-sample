project(MLClient)

set(SOURCE client.cpp)

add_capi_types(MLProxy ford.rnd.MLTypes:1)
add_capi_interfaces(MLProxy ford.rnd.ML:1 ford.rnd.SmartML:1)
add_capi_library(MLProxy)

add_executable(${PROJECT_NAME} ${SOURCE})
target_link_libraries(${PROJECT_NAME} MLProxy CommonAPI)

install(TARGETS ${PROJECT_NAME}
  RUNTIME DESTINATION ${CMAKE_BINARY_DIR}/build/bin
  LIBRARY DESTINATION ${CMAKE_BINARY_DIR}/build/lib
  PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
)
