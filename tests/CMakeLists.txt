# Tests configuration

# Collect test files
file(GLOB_RECURSE TEST_SOURCES
    "test_*.cpp"
    "*_test.cpp"
)

file(GLOB_RECURSE BENCHMARK_SOURCES
    "benchmark_*.cpp"
    "*_benchmark.cpp"
)

# Unit tests
if(TEST_SOURCES)
    add_executable(cpp_template_tests ${TEST_SOURCES})
    
    target_link_libraries(cpp_template_tests
        PRIVATE
        cpp_template::cpp_template
        GTest::gtest
        GTest::gtest_main
        GTest::gmock
    )
    
    target_include_directories(cpp_template_tests
        PRIVATE
        ${CMAKE_SOURCE_DIR}/include
    )
    
    set_target_properties(cpp_template_tests PROPERTIES
        CXX_STANDARD 20
        CXX_STANDARD_REQUIRED ON
    )
    
    # Add tests to CTest
    include(GoogleTest)
    gtest_discover_tests(cpp_template_tests)
    
    # Custom test target
    add_custom_target(run_tests
        COMMAND cpp_template_tests
        DEPENDS cpp_template_tests
        COMMENT "Running unit tests"
    )
endif()

# Benchmarks
if(BENCHMARK_SOURCES)
    add_executable(cpp_template_benchmarks ${BENCHMARK_SOURCES})
    
    target_link_libraries(cpp_template_benchmarks
        PRIVATE
        cpp_template::cpp_template
        benchmark::benchmark
        benchmark::benchmark_main
    )
    
    target_include_directories(cpp_template_benchmarks
        PRIVATE
        ${CMAKE_SOURCE_DIR}/include
    )
    
    set_target_properties(cpp_template_benchmarks PROPERTIES
        CXX_STANDARD 20
        CXX_STANDARD_REQUIRED ON
    )
    
    # Custom benchmark target
    add_custom_target(run_benchmarks
        COMMAND cpp_template_benchmarks
        DEPENDS cpp_template_benchmarks
        COMMENT "Running benchmarks"
    )
endif()

# Coverage target
if(ENABLE_COVERAGE AND NOT MSVC)
    find_program(GCOV_EXECUTABLE gcov)
    find_program(LCOV_EXECUTABLE lcov)
    find_program(GENHTML_EXECUTABLE genhtml)
    
    if(GCOV_EXECUTABLE AND LCOV_EXECUTABLE AND GENHTML_EXECUTABLE)
        add_custom_target(coverage
            COMMAND ${LCOV_EXECUTABLE} --directory . --capture --output-file coverage.info
            COMMAND ${LCOV_EXECUTABLE} --remove coverage.info '*/tests/*' '*/examples/*' '/usr/*' --output-file coverage.info
            COMMAND ${GENHTML_EXECUTABLE} coverage.info --output-directory coverage_html
            DEPENDS cpp_template_tests
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
            COMMENT "Generating code coverage report"
        )
    endif()
endif()