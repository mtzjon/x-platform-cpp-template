# Convenience Makefile for C++ Template Project
# This provides easy-to-remember commands for common development tasks

.PHONY: help build clean test format lint docs docker install package coverage

# Default target
help:
	@echo "C++ Template Project - Available Commands:"
	@echo ""
	@echo "Building:"
	@echo "  build          - Build the project in Release mode"
	@echo "  build-debug    - Build the project in Debug mode"
	@echo "  build-shared   - Build with shared libraries"
	@echo "  clean          - Clean build directory"
	@echo ""
	@echo "Testing:"
	@echo "  test           - Run all tests"
	@echo "  test-verbose   - Run tests with verbose output"
	@echo "  benchmark      - Run performance benchmarks"
	@echo "  coverage       - Generate code coverage report"
	@echo ""
	@echo "Code Quality:"
	@echo "  format         - Format all source code"
	@echo "  format-check   - Check code formatting"
	@echo "  lint           - Run static analysis"
	@echo ""
	@echo "Documentation:"
	@echo "  docs           - Generate documentation"
	@echo "  docs-serve     - Serve documentation locally"
	@echo ""
	@echo "Docker:"
	@echo "  docker-dev     - Build and run development container"
	@echo "  docker-test    - Run tests in container"
	@echo "  docker-build   - Build all Docker images"
	@echo ""
	@echo "Packaging:"
	@echo "  install        - Install to system"
	@echo "  package        - Create distribution packages"
	@echo ""
	@echo "Utilities:"
	@echo "  setup          - Initial setup (install dependencies)"
	@echo "  examples       - Run all examples"

# Build commands
build:
	@echo "Building project in Release mode..."
	@mkdir -p build
	@cd build && cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release
	@cd build && ninja

build-debug:
	@echo "Building project in Debug mode..."
	@mkdir -p build
	@cd build && cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Debug
	@cd build && ninja

build-shared:
	@echo "Building project with shared libraries..."
	@mkdir -p build
	@cd build && cmake .. -G Ninja -DBUILD_SHARED_LIBS=ON
	@cd build && ninja

clean:
	@echo "Cleaning build directory..."
	@rm -rf build

# Testing commands
test: build
	@echo "Running tests..."
	@cd build && ctest --output-on-failure

test-verbose: build
	@echo "Running tests with verbose output..."
	@cd build && ctest --output-on-failure --verbose

benchmark: build
	@echo "Running benchmarks..."
	@cd build && ./tests/cpp_template_benchmarks

coverage:
	@echo "Building with coverage and running tests..."
	@mkdir -p build
	@cd build && cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Debug -DENABLE_COVERAGE=ON
	@cd build && ninja
	@cd build && ctest --output-on-failure
	@cd build && ninja coverage
	@echo "Coverage report generated in build/coverage_html/"

# Code quality commands
format:
	@echo "Formatting code..."
	@if ! find src include examples tests -name "*.cpp" -o -name "*.hpp" | xargs clang-format -i 2>/dev/null; then \
		echo "Main .clang-format failed, using compatible version..."; \
		find src include examples tests -name "*.cpp" -o -name "*.hpp" | xargs clang-format --style=file:.clang-format-compat -i; \
	fi

format-check:
	@echo "Checking code formatting..."
	@python3 scripts/validate_formatting.py

format-check-clang:
	@echo "Checking code formatting with clang-format..."
	@if ! find src include examples tests -name "*.cpp" -o -name "*.hpp" | xargs clang-format --dry-run --Werror 2>/dev/null; then \
		echo "Main .clang-format failed, trying compatible version..."; \
		find src include examples tests -name "*.cpp" -o -name "*.hpp" | xargs clang-format --style=file:.clang-format-compat --dry-run --Werror; \
	fi

lint: build
	@echo "Running static analysis..."
	@cd build && ninja tidy

# Documentation commands
docs: build
	@echo "Generating documentation..."
	@cd build && ninja docs
	@echo "Documentation generated in build/docs/html/"

docs-serve: docs
	@echo "Serving documentation on http://localhost:8000"
	@cd build/docs/html && python3 -m http.server 8000

# Docker commands
docker-dev:
	@echo "Building and running development container..."
	@docker-compose up -d dev
	@docker-compose exec dev /bin/bash

docker-test:
	@echo "Running tests in container..."
	@docker-compose build test
	@docker-compose run --rm test

docker-build:
	@echo "Building all Docker images..."
	@docker-compose build

# Packaging commands
install: build
	@echo "Installing to system..."
	@cd build && sudo ninja install

package: build
	@echo "Creating distribution packages..."
	@cd build && cpack

# Utility commands
setup:
	@echo "Setting up development environment..."
	@pip3 install conan==2.0.14
	@conan profile detect --force
	@echo "Setup complete! Run 'make build' to build the project."

examples: build
	@echo "Running examples..."
	@echo "=== Basic Usage Example ==="
	@cd build && ./examples/basic_usage
	@echo ""
	@echo "=== Configuration Example ==="
	@cd build && ./examples/config_example
	@echo ""
	@echo "=== Library Usage Example ==="
	@cd build && ./examples/library_user

# Development workflow
dev: format lint test
	@echo "Development workflow complete!"

# CI workflow
ci: format-check lint test coverage
	@echo "CI workflow complete!"

# Quick build and test
quick: build test
	@echo "Quick build and test complete!"