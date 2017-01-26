project(MLClient)

set(SOURCE client.cpp)

create_core_library(${PROJECT_NAME} ford.rnd.ML:1)
add_executable(${PROJECT_NAME} ${SOURCE})
target_link_libraries(${PROJECT_NAME} ${CORE_LIBRARY})

install(TARGETS ${PROJECT_NAME}
  RUNTIME DESTINATION ${CMAKE_BINARY_DIR}/build/bin
  LIBRARY DESTINATION ${CMAKE_BINARY_DIR}/build/lib
  PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
)

