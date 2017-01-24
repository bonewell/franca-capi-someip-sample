project(MLService)

set(SOURCE
  service.cpp
  stub.cpp
)

create_service(${PROJECT_NAME} ford.rnd.ML:1 ford.rnd.SmartML:1)

add_executable(${PROJECT_NAME} ${SOURCE})
target_link_libraries(${PROJECT_NAME} ${INTERFACE_LIBRARY})

install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION ${CMAKE_BINARY_DIR}/bin
    LIBRARY DESTINATION ${CMAKE_BINARY_DIR}/lib
    PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
)

