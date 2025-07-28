# C++ Template Project

A comprehensive, production-ready C++ template with modern tooling, cross-platform support, and best practices.

## 🚀 Features

- **Modern C++20** with comprehensive standard library usage
- **Cross-platform** support (Linux, macOS, Windows)
- **CMake** build system with advanced configuration
- **Conan** package manager for dependency management
- **Automated documentation** generation with Doxygen
- **Code formatting** with clang-format
- **Static analysis** with clang-tidy
- **Comprehensive testing** with GoogleTest and benchmarks
- **Continuous Integration** ready with Docker support
- **Library support** for static, shared, and header-only libraries
- **Application support** with configuration management
- **Professional documentation** with custom styling

## 📁 Project Structure

```
cpp_template/
├── cmake/                  # CMake configuration files
│   ├── Conan.cmake        # Conan integration
│   ├── Functions.cmake    # Utility functions
│   ├── Install.cmake      # Installation configuration
│   ├── Packaging.cmake    # CPack configuration
│   └── ProjectConfig.cmake # Project-wide settings
├── docs/                   # Documentation configuration
│   ├── custom.css         # Custom documentation styling
│   ├── header.html        # Documentation header
│   ├── footer.html        # Documentation footer
│   └── CMakeLists.txt     # Documentation build
├── examples/               # Example applications and libraries
│   ├── basic_usage.cpp    # Basic library usage
│   ├── config_example.cpp # Configuration management
│   ├── library_user.cpp   # Multi-library usage
│   └── *_example.*        # Library examples
├── include/                # Public headers
│   └── cpp_template/      # Main library headers
├── src/                    # Source implementation
├── tests/                  # Unit tests and benchmarks
├── .clang-format          # Code formatting configuration
├── .clang-tidy            # Static analysis configuration
├── CMakeLists.txt         # Main CMake configuration
├── conanfile.py           # Conan package configuration
├── Dockerfile             # Multi-stage Docker configuration
└── README.md              # This file
```

## 🛠️ Requirements

### System Dependencies

#### Ubuntu/Debian
```bash
sudo apt update
sudo apt install -y \
    build-essential \
    cmake \
    ninja-build \
    clang-15 \
    clang++-15 \
    clang-tools-15 \
    clang-format-15 \
    clang-tidy-15 \
    python3 \
    python3-pip \
    doxygen \
    graphviz
```

#### macOS
```bash
brew install cmake ninja llvm python3 doxygen graphviz
```

#### Windows (with vcpkg)
```cmd
vcpkg install cmake ninja-build llvm doxygen
```

### Python Dependencies
```bash
pip3 install conan==2.0.14
```

## 🚀 Quick Start

### 1. Clone and Setup
```bash
git clone <your-repository-url> my_project
cd my_project
conan profile detect --force
```

### 2. Build
```bash
mkdir build && cd build
cmake .. -G Ninja
ninja all
```

### 3. Run Tests
```bash
ctest --output-on-failure
```

### 4. Run Examples
```bash
./examples/basic_usage
./examples/config_example
./examples/library_user
```

### 5. Generate Documentation
```bash
ninja docs
# Open build/docs/html/index.html in your browser
```

## 🔧 CMake Options

| Option | Default | Description |
|--------|---------|-------------|
| `BUILD_SHARED_LIBS` | `OFF` | Build shared libraries instead of static |
| `BUILD_TESTS` | `ON` | Build unit tests and benchmarks |
| `BUILD_DOCS` | `ON` | Build documentation with Doxygen |
| `BUILD_EXAMPLES` | `ON` | Build example applications |
| `ENABLE_COVERAGE` | `OFF` | Enable code coverage reporting |
| `ENABLE_SANITIZERS` | `OFF` | Enable AddressSanitizer and UBSan |

### Examples

```bash
# Release build with shared libraries
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON

# Debug build with coverage and sanitizers
cmake .. -DCMAKE_BUILD_TYPE=Debug -DENABLE_COVERAGE=ON -DENABLE_SANITIZERS=ON

# Minimal build without tests and examples
cmake .. -DBUILD_TESTS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_DOCS=OFF
```

## 🐳 Docker Usage

### Development Environment
```bash
# Build development image
docker build --target development -t cpp-template-dev .

# Run interactive development container
docker run -it -v $(pwd):/home/developer/workspace cpp-template-dev
```

### Production Build
```bash
# Build and test
docker build --target testing -t cpp-template-test .

# Build runtime image
docker build --target runtime -t cpp-template-runtime .

# Run application
docker run cpp-template-runtime
```

### Static Analysis
```bash
# Run static analysis
docker build --target analysis -t cpp-template-analysis .
```

