set(target ML)

project(${target})

set(COMMONAPI_PATH /home/kolodiy/git/genivi)
set(capi-someip-gen ${COMMONAPI_PATH}/capicxx-someip-tools/org.genivi.commonapi.someip.cli.product/target/products/org.genivi.commonapi.someip.cli.product/linux/gtk/x86_64/commonapi-someip-generator-linux-x86_64)

set(SOURCE_GEN
  ${CMAKE_CURRENT_BINARY_DIR}/v1/ford/rnd/MLSomeIPStubAdapter.cpp
  ${CMAKE_CURRENT_BINARY_DIR}/v1/ford/rnd/MLSomeIPDeployment.cpp
  ${CMAKE_CURRENT_BINARY_DIR}/v1/ford/rnd/MLSomeIPProxy.cpp
  ${CMAKE_CURRENT_BINARY_DIR}/v1/ford/rnd/SmartMLSomeIPStubAdapter.cpp
  ${CMAKE_CURRENT_BINARY_DIR}/v1/ford/rnd/SmartMLSomeIPDeployment.cpp
  ${CMAKE_CURRENT_BINARY_DIR}/v1/ford/rnd/SmartMLSomeIPProxy.cpp
)

add_custom_command(OUTPUT ${SOURCE_GEN}
  COMMAND ${capi-someip-gen} --printfiles --dest ${CMAKE_CURRENT_BINARY_DIR} ${FIDL_PATH}/ML/ML.fdepl
  COMMAND ${capi-someip-gen} --printfiles --dest ${CMAKE_CURRENT_BINARY_DIR} ${FIDL_PATH}/ML/SmartML.fdepl
  DEPENDS ${FIDL_PATH}/ML/ML.fdepl ${FIDL_PATH}/ML/SmartML.fdepl
  WORKING_DIRECTORY ${FIDL_PATH}/ML
  COMMENT "Generate SOME/IP CommonAPI files for ML"
)

add_library(${target} SHARED ${SOURCE_GEN})
target_link_libraries(${target} CommonAPI-SomeIP)

