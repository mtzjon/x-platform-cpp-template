#!/bin/bash

# Setup script for C++ Template Project
# This script checks the environment and installs necessary dependencies

set -e

echo "🚀 Setting up C++ Template Project environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check operating system
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        if command -v apt-get >/dev/null 2>&1; then
            DISTRO="debian"
        elif command -v yum >/dev/null 2>&1; then
            DISTRO="rhel"
        elif command -v pacman >/dev/null 2>&1; then
            DISTRO="arch"
        else
            DISTRO="unknown"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        DISTRO="macos"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
        DISTRO="windows"
    else
        OS="unknown"
        DISTRO="unknown"
    fi
    
    print_status "Detected OS: $OS ($DISTRO)"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required tools
check_dependencies() {
    print_status "Checking for required dependencies..."
    
    local missing_deps=()
    
    # Check for essential build tools
    if ! command_exists cmake; then
        missing_deps+=("cmake")
    else
        CMAKE_VERSION=$(cmake --version | head -n1 | sed 's/.*version //' | cut -d' ' -f1)
        print_success "CMake found: $CMAKE_VERSION"
    fi
    
    if ! command_exists ninja; then
        missing_deps+=("ninja")
    else
        print_success "Ninja found: $(ninja --version)"
    fi
    
    # Check for C++ compiler
    if ! command_exists clang++; then
        if ! command_exists g++; then
            missing_deps+=("clang++ or g++")
        else
            print_success "G++ found: $(g++ --version | head -n1)"
        fi
    else
        print_success "Clang++ found: $(clang++ --version | head -n1)"
    fi
    
    # Check for Python
    if ! command_exists python3; then
        missing_deps+=("python3")
    else
        PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
        print_success "Python3 found: $PYTHON_VERSION"
    fi
    
    # Check for Git
    if ! command_exists git; then
        missing_deps+=("git")
    else
        print_success "Git found: $(git --version | cut -d' ' -f3)"
    fi
    
    # Check for optional tools
    if command_exists clang-format; then
        print_success "clang-format found: $(clang-format --version | head -n1)"
    else
        print_warning "clang-format not found (optional for code formatting)"
    fi
    
    if command_exists clang-tidy; then
        print_success "clang-tidy found"
    else
        print_warning "clang-tidy not found (optional for static analysis)"
    fi
    
    if command_exists doxygen; then
        print_success "Doxygen found: $(doxygen --version)"
    else
        print_warning "Doxygen not found (optional for documentation)"
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        return 1
    fi
    
    return 0
}

# Install dependencies based on OS
install_dependencies() {
    print_status "Installing missing dependencies..."
    
    case "$DISTRO" in
        "debian")
            print_status "Installing dependencies using apt..."
            sudo apt-get update
            # Clean up potential package conflicts
            sudo apt-get autoremove -y || true
            sudo apt-get install -y \
                build-essential \
                cmake \
                ninja-build \
                clang-14 \
                clang++-14 \
                clang-format-14 \
                clang-tidy-14 \
                python3 \
                python3-pip \
                python3-venv \
                git \
                doxygen \
                graphviz \
                lcov \
                gcovr
            # Create symlinks for generic tool names
            sudo ln -sf /usr/bin/clang-14 /usr/bin/clang || true
            sudo ln -sf /usr/bin/clang++-14 /usr/bin/clang++ || true
            sudo ln -sf /usr/bin/clang-format-14 /usr/bin/clang-format || true
            sudo ln -sf /usr/bin/clang-tidy-14 /usr/bin/clang-tidy || true
            ;;
        "rhel")
            print_status "Installing dependencies using yum/dnf..."
            if command_exists dnf; then
                PKG_CMD="dnf"
            else
                PKG_CMD="yum"
            fi
            sudo $PKG_CMD install -y \
                gcc-c++ \
                cmake \
                ninja-build \
                clang \
                clang-tools-extra \
                python3 \
                python3-pip \
                git \
                doxygen \
                graphviz
            ;;
        "arch")
            print_status "Installing dependencies using pacman..."
            sudo pacman -S --noconfirm \
                base-devel \
                cmake \
                ninja \
                clang \
                python \
                python-pip \
                git \
                doxygen \
                graphviz
            ;;
        "macos")
            if command_exists brew; then
                print_status "Installing dependencies using Homebrew..."
                brew install cmake ninja llvm python3 git doxygen graphviz
            else
                print_error "Homebrew not found. Please install Homebrew first:"
                print_error "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
                return 1
            fi
            ;;
        "windows")
            print_warning "Windows detected. Please install dependencies manually:"
            print_warning "  - Install Visual Studio 2022 with C++ support"
            print_warning "  - Install CMake from https://cmake.org/"
            print_warning "  - Install Git from https://git-scm.com/"
            print_warning "  - Install Python from https://python.org/"
            print_warning "  - Or use vcpkg/Chocolatey for package management"
            return 1
            ;;
        *)
            print_error "Unsupported distribution: $DISTRO"
            print_error "Please install dependencies manually"
            return 1
            ;;
    esac
}