## 📚 Creating Libraries

### Static Library
```cpp
// In CMakeLists.txt
add_project_library(
    NAME my_static_lib
    STATIC
    NAMESPACE myproject
    SOURCES src/my_library.cpp
    HEADERS include/my_library.hpp
    INCLUDE_DIRS 
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    LIBRARIES fmt::fmt spdlog::spdlog
)
```

### Shared Library
```cpp
// In CMakeLists.txt
add_project_library(
    NAME my_shared_lib
    SHARED
    NAMESPACE myproject
    SOURCES src/my_library.cpp
    HEADERS include/my_library.hpp
    INCLUDE_DIRS 
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    LIBRARIES fmt::fmt spdlog::spdlog
)
```

### Header-Only Library
```cpp
// In CMakeLists.txt
add_project_library(
    NAME my_header_lib
    INTERFACE
    NAMESPACE myproject
    HEADERS include/my_header_lib.hpp
    INCLUDE_DIRS 
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)
```

## 🖥️ Creating Applications

```cpp
// In CMakeLists.txt
add_project_executable(
    NAME my_application
    SOURCES src/main.cpp src/app.cpp
    LIBRARIES myproject::my_static_lib
    INCLUDE_DIRS include
)
```

## 🔍 Code Quality Tools

### Format Code
```bash
ninja format          # Format all source files
ninja format-check     # Check formatting without modifying
```

### Static Analysis
```bash
ninja tidy            # Run clang-tidy
```

### Testing
```bash
ninja run_tests       # Run unit tests
ninja run_benchmarks  # Run performance benchmarks
```

### Coverage
```bash
# Build with coverage enabled
cmake .. -DENABLE_COVERAGE=ON
ninja coverage        # Generate coverage report
```

## 📖 Documentation

The project uses Doxygen for API documentation with custom styling:

```bash
ninja docs            # Generate HTML documentation
ninja docs-pdf        # Generate PDF documentation (requires LaTeX)
```

Documentation features:
- **Automatic API documentation** from source comments
- **Custom CSS styling** for professional appearance
- **Code examples** and usage guides
- **Cross-references** and search functionality
- **Multiple output formats** (HTML, PDF)

## 🔧 Configuration Management

The template includes a robust configuration system:

```cpp
#include "cpp_template/core.hpp"

// Load configuration from file
cpp_template::Config::load_from_file("config.json");

// Get configuration values with defaults
auto host = cpp_template::Config::get<std::string>("database.host", "localhost");
auto port = cpp_template::Config::get<int>("database.port", 5432);
auto debug = cpp_template::Config::get<bool>("debug_mode", false);

// Set runtime configuration
cpp_template::Config::set<std::string>("runtime.user", "admin");
```

## 🚀 Deployment

### Package Creation
```bash
ninja package         # Create platform-specific packages
```

Supported package formats:
- **Linux**: DEB, RPM, TGZ
- **macOS**: DragNDrop, TGZ
- **Windows**: NSIS, ZIP

### Installation
```bash
ninja install         # Install to system
```

## 🤝 Contributing

1. **Code Style**: Follow the clang-format configuration
2. **Documentation**: Document all public APIs with Doxygen comments
3. **Testing**: Add tests for new functionality
4. **Static Analysis**: Ensure clang-tidy passes without warnings

### Development Workflow
```bash
# Format code
ninja format

# Run static analysis
ninja tidy

# Build and test
ninja all
ninja run_tests

# Check coverage
ninja coverage
```

## 📋 Dependencies

The project uses modern, well-maintained C++ libraries:

- **[fmt](https://github.com/fmtlib/fmt)**: Modern string formatting
- **[spdlog](https://github.com/gabime/spdlog)**: Fast logging library
- **[nlohmann/json](https://github.com/nlohmann/json)**: JSON for Modern C++
- **[GoogleTest](https://github.com/google/googletest)**: Testing framework
- **[Google Benchmark](https://github.com/google/benchmark)**: Microbenchmark library

All dependencies are managed through Conan for reliable, reproducible builds.

## 🏗️ Architecture

The template follows modern C++ best practices:

- **RAII** for resource management
- **Rule of Five** for proper copy/move semantics
- **Template metaprogramming** with SFINAE and concepts
- **Modern CMake** with target-based configuration
- **Modular design** with clear separation of concerns
- **Exception safety** with strong guarantees
- **Thread safety** where applicable

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙋‍♂️ Support

For questions, issues, or contributions:

1. **Issues**: Use the GitHub issue tracker
2. **Discussions**: Use GitHub discussions for questions
3. **Contributing**: See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines

---

**Happy Coding!** 🎉