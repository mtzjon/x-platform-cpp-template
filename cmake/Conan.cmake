# Conan integration

# Check if conan is available
find_program(CONAN_CMD conan)
if(NOT CONAN_CMD)
    message(FATAL_ERROR "Conan is required but not found. Please install conan: pip install conan")
endif()

# Auto-detect conan profile if not exists
execute_process(
    COMMAND ${CONAN_CMD} profile detect --force
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    RESULT_VARIABLE CONAN_PROFILE_RESULT
    OUTPUT_QUIET
)

# Check if we need to install dependencies
if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan_toolchain.cmake")
    message(STATUS "Installing Conan dependencies...")
    
    # Build string for conan install
    set(CONAN_BUILD_TYPE ${CMAKE_BUILD_TYPE})
    if(BUILD_SHARED_LIBS)
        set(CONAN_SHARED "True")
    else()
        set(CONAN_SHARED "False")
    endif()
    
    # Run conan install
    execute_process(
        COMMAND ${CONAN_CMD} install . 
            --output-folder=${CMAKE_BINARY_DIR}
            --build=missing
            -s build_type=${CONAN_BUILD_TYPE}
            -o shared=${CONAN_SHARED}
            -o with_tests=${BUILD_TESTS}
            -o with_docs=${BUILD_DOCS}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        RESULT_VARIABLE CONAN_INSTALL_RESULT
    )
    
    if(NOT CONAN_INSTALL_RESULT EQUAL 0)
        message(FATAL_ERROR "Conan install failed")
    endif()
endif()

# Include conan-generated files
include(${CMAKE_BINARY_DIR}/conan_toolchain.cmake)
find_package(fmt REQUIRED)
find_package(spdlog REQUIRED)
find_package(nlohmann_json REQUIRED)

if(BUILD_TESTS)
    find_package(GTest REQUIRED)
    find_package(benchmark REQUIRED)
endif()