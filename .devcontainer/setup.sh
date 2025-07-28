#!/bin/bash

# Dev Container Setup Script
# Handles permissions, environment setup, and tool configuration

set -e

echo "🚀 Setting up development environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Function to fix permissions
fix_permissions() {
    print_status "Fixing workspace permissions..."
    
    # Ensure the developer user owns the workspace
    if [ -d "/home/developer/workspace" ]; then
        sudo chown -R developer:developer /home/developer/workspace
        sudo chmod -R 755 /home/developer/workspace
        print_success "Workspace permissions fixed"
    fi
    
    # Ensure the developer user owns their home directory
    sudo chown -R developer:developer /home/developer
    print_success "Home directory permissions fixed"
    
    # Make sure the developer user can write to common directories
    sudo mkdir -p /home/developer/.conan2 /home/developer/.cache
    sudo chown -R developer:developer /home/developer/.conan2 /home/developer/.cache
}

# Function to setup Conan
setup_conan() {
    print_status "Setting up Conan package manager..."
    
    # Create Conan profile
    if ! conan profile show default >/dev/null 2>&1; then
        conan profile detect --force
        print_success "Conan profile created"
    else
        print_success "Conan profile already exists"
    fi
    
    # Verify Conan works
    if conan --version >/dev/null 2>&1; then
        print_success "Conan is working correctly"
    else
        print_error "Conan setup failed"
        return 1
    fi
}

# Function to setup Git
setup_git() {
    print_status "Configuring Git..."
    
    # Add workspace to Git safe directories
    git config --global --add safe.directory /home/developer/workspace
    
    # Set default Git configuration if not already set
    if [ -z "$(git config --global user.name 2>/dev/null)" ]; then
        print_warning "Git user.name not set. Configure with: git config --global user.name 'Your Name'"
    fi
    
    if [ -z "$(git config --global user.email 2>/dev/null)" ]; then
        print_warning "Git user.email not set. Configure with: git config --global user.email 'your.email@example.com'"
    fi
    
    print_success "Git configuration completed"
}

# Function to verify tools
verify_tools() {
    print_status "Verifying development tools..."
    
    local tools=(
        "clang++ --version"
        "cmake --version"
        "ninja --version"
        "conan --version"
        "clang-format --version"
        "clang-tidy --version"
        "doxygen --version"
        "gdb --version"
    )
    
    local failed_tools=()
    
    for tool_cmd in "${tools[@]}"; do
        tool_name=$(echo "$tool_cmd" | cut -d' ' -f1)
        if $tool_cmd >/dev/null 2>&1; then
            print_success "$tool_name is available"
        else
            print_error "$tool_name is not available"
            failed_tools+=("$tool_name")
        fi
    done
    
    if [ ${#failed_tools[@]} -eq 0 ]; then
        print_success "All development tools are available"
    else
        print_warning "Some tools are missing: ${failed_tools[*]}"
    fi
}

# Function to create initial build directory
setup_build_directory() {
    print_status "Setting up build directory..."
    
    if [ ! -d "/home/developer/workspace/build" ]; then
        mkdir -p /home/developer/workspace/build
        print_success "Build directory created"
    else
        print_success "Build directory already exists"
    fi
    
    # Ensure proper ownership
    chown -R developer:developer /home/developer/workspace/build 2>/dev/null || true
}

# Function to setup VS Code specific configurations
setup_vscode() {
    print_status "Setting up VS Code configurations..."
    
    # Ensure .vscode directory exists with proper permissions
    mkdir -p /home/developer/workspace/.vscode
    chown -R developer:developer /home/developer/workspace/.vscode 2>/dev/null || true
    
    print_success "VS Code configuration ready"
}

# Main setup function
main() {
    print_status "Starting dev container setup..."
    
    # Run setup functions
    fix_permissions
    setup_conan
    setup_git
    setup_build_directory
    setup_vscode
    verify_tools
    
    print_success "🎉 Development environment setup completed!"
    
    # Print helpful information
    echo ""
    echo "📋 Quick Start Commands:"
    echo "  Build project:   cmake --build build --parallel"
    echo "  Run tests:       ctest --test-dir build --output-on-failure"
    echo "  Format code:     make format"
    echo "  Generate docs:   make docs"
    echo ""
    echo "🔧 VS Code Tasks:"
    echo "  Press Ctrl+Shift+P and type 'Tasks: Run Task' to see all available tasks"
    echo ""
    echo "🐛 Debugging:"
    echo "  Press F5 to start debugging or use the Debug panel"
    echo ""
    print_success "Happy coding! 🚀"
}

# Run main function
main "$@"