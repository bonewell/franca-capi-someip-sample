#
# Macros and functions for build support of Inter-process communication
#
# You have to set two variables COMMONAPI_PATH and FIDL_PATH e.g.:
#
# set(COMMONAPI_PATH ~/git/genivi)
# set(FIDL_PATH ~/git/myproject/fidl)
#
# List of functions for public using:
#    - add_capi_types
#    - add_capi_interfaces
#    - add_capi_library
#    - add_someip_types
#    - add_someip_interfaces
#    - add_someip_library
#
# Examples:
#
# 1) Build static library of your project using CommonAPI-Core
#
#    add_capi_types(MyTarget com.mycom.TypeCollection:1)
#    add_capi_interfaces(MyTarget com.mycom.Interface:1 com.mycom.MyInterface:2)
#    add_capi_library(MyTarget)
#
# 2) Build shared library using CommonAPI-SomeIP
#
#    add_someip_types(MyLibTarget com.mycom.TypeCollection:1)
#    add_someip_interfaces(MyLibTarget com.mycom.Interface:1 com.mycom.MyInterface:2)
#    add_someip_library(MyLibTarget)
#


set(capi-core-gen PATH=$ENV{PATH} ${COMMONAPI_PATH}/capicxx-core-tools/org.genivi.commonapi.core.cli.product/target/products/org.genivi.commonapi.core.cli.product/linux/gtk/x86_64/commonapi-generator-linux-x86_64)
set(capi-someip-gen PATH=$ENV{PATH} ${COMMONAPI_PATH}/capicxx-someip-tools/org.genivi.commonapi.someip.cli.product/target/products/org.genivi.commonapi.someip.cli.product/linux/gtk/x86_64/commonapi-someip-generator-linux-x86_64)

#
# Private functions, they should not be used outside of this file.
#

function(get_interface_path Interface IPath)
    string(FIND ${Interface} ":" DELIMITER_INDEX)
    string(SUBSTRING ${Interface} 0 ${DELIMITER_INDEX} INTERFACE_NAME)
    string(REPLACE "." "/" INTERFACE_PATH ${INTERFACE_NAME})
    set(${IPath} ${INTERFACE_PATH} PARENT_SCOPE)
endfunction(get_interface_path)


function(get_interface_name Interface IName)
    string(FIND ${Interface} ":" DELIMITER_INDEX)
    string(SUBSTRING ${Interface} 0 ${DELIMITER_INDEX} INTERFACE_NAME)
    string(FIND ${INTERFACE_NAME} "." FDEPL_INDEX REVERSE)
    math(EXPR FILE_INDEX ${FDEPL_INDEX}+1)
    string(SUBSTRING ${INTERFACE_NAME} ${FILE_INDEX} -1 FILE_NAME)
    set(${IName} ${FILE_NAME} PARENT_SCOPE)
endfunction(get_interface_name)


function(get_interface_version Interface IVersion)
    string(FIND ${Interface} ":" DELIMITER_INDEX)
    math(EXPR VERSION_INDEX ${DELIMITER_INDEX}+1)
    string(SUBSTRING ${Interface} ${VERSION_INDEX} -1 INTERFACE_VERSION)
    set(${IVersion} ${INTERFACE_VERSION} PARENT_SCOPE)
endfunction(get_interface_version)


function(get_fidl_file Interface FileName)
    get_interface_name(${Interface} INTERFACE_NAME)
    set(${FileName} ${INTERFACE_NAME}.fidl PARENT_SCOPE)
endfunction(get_fidl_file)


function(get_fdepl_file Interface FileName)
    get_interface_name(${Interface} INTERFACE_NAME)
    set(${FileName} ${INTERFACE_NAME}.fdepl PARENT_SCOPE)
endfunction(get_fdepl_file)


function(append_fidl_file Target FileName)
    set(FIDL_LINK ${Target}_FIDL_FILES)
    list(APPEND ${FIDL_LINK} ${FileName})
    set(${FIDL_LINK} ${${FIDL_LINK}} PARENT_SCOPE)
endfunction(append_fidl_file)


function(append_fdepl_file Target FileName)
    set(FDEPL_LINK ${Target}_FDEPL_FILES)
    list(APPEND ${FDEPL_LINK} ${FileName})
    set(${FDEPL_LINK} ${${FDEPL_LINK}} PARENT_SCOPE)
endfunction(append_fdepl_file)


function(append_someip_type_collection Target Path Version)
    set(SOURCE_LINK ${Target}_SOURCE_SOMEIP_FILES)
    list(APPEND ${SOURCE_LINK}
        ${CMAKE_CURRENT_BINARY_DIR}/v${Version}/${Path}SomeIPDeployment.cpp
    )
    set(${SOURCE_LINK} ${${SOURCE_LINK}} PARENT_SCOPE)
endfunction(append_someip_type_collection)


function(append_someip_interface Target Path Version)
    set(SOURCE_LINK ${Target}_SOURCE_SOMEIP_FILES)
    list(APPEND ${SOURCE_LINK}
        ${CMAKE_CURRENT_BINARY_DIR}/v${Version}/${Path}SomeIPStubAdapter.cpp
        ${CMAKE_CURRENT_BINARY_DIR}/v${Version}/${Path}SomeIPDeployment.cpp
        ${CMAKE_CURRENT_BINARY_DIR}/v${Version}/${Path}SomeIPProxy.cpp
    )
    set(${SOURCE_LINK} ${${SOURCE_LINK}} PARENT_SCOPE)
endfunction(append_someip_interface)


