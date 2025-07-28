# VS Code Dev Container Setup

This project includes a complete VS Code Dev Container configuration for a consistent, productive C++ development environment.

## 🚀 Quick Start

### Prerequisites

1. **VS Code** with the [Remote-Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
2. **Docker Desktop** or Docker Engine
3. **Git** (for cloning the repository)

### Getting Started

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd cpp_template
   ```

2. **Open in VS Code**:
   ```bash
   code .
   ```

3. **Open in Container**:
   - VS Code will detect the `.devcontainer` configuration
   - Click "Reopen in Container" in the notification
   - Or use Command Palette: `Remote-Containers: Reopen in Container`

4. **Wait for setup** (first time only):
   - Container builds automatically
   - Extensions are installed
   - Development environment is configured

## 🛠️ What's Included

### Development Environment

- **Ubuntu 22.04** base image
- **Clang 14** compiler toolchain
- **CMake** and **Ninja** build system
- **Conan** package manager
- **Python 3** with development tools

### Pre-installed Tools

- **Build Tools**: cmake, ninja, make
- **Compilers**: clang-14, clang++-14, gcc, g++
- **Code Quality**: clang-format-14, clang-tidy-14
- **Documentation**: doxygen, graphviz
- **Debugging**: gdb, valgrind
- **Version Control**: git
- **Utilities**: curl, wget, unzip

### VS Code Extensions

The container automatically installs essential extensions:

#### Core C++ Development
- **C/C++** (`ms-vscode.cpptools`) - IntelliSense, debugging, code browsing
- **C/C++ Extension Pack** (`ms-vscode.cpptools-extension-pack`) - Complete C++ support
- **CMake Tools** (`ms-vscode.cmake-tools`) - CMake integration
- **CMake** (`twxs.cmake`) - CMake syntax highlighting

#### Code Quality
- **Clang-Format** (`xaver.clang-format`) - Code formatting
- **Clang-Tidy** (`notskm.clang-tidy`) - Static analysis
- **ClangD** (`llvm-vs-code-extensions.vscode-clangd`) - Alternative language server

#### Testing & Debugging
- **Test Adapter** (`matepek.vscode-catch2-test-adapter`) - Test discovery and running
- **LLDB** (`vadimcn.vscode-lldb`) - Advanced debugging

#### Documentation
- **Doxygen** (`cschlosser.doxdocgen`) - Documentation generation
- **Docs View** (`bierner.docs-view`) - Documentation preview

#### Productivity
- **GitLens** (`eamodio.gitlens`) - Git supercharged
- **TODO Tree** (`gruntfuggly.todo-tree`) - TODO/FIXME highlighting
- **Better Comments** (`aaron-bond.better-comments`) - Enhanced comments
- **Error Lens** (`usernamehw.errorlens`) - Inline error display

## 📋 Pre-configured Tasks

Access via Command Palette (`Ctrl+Shift+P`) → `Tasks: Run Task`:

### Build Tasks
- **🔨 Configure CMake** - Set up build configuration
- **🏗️ Build All** - Build entire project (default)
- **🏗️ Build Tests** - Build only test executables
- **🏗️ Build Examples** - Build only example applications

### Test Tasks
- **🧪 Run All Tests** - Execute all unit tests (default)
- **🧪 Run Tests (Verbose)** - Run tests with detailed output
- **⚡ Run Benchmarks** - Execute performance benchmarks

### Code Quality
- **🎨 Format Code** - Auto-format all source files
- **🔍 Check Formatting** - Validate code formatting
- **🔎 Run Static Analysis** - Execute clang-tidy checks

### Documentation
- **📚 Generate Documentation** - Build Doxygen docs
- **🌐 Serve Documentation** - Serve docs at http://localhost:8080

### Examples
- **🚀 Run Basic Example** - Execute basic usage demo
- **⚙️ Run Config Example** - Run configuration demo
- **📚 Run Library Example** - Test library integration

### Package Management
- **📦 Install Dependencies** - Install Conan packages
- **🔄 Update Dependencies** - Update all dependencies

### Cleanup
- **🧹 Clean Build** - Remove build directory
- **🧹 Clean All** - Full cleanup

## 🐛 Debug Configurations

Access via Debug panel (`Ctrl+Shift+D`):

### Application Debugging
- **🚀 Debug Basic Usage** - Debug main example
- **⚙️ Debug Config Example** - Debug configuration example
- **📚 Debug Library User** - Debug library usage

### Test Debugging
- **🧪 Debug Unit Tests** - Debug all tests
- **🧪 Debug Specific Test** - Debug filtered tests
- **⚡ Debug Benchmarks** - Debug performance tests

### Advanced Debugging
- **🔍 Debug with Valgrind** - Memory leak detection
- **🛡️ Debug with AddressSanitizer** - Address sanitizer
- **🔗 Attach to Process** - Attach to running process
- **🐳 Debug in Docker Container** - Remote container debugging
- **🔧 Debug with LLDB** - Alternative debugger

## ⚡ Quick Actions

### Keyboard Shortcuts

| Action | Shortcut | Description |
|--------|----------|-------------|
| Build | `Ctrl+Shift+P` → `Tasks: Run Build Task` | Build project |
| Test | `Ctrl+Shift+P` → `Tasks: Run Test Task` | Run tests |
| Debug | `F5` | Start debugging |
| Format | `Shift+Alt+F` | Format current file |
| Command Palette | `Ctrl+Shift+P` | Access all commands |

### CMake Integration

- **Configure**: Automatically detects CMake project
- **Build**: Integrated with VS Code build system
- **Debug**: Launch configurations use CMake targets
- **IntelliSense**: Uses CMake compile commands

## 🔧 Configuration

### Container Customization

The dev container configuration is in `.devcontainer/devcontainer.json`:

```json
{
    "name": "C++ Template Development",
    "dockerComposeFile": "../docker-compose.yml",
    "service": "dev",
    "workspaceFolder": "/home/developer/workspace"
}
```

### Environment Variables

Pre-configured in the container:

```bash
CC=clang-14
CXX=clang++-14
CMAKE_GENERATOR=Ninja
CONAN_USER_HOME=/home/developer
```

### Port Forwarding

Automatically forwards these ports:

- **8080**: Documentation server
- **3000**: Development server
- **9090**: Debug port

### Volume Mounts

- **SSH keys**: `~/.ssh` (read-only)
- **Git config**: `~/.gitconfig` (read-only)
- **Conan cache**: Persistent volume
- **Build artifacts**: Persistent volume

## 🔍 Troubleshooting

### Common Issues

#### Container Build Fails
```bash
# Rebuild container from scratch
docker system prune -a
# Reopen in VS Code
```

#### Extensions Not Loading
- Check `.devcontainer/devcontainer.json` configuration
- Reload window: `Ctrl+Shift+P` → `Developer: Reload Window`

#### CMake Configuration Issues
- Run: `Tasks: Run Task` → `🔨 Configure CMake`
- Check CMake output in terminal

#### IntelliSense Not Working
- Ensure `compile_commands.json` exists in build directory
- Reload C++ configuration: `Ctrl+Shift+P` → `C/C++: Reload IntelliSense Configuration`

#### Git Authentication
- SSH keys are mounted from host
- For HTTPS, configure Git credentials in container:
  ```bash
  git config --global user.name "Your Name"
  git config --global user.email "your.email@example.com"
  ```

### Performance Optimization

#### Faster Builds
- Use `ninja` generator (default)
- Enable parallel builds in tasks
- Consider using `ccache` for large projects

#### Improved IntelliSense
- Keep `compile_commands.json` updated
- Exclude build directories from VS Code indexing
- Use `.vscode/settings.json` optimizations

## 🌐 Network Configuration

### Accessing Services

When running services in the container:

```bash
# Documentation server (automatically forwarded)
http://localhost:8080

# Custom development server
python3 -m http.server 3000
# Access at http://localhost:3000
```

### Docker Network

The dev container is part of the project's Docker Compose network, enabling:

- Communication with other services
- Shared volumes and configurations
- Consistent networking across environments

## 📚 Learning Resources

### VS Code Remote Development
- [Remote-Containers Tutorial](https://code.visualstudio.com/docs/remote/containers-tutorial)
- [Dev Container Specification](https://containers.dev/)

### C++ in VS Code
- [C++ Programming in VS Code](https://code.visualstudio.com/docs/languages/cpp)
- [CMake Tools Documentation](https://vector-of-bool.github.io/docs/vscode-cmake-tools/)

### Debugging
- [Debugging in VS Code](https://code.visualstudio.com/docs/editor/debugging)
- [C++ Debugging Guide](https://code.visualstudio.com/docs/cpp/cpp-debug)

## 🔄 Updates and Maintenance

### Updating the Container

1. **Modify** `.devcontainer/devcontainer.json` or `Dockerfile`
2. **Rebuild**: `Ctrl+Shift+P` → `Remote-Containers: Rebuild Container`
3. **Test**: Verify all functionality works

### Extension Updates

Extensions are automatically updated when:
- Container is rebuilt
- VS Code is restarted
- Manual update via Extensions panel

### Tool Versions

To update tools (clang, cmake, etc.):
1. Modify `Dockerfile` or `docker-compose.yml`
2. Update `.devcontainer/devcontainer.json` if needed
3. Rebuild container

## 🎯 Best Practices

### Development Workflow

1. **Start** with clean container
2. **Configure** CMake automatically
3. **Build** incrementally
4. **Test** frequently
5. **Debug** as needed
6. **Format** before committing
7. **Analyze** with static tools

### Code Organization

- Use the provided tasks for common operations
- Leverage IntelliSense for navigation
- Take advantage of integrated debugging
- Use Git integration for version control

### Performance Tips

- Keep build directories clean
- Use ninja for faster builds
- Leverage parallel compilation
- Monitor container resource usage

This dev container setup provides a complete, professional C++ development environment with minimal setup required. It ensures consistency across team members and eliminates "works on my machine" issues.