# Setup Python virtual environment and install Conan
setup_python_env() {
    print_status "Setting up Python environment..."
    
    # Check if we're already in a virtual environment
    if [[ "$VIRTUAL_ENV" != "" ]]; then
        print_status "Already in virtual environment: $VIRTUAL_ENV"
    else
        if [ ! -d "venv" ]; then
            print_status "Creating Python virtual environment..."
            python3 -m venv venv
        fi
        print_status "Activating virtual environment..."
        source venv/bin/activate
    fi
    
    print_status "Installing/upgrading pip..."
    python -m pip install --upgrade pip
    
    print_status "Installing Conan..."
    pip install conan==2.0.14
    
    print_status "Detecting Conan profile..."
    conan profile detect --force
    
    print_success "Python environment setup complete!"
}

# Test clang-format configuration
test_clang_format() {
    print_status "Testing clang-format configuration..."
    
    if command_exists clang-format; then
        # Create a test file
        TEST_FILE="test_format.cpp"
        cat > "$TEST_FILE" << 'EOF'
#include<iostream>
#include <vector>
int main(){
std::vector<int>numbers{1,2,3};
for(auto&num:numbers){
std::cout<<num<<std::endl;
}
return 0;
}
EOF
        
        # Test main config
        if clang-format "$TEST_FILE" >/dev/null 2>&1; then
            print_success "Main .clang-format configuration works!"
        else
            print_warning "Main .clang-format configuration failed, but compatible version is available"
        fi
        
        # Clean up
        rm -f "$TEST_FILE"
    fi
}

# Main setup function
main() {
    echo "=================================================="
    echo "  C++ Template Project Environment Setup"
    echo "=================================================="
    echo
    
    detect_os
    
    if ! check_dependencies; then
        print_status "Some dependencies are missing. Attempting to install..."
        if ! install_dependencies; then
            print_error "Failed to install dependencies automatically."
            print_error "Please install them manually and run this script again."
            exit 1
        fi
        
        # Check again after installation
        if ! check_dependencies; then
            print_error "Dependencies still missing after installation attempt."
            exit 1
        fi
    fi
    
    setup_python_env
    test_clang_format
    
    echo
    print_success "✅ Environment setup complete!"
    echo
    print_status "Next steps:"
    echo "  1. Build the project:     make build"
    echo "  2. Run tests:            make test"
    echo "  3. Generate docs:        make docs"
    echo "  4. Format code:          make format"
    echo "  5. Run static analysis:  make lint"
    echo
    print_status "For Docker users:"
    echo "  - Development:           make docker-dev"
    echo "  - Build and test:        make docker-test"
    echo
    print_status "See 'make help' for all available commands."
}

# Run main function
main "$@"