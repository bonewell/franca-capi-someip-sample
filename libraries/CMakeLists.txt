project(Libraries)

set(COMMONAPI_PATH /home/kolodiy/git/genivi)
set(FIDL_PATH ${CMAKE_SOURCE_DIR}/fidl)

find_package(CommonAPI 3.1.10 REQUIRED)
find_package(vsomeip 2.5.2 REQUIRED)
find_package(CommonAPI-SomeIP 3.1.10 REQUIRED)

include_directories(
  ${CMAKE_CURRENT_BINARY_DIR}
  ${COMMONAPI_INCLUDE_DIRS}
  ${VSOMEIP_INCLUDE_DIRS}
  ${COMMONAPI_SOMEIP_INCLUDE_DIRS}
)

set(CMAKE_MODULE_PATH ${MODULES_PATH})
include(IpcMacro)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR})
include(ML)
include(Buttons)
