# Multi-stage Dockerfile for C++ template project

# Build stage
FROM ubuntu:22.04 AS builder

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV CC=clang-14
ENV CXX=clang++-14

# Install build dependencies
RUN apt-get update && \
    # Clean up potential conflicts first
    apt-get autoremove -y || true && \
    apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    clang-14 \
    clang++-14 \
    clang-tools-14 \
    clang-format-14 \
    clang-tidy-14 \
    libc++-14-dev \
    libc++abi-14-dev \
    python3 \
    python3-pip \
    python3-venv \
    git \
    pkg-config \
    doxygen \
    graphviz \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-fonts-recommended \
    lcov \
    gcovr \
    wget \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/* \
    # Create symlinks for generic tool names
    && ln -sf /usr/bin/clang-14 /usr/bin/clang \
    && ln -sf /usr/bin/clang++-14 /usr/bin/clang++ \
    && ln -sf /usr/bin/clang-format-14 /usr/bin/clang-format \
    && ln -sf /usr/bin/clang-tidy-14 /usr/bin/clang-tidy

# Install Conan
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install conan==2.0.14

# Create conan profile
RUN conan profile detect --force

# Set working directory
WORKDIR /workspace

# Copy project files
COPY . .

# Configure and build project
RUN mkdir -p build && cd build && \
    cmake .. \
        -G Ninja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DCMAKE_C_COMPILER=clang \
        -DBUILD_SHARED_LIBS=OFF \
        -DBUILD_TESTS=ON \
        -DBUILD_DOCS=ON \
        -DBUILD_EXAMPLES=ON

RUN cd build && ninja all

# Run tests
RUN cd build && ctest --output-on-failure

# Build documentation
RUN cd build && ninja docs

# Development stage
FROM ubuntu:22.04 AS development

ENV DEBIAN_FRONTEND=noninteractive
ENV CC=clang-14
ENV CXX=clang++-14

# Install development tools
RUN apt-get update && \
    # Clean up potential conflicts first
    apt-get autoremove -y || true && \
    apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    clang-14 \
    clang++-14 \
    clang-tools-14 \
    clang-format-14 \
    clang-tidy-14 \
    libc++-14-dev \
    libc++abi-14-dev \
    python3 \
    python3-pip \
    python3-venv \
    git \
    pkg-config \
    doxygen \
    graphviz \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-fonts-recommended \
    lcov \
    gcovr \
    gdb \
    valgrind \
    strace \
    htop \
    vim \
    nano \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/* \
    # Create symlinks for generic tool names
    && ln -sf /usr/bin/clang-14 /usr/bin/clang \
    && ln -sf /usr/bin/clang++-14 /usr/bin/clang++ \
    && ln -sf /usr/bin/clang-format-14 /usr/bin/clang-format \
    && ln -sf /usr/bin/clang-tidy-14 /usr/bin/clang-tidy

# Install Conan
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install conan==2.0.14

# Create conan profile
RUN conan profile detect --force

# Create non-root user for development
RUN useradd -m -s /bin/bash developer && \
    usermod -aG sudo developer && \
    echo 'developer ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER developer
WORKDIR /home/developer/workspace

# Runtime stage
FROM ubuntu:22.04 AS runtime

ENV DEBIAN_FRONTEND=noninteractive

# Install only runtime dependencies
RUN apt-get update && apt-get install -y \
    libc++1-14 \
    libc++abi1-14 \
    libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

# Create application user
RUN useradd -m -s /bin/bash appuser

# Copy built artifacts from builder stage
COPY --from=builder /workspace/build/examples/basic_usage /usr/local/bin/
COPY --from=builder /workspace/build/examples/config_example /usr/local/bin/
COPY --from=builder /workspace/build/examples/library_user /usr/local/bin/
COPY --from=builder /workspace/build/lib* /usr/local/lib/
COPY --from=builder /workspace/include /usr/local/include/
COPY --from=builder /workspace/build/docs/html /usr/local/share/doc/cpp_template/

# Set library path
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

USER appuser
WORKDIR /home/appuser

# Default command
CMD ["/usr/local/bin/basic_usage"]

# Testing stage for CI/CD
FROM builder AS testing

WORKDIR /workspace/build

# Run all tests with coverage
RUN cmake .. \
    -DCMAKE_BUILD_TYPE=Debug \
    -DENABLE_COVERAGE=ON \
    -DENABLE_SANITIZERS=ON

RUN ninja all

# Run tests with coverage
RUN ctest --output-on-failure --parallel $(nproc)

# Run benchmarks
RUN ./tests/cpp_template_benchmarks --benchmark_format=json > benchmark_results.json || true

# Generate coverage report
RUN ninja coverage || true

# Run static analysis
RUN ninja tidy || true

# Check formatting
RUN ninja format-check || true

# Static analysis stage
FROM development AS analysis

WORKDIR /workspace

# Install additional analysis tools
USER root
RUN apt-get update && apt-get install -y \
    cppcheck \
    iwyu \
    && rm -rf /var/lib/apt/lists/*

USER developer

# Copy source code
COPY --chown=developer:developer . .

# Run static analysis
RUN mkdir -p analysis && cd analysis && \
    cmake .. -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

# Run cppcheck
RUN cppcheck --enable=all --std=c++20 --language=c++ \
    --error-exitcode=1 \
    --inline-suppr \
    --suppress=missingIncludeSystem \
    src/ include/ examples/ 2> cppcheck_report.txt || true

# Default target
FROM development