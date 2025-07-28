# Examples configuration

# Basic usage example
add_project_executable(
    NAME basic_usage
    SOURCES basic_usage.cpp
    LIBRARIES cpp_template::cpp_template
    INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/include
)

# Configuration example
add_project_executable(
    NAME config_example
    SOURCES config_example.cpp
    LIBRARIES cpp_template::cpp_template
    INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/include
)

# Library creation examples
add_project_library(
    NAME example_static_lib
    STATIC
    NAMESPACE examples
    SOURCES static_lib_example.cpp
    HEADERS static_lib_example.hpp
    INCLUDE_DIRS 
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include/examples>
    LIBRARIES cpp_template::cpp_template
)

add_project_library(
    NAME example_shared_lib
    SHARED
    NAMESPACE examples
    SOURCES shared_lib_example.cpp
    HEADERS shared_lib_example.hpp
    INCLUDE_DIRS 
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include/examples>
    LIBRARIES cpp_template::cpp_template
)

# Interface library example
add_project_library(
    NAME example_interface_lib
    INTERFACE
    NAMESPACE examples
    HEADERS interface_lib_example.hpp
    INCLUDE_DIRS 
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include/examples>
)

# Application using the example libraries
add_project_executable(
    NAME library_user
    SOURCES library_user.cpp
    LIBRARIES 
        examples::example_static_lib
        examples::example_shared_lib
        examples::example_interface_lib
)

# Install example headers
install(FILES
    static_lib_example.hpp
    shared_lib_example.hpp
    interface_lib_example.hpp
    DESTINATION include/examples
)