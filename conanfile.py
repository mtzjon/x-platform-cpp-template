from conan import ConanFile
from conan.tools.cmake import CMakeDeps, CMakeToolchain, cmake_layout
from conan.tools.files import copy
import os


class CppTemplateConan(ConanFile):
    name = "cpp_template"
    version = "1.0.0"
    
    # Binary configuration
    settings = "os", "compiler", "build_type", "arch"
    options = {
        "shared": [True, False],
        "fPIC": [True, False],
        "with_tests": [True, False],
        "with_docs": [True, False],
    }
    default_options = {
        "shared": False,
        "fPIC": True,
        "with_tests": True,
        "with_docs": True,
    }
    
    # Sources are located in the same place as this recipe, copy them to the recipe
    exports_sources = "CMakeLists.txt", "src/*", "include/*", "tests/*", "cmake/*", "docs/*", "examples/*"
    
    def config_options(self):
        if self.settings.os == "Windows":
            self.options.rm_safe("fPIC")
    
    def configure(self):
        if self.options.shared:
            self.options.rm_safe("fPIC")
    
    def requirements(self):
        # Core dependencies
        self.requires("fmt/10.1.1")
        self.requires("spdlog/1.12.0")
        self.requires("nlohmann_json/3.11.3")
        
        # Optional dependencies based on options
        if self.options.with_tests:
            self.test_requires("gtest/1.14.0")
            self.test_requires("benchmark/1.8.3")
    
    def build_requirements(self):
        if self.options.with_docs:
            # Doxygen will be handled by the system package manager
            pass
    
    def layout(self):
        cmake_layout(self)
    
    def generate(self):
        deps = CMakeDeps(self)
        deps.generate()
        
        tc = CMakeToolchain(self)
        tc.variables["BUILD_SHARED_LIBS"] = self.options.shared
        tc.variables["BUILD_TESTS"] = self.options.with_tests
        tc.variables["BUILD_DOCS"] = self.options.with_docs
        tc.generate()
    
    def build(self):
        cmake = self._cmake()
        cmake.configure()
        cmake.build()
    
    def _cmake(self):
        from conan.tools.cmake import CMake
        cmake = CMake(self)
        return cmake
    
    def package(self):
        copy(self, "LICENSE", src=self.source_folder, dst=os.path.join(self.package_folder, "licenses"))
        cmake = self._cmake()
        cmake.install()
    
    def package_info(self):
        self.cpp_info.libs = ["cpp_template"]
        self.cpp_info.includedirs = ["include"]
        
        if self.settings.os in ["Linux", "FreeBSD"]:
            self.cpp_info.system_libs.append("m")
            
        if self.settings.os == "Windows":
            self.cpp_info.system_libs.append("ws2_32")