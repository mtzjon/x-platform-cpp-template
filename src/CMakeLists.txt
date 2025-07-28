# Source library configuration

# Collect source files
file(GLOB_RECURSE SOURCES
    "*.cpp"
    "*.cxx"
    "*.cc"
)

file(GLOB_RECURSE HEADERS
    "${CMAKE_SOURCE_DIR}/include/*.hpp"
    "${CMAKE_SOURCE_DIR}/include/*.h"
)

# Create the main library
add_project_library(
    NAME cpp_template
    NAMESPACE cpp_template
    SOURCES ${SOURCES}
    HEADERS ${HEADERS}
    INCLUDE_DIRS 
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    LIBRARIES
        fmt::fmt
        spdlog::spdlog
        nlohmann_json::nlohmann_json
        Threads::Threads
)

# Add clang-format and clang-tidy targets
add_clang_format_target()
add_clang_tidy_target()