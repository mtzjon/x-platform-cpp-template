/**
 * @file core.cpp
 * @brief Implementation of the core functionality
 * @version 1.0.0
 * @date 2024
 * 
 * @copyright Copyright (c) 2024 Your Company
 * 
 */

#include "cpp_template/core.hpp"
#include "cpp_template/version.hpp"

#include <spdlog/spdlog.h>
#include <fmt/format.h>
#include <nlohmann/json.hpp>
#include <fstream>
#include <stdexcept>

namespace cpp_template {

namespace detail {
    nlohmann::json config_data;
}

Core::Core(const std::string& name) 
    : name_(name), initialized_(false) {
    spdlog::debug("Creating Core instance with name: {}", name_);
}

const std::string& Core::name() const noexcept {
    return name_;
}

void Core::set_name(const std::string& new_name) {
    spdlog::info("Changing name from '{}' to '{}'", name_, new_name);
    name_ = new_name;
}

bool Core::initialize(const std::string& config_path) {
    try {
        if (!config_path.empty()) {
            if (!Config::load_from_file(config_path)) {
                spdlog::warn("Failed to load configuration from: {}", config_path);
                return false;
            }
        }
        
        initialized_ = true;
        spdlog::info("Core '{}' initialized successfully", name_);
        return true;
        
    } catch (const std::exception& e) {
        spdlog::error("Failed to initialize Core '{}': {}", name_, e.what());
        return false;
    }
}

std::string Core::version() {
    return fmt::format("{}.{}.{}", 
        version::MAJOR, 
        version::MINOR, 
        version::PATCH
    );
}

bool Config::load_from_file(const std::string& path) {
    try {
        std::ifstream file(path);
        if (!file.is_open()) {
            spdlog::error("Cannot open configuration file: {}", path);
            return false;
        }
        
        file >> detail::config_data;
        spdlog::info("Configuration loaded from: {}", path);
        return true;
        
    } catch (const std::exception& e) {
        spdlog::error("Error loading configuration from {}: {}", path, e.what());
        return false;
    }
}

} // namespace cpp_template