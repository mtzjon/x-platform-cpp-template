# Project-wide configuration

# Compiler-specific options
if(MSVC)
    add_compile_options(/W4)
    if(ENABLE_COVERAGE)
        message(WARNING "Code coverage is not supported on MSVC")
    endif()
else()
    add_compile_options(
        -Wall -Wextra -Wpedantic
        -Wcast-align -Wcast-qual -Wctor-dtor-privacy
        -Wdisabled-optimization -Wformat=2 -Winit-self
        -Wlogical-op -Wmissing-declarations -Wmissing-include-dirs
        -Wnoexcept -Wold-style-cast -Woverloaded-virtual
        -Wredundant-decls -Wshadow -Wsign-conversion -Wsign-promo
        -Wstrict-null-sentinel -Wstrict-overflow=5 -Wswitch-default
        -Wundef -Wno-unused
    )
    
    if(ENABLE_COVERAGE)
        add_compile_options(--coverage -O0 -g)
        add_link_options(--coverage)
    endif()
    
    if(ENABLE_SANITIZERS)
        add_compile_options(-fsanitize=address,undefined -fno-sanitize-recover=all)
        add_link_options(-fsanitize=address,undefined)
    endif()
endif()

# Release-specific optimizations
if(CMAKE_BUILD_TYPE STREQUAL "Release")
    add_compile_definitions(NDEBUG)
    if(NOT MSVC)
        add_compile_options(-O3 -flto)
        add_link_options(-flto)
    endif()
endif()

# Debug-specific settings
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_compile_definitions(DEBUG)
    if(NOT MSVC)
        add_compile_options(-O0 -g3)
    endif()
endif()

# Platform-specific definitions
if(WIN32)
    add_compile_definitions(
        WIN32_LEAN_AND_MEAN
        NOMINMAX
        _CRT_SECURE_NO_WARNINGS
    )
endif()

# Set RPATH for Linux/macOS
if(UNIX AND NOT APPLE)
    set(CMAKE_INSTALL_RPATH "$ORIGIN/../lib")
elseif(APPLE)
    set(CMAKE_INSTALL_RPATH "@loader_path/../lib")
endif()
set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

# Position independent code
set(CMAKE_POSITION_INDEPENDENT_CODE ON)