function(append_capi_interface Target Path Version)
    set(SOURCE_LINK ${Target}_SOURCE_CAPI_FILES)
    list(APPEND ${SOURCE_LINK}
        ${CMAKE_CURRENT_BINARY_DIR}/v${Version}/${Path}StubDefault.cpp
    )
    set(${SOURCE_LINK} ${${SOURCE_LINK}} PARENT_SCOPE)
endfunction(append_capi_interface)

#
# (End) Private functions, they should not be used outside of this file.
#


#
# Type is formated string:
# <name>[.<name>...]:<major_version>
# For example: ford.rnd.types.VR:1
#

macro(add_someip_types Target Type...)
    set(Types ${ARGV})
    list(REMOVE_AT Types 0)
    message(STATUS "Configure collections of types for SOME/IP - [ ${Types} ]")
    foreach(iface ${Types})
        get_interface_path(${iface} INTERFACE_PATH)
        get_interface_version(${iface} INTERFACE_VERSION)
        append_someip_type_collection(${Target} ${INTERFACE_PATH} ${INTERFACE_VERSION})
        get_fidl_file(${iface} FIDL_FILE)
        append_fidl_file(${Target} ${FIDL_PATH}/${FIDL_FILE})
        get_fdepl_file(${iface} FDEPL_FILE)
        append_fdepl_file(${Target} ${FIDL_PATH}/${FDEPL_FILE})
    endforeach(iface)
endmacro(add_someip_types)


#
# Interface is formated string:
# <name>[.<name>...]:<major_version>
# For example: ford.rnd.VR:1
#

macro(add_someip_interfaces Target Interface...)
    set(Interfaces ${ARGV})
    list(REMOVE_AT Interfaces 0)
    message(STATUS "Configure interfaces for SOME/IP - [ ${Interfaces} ]")
    foreach(iface ${Interfaces})
        get_interface_path(${iface} INTERFACE_PATH)
        get_interface_version(${iface} INTERFACE_VERSION)
        append_someip_interface(${Target} ${INTERFACE_PATH} ${INTERFACE_VERSION})
        get_fidl_file(${iface} FIDL_FILE)
        append_fidl_file(${Target} ${FIDL_PATH}/${FIDL_FILE})
        get_fdepl_file(${iface} FDEPL_FILE)
        append_fdepl_file(${Target} ${FIDL_PATH}/${FDEPL_FILE})
    endforeach(iface)
endmacro(add_someip_interfaces)


function(add_someip_library Target)
    set(SOURCE_LINK ${Target}_SOURCE_SOMEIP_FILES)
    set(FIDL_LINK ${Target}_FIDL_FILES)
    set(FDEPL_LINK ${Target}_FDEPL_FILES)
    add_custom_command(OUTPUT ${${SOURCE_LINK}}
        COMMAND ${capi-core-gen} --printfiles
            --dest ${CMAKE_CURRENT_BINARY_DIR} ${${FIDL_LINK}}
        COMMAND ${capi-someip-gen} --printfiles
            --dest ${CMAKE_CURRENT_BINARY_DIR} ${${FDEPL_LINK}}
        DEPENDS ${${FIDL_LINK}} ${${FDEPL_LINK}}
        COMMENT "Generate source files for ${Target} (SOME/IP) library"
    )
    add_library(${Target} SHARED ${${SOURCE_LINK}})
    target_link_libraries(${Target} CommonAPI-SomeIP)
    message(STATUS "Configure ${Target} (SOME/IP) library")
endfunction(add_someip_library)


#
# Type is formated string:
# <name>[.<name>...]:<major_version>
# For example: ford.rnd.types.VR:1
#

macro(add_capi_types Target Type...)
    set(Types ${ARGV})
    list(REMOVE_AT Types 0)
    message(STATUS "Configure collections of types for CommonAPI - [ ${Types} ]")
    foreach(iface ${Types})
        get_fidl_file(${iface} FIDL_FILE)
        append_fidl_file(${Target} ${FIDL_PATH}/${FIDL_FILE})
    endforeach(iface)
endmacro(add_capi_types)


#
# Interface is formated string:
# <name>[.<name>...]:<major_version>
# For example: ford.rnd.VR:1
#

macro(add_capi_interfaces Target Interface...)
    set(Interfaces ${ARGV})
    list(REMOVE_AT Interfaces 0)
    message(STATUS "Configure interfaces for CommonAPI - [ ${Interfaces} ]")
    foreach(iface ${Interfaces})
        get_interface_path(${iface} INTERFACE_PATH)
        get_interface_version(${iface} INTERFACE_VERSION)
        append_capi_interface(${Target} ${INTERFACE_PATH} ${INTERFACE_VERSION})
        get_fidl_file(${iface} FIDL_FILE)
        append_fidl_file(${Target} ${FIDL_PATH}/${FIDL_FILE})
    endforeach(iface)
endmacro(add_capi_interfaces)


function(add_capi_library Target)
    find_package(CommonAPI 3.1.10 REQUIRED)
    include_directories(
        ${CMAKE_CURRENT_BINARY_DIR}
        ${COMMONAPI_INCLUDE_DIRS}
    )
    set(SOURCE_LINK ${Target}_SOURCE_CAPI_FILES)
    set(FIDL_LINK ${Target}_FIDL_FILES)
    add_custom_command(OUTPUT ${${SOURCE_LINK}}
        COMMAND ${capi-core-gen} --printfiles --skel
            --dest ${CMAKE_CURRENT_BINARY_DIR} ${${FIDL_LINK}}
        DEPENDS ${${FIDL_LINK}}
        COMMENT "Generate source files for ${Target} (CommonAPI) library"
    )
    add_library(${Target} ${${SOURCE_LINK}})
    message(STATUS "Configure ${Target} (CommonAPI) library")
endfunction(add_capi_library)
