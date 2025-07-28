# Utility functions for the project

# Function to create a library target
function(add_project_library)
    cmake_parse_arguments(
        ARG
        "STATIC;SHARED;INTERFACE"
        "NAME;NAMESPACE"
        "SOURCES;HEADERS;INCLUDE_DIRS;LIBRARIES;COMPILE_FEATURES;COMPILE_DEFINITIONS"
        ${ARGN}
    )
    
    # Determine library type
    if(ARG_INTERFACE)
        set(LIB_TYPE INTERFACE)
    elseif(ARG_STATIC OR NOT BUILD_SHARED_LIBS)
        set(LIB_TYPE STATIC)
    else()
        set(LIB_TYPE SHARED)
    endif()
    
    # Create the library
    if(ARG_INTERFACE)
        add_library(${ARG_NAME} INTERFACE)
        target_sources(${ARG_NAME} INTERFACE ${ARG_HEADERS})
    else()
        add_library(${ARG_NAME} ${LIB_TYPE} ${ARG_SOURCES} ${ARG_HEADERS})
    endif()
    
    # Add alias
    if(ARG_NAMESPACE)
        add_library(${ARG_NAMESPACE}::${ARG_NAME} ALIAS ${ARG_NAME})
    endif()
    
    # Set properties
    set_target_properties(${ARG_NAME} PROPERTIES
        CXX_STANDARD 20
        CXX_STANDARD_REQUIRED ON
        CXX_EXTENSIONS OFF
        VERSION ${PROJECT_VERSION}
        SOVERSION ${PROJECT_VERSION_MAJOR}
    )
    
    # Include directories
    if(ARG_INCLUDE_DIRS)
        if(ARG_INTERFACE)
            target_include_directories(${ARG_NAME} INTERFACE ${ARG_INCLUDE_DIRS})
        else()
            target_include_directories(${ARG_NAME} PUBLIC ${ARG_INCLUDE_DIRS})
        endif()
    endif()
    
    # Link libraries
    if(ARG_LIBRARIES)
        if(ARG_INTERFACE)
            target_link_libraries(${ARG_NAME} INTERFACE ${ARG_LIBRARIES})
        else()
            target_link_libraries(${ARG_NAME} PUBLIC ${ARG_LIBRARIES})
        endif()
    endif()
    
    # Compile features
    if(ARG_COMPILE_FEATURES)
        if(ARG_INTERFACE)
            target_compile_features(${ARG_NAME} INTERFACE ${ARG_COMPILE_FEATURES})
        else()
            target_compile_features(${ARG_NAME} PUBLIC ${ARG_COMPILE_FEATURES})
        endif()
    endif()
    
    # Compile definitions
    if(ARG_COMPILE_DEFINITIONS)
        if(ARG_INTERFACE)
            target_compile_definitions(${ARG_NAME} INTERFACE ${ARG_COMPILE_DEFINITIONS})
        else()
            target_compile_definitions(${ARG_NAME} PUBLIC ${ARG_COMPILE_DEFINITIONS})
        endif()
    endif()
    
    # Export for find_package
    install(TARGETS ${ARG_NAME}
        EXPORT ${PROJECT_NAME}Targets
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        RUNTIME DESTINATION bin
        INCLUDES DESTINATION include
    )
endfunction()

# Function to create an executable target
function(add_project_executable)
    cmake_parse_arguments(
        ARG
        ""
        "NAME"
        "SOURCES;LIBRARIES;INCLUDE_DIRS;COMPILE_DEFINITIONS"
        ${ARGN}
    )
    
    add_executable(${ARG_NAME} ${ARG_SOURCES})
    
    # Set properties
    set_target_properties(${ARG_NAME} PROPERTIES
        CXX_STANDARD 20
        CXX_STANDARD_REQUIRED ON
        CXX_EXTENSIONS OFF
    )
    
    # Include directories
    if(ARG_INCLUDE_DIRS)
        target_include_directories(${ARG_NAME} PRIVATE ${ARG_INCLUDE_DIRS})
    endif()
    
    # Link libraries
    if(ARG_LIBRARIES)
        target_link_libraries(${ARG_NAME} PRIVATE ${ARG_LIBRARIES})
    endif()
    
    # Compile definitions
    if(ARG_COMPILE_DEFINITIONS)
        target_compile_definitions(${ARG_NAME} PRIVATE ${ARG_COMPILE_DEFINITIONS})
    endif()
    
    # Install
    install(TARGETS ${ARG_NAME}
        RUNTIME DESTINATION bin
    )
endfunction()

# Function to add clang-format target
function(add_clang_format_target)
    find_program(CLANG_FORMAT_EXECUTABLE NAMES clang-format)
    
    if(CLANG_FORMAT_EXECUTABLE)
        file(GLOB_RECURSE ALL_SOURCE_FILES
            ${CMAKE_SOURCE_DIR}/src/*.cpp
            ${CMAKE_SOURCE_DIR}/src/*.hpp
            ${CMAKE_SOURCE_DIR}/include/*.hpp
            ${CMAKE_SOURCE_DIR}/tests/*.cpp
            ${CMAKE_SOURCE_DIR}/tests/*.hpp
            ${CMAKE_SOURCE_DIR}/examples/*.cpp
            ${CMAKE_SOURCE_DIR}/examples/*.hpp
        )
        
        add_custom_target(format
            COMMAND ${CLANG_FORMAT_EXECUTABLE} -i ${ALL_SOURCE_FILES}
            COMMENT "Running clang-format"
        )
        
        add_custom_target(format-check
            COMMAND ${CLANG_FORMAT_EXECUTABLE} --dry-run --Werror ${ALL_SOURCE_FILES}
            COMMENT "Checking clang-format"
        )
    endif()
endfunction()

# Function to add clang-tidy target
function(add_clang_tidy_target)
    find_program(CLANG_TIDY_EXECUTABLE NAMES clang-tidy)
    
    if(CLANG_TIDY_EXECUTABLE)
        set(CMAKE_CXX_CLANG_TIDY ${CLANG_TIDY_EXECUTABLE})
        
        file(GLOB_RECURSE SOURCE_FILES
            ${CMAKE_SOURCE_DIR}/src/*.cpp
            ${CMAKE_SOURCE_DIR}/examples/*.cpp
        )
        
        add_custom_target(tidy
            COMMAND ${CLANG_TIDY_EXECUTABLE} ${SOURCE_FILES} -- -std=c++20
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
            COMMENT "Running clang-tidy"
        )
    endif()
endfunction()