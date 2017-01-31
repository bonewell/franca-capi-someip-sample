project(MLService)

set(SOURCE
  service.cpp
  mlservice.cpp
  smartmlservice.cpp
)

add_capi_types(ford.rnd.MLTypes:1)
add_capi_interfaces(ford.rnd.ML:1 ford.rnd.SmartML:1)
add_capi_library(MLStub)

add_executable(${PROJECT_NAME} ${SOURCE})
target_link_libraries(${PROJECT_NAME} MLStub CommonAPI)

install(TARGETS ${PROJECT_NAME}
  RUNTIME DESTINATION ${CMAKE_BINARY_DIR}/build/bin
  LIBRARY DESTINATION ${CMAKE_BINARY_DIR}/build/lib
  PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
)
