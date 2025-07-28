/**
 * @file core.hpp
 * @brief Core functionality for the C++ template library
 * @version 1.0.0
 * @date 2024
 * 
 * @copyright Copyright (c) 2024 Your Company
 * 
 */

#pragma once

#include <string>
#include <memory>
#include <vector>
#include <functional>

namespace cpp_template {

/**
 * @brief Core class demonstrating the template functionality
 * 
 * This class provides a simple example of how to structure a C++ library
 * with proper documentation, configuration, and modern C++ features.
 */
class Core {
public:
    /**
     * @brief Construct a new Core object
     * 
     * @param name The name identifier for this core instance
     */
    explicit Core(const std::string& name);
    
    /**
     * @brief Destroy the Core object
     */
    ~Core() = default;
    
    // Copy semantics
    Core(const Core& other) = default;
    Core& operator=(const Core& other) = default;
    
    // Move semantics
    Core(Core&& other) noexcept = default;
    Core& operator=(Core&& other) noexcept = default;
    
    /**
     * @brief Get the name of this core instance
     * 
     * @return const std::string& The name
     */
    const std::string& name() const noexcept;
    
    /**
     * @brief Set a new name for this core instance
     * 
     * @param new_name The new name to set
     */
    void set_name(const std::string& new_name);
    
    /**
     * @brief Process a list of items with a given function
     * 
     * @tparam T The type of items to process
     * @param items The vector of items to process
     * @param processor The function to apply to each item
     * @return std::vector<T> The processed items
     */
    template<typename T>
    std::vector<T> process_items(const std::vector<T>& items, 
                                std::function<T(const T&)> processor) const;
    
    /**
     * @brief Initialize the core with configuration
     * 
     * @param config_path Path to the configuration file
     * @return true if initialization was successful
     * @return false if initialization failed
     */
    bool initialize(const std::string& config_path = "");
    
    /**
     * @brief Get version information
     * 
     * @return std::string Version string in format "major.minor.patch"
     */
    static std::string version();

private:
    std::string name_;
    bool initialized_;
};

/**
 * @brief Utility class for configuration management
 */
class Config {
public:
    /**
     * @brief Load configuration from a file
     * 
     * @param path Path to the configuration file
     * @return true if loading was successful
     * @return false if loading failed
     */
    static bool load_from_file(const std::string& path);
    
    /**
     * @brief Get a configuration value
     * 
     * @tparam T The type of the value to retrieve
     * @param key The configuration key
     * @param default_value The default value if key is not found
     * @return T The configuration value or default
     */
    template<typename T>
    static T get(const std::string& key, const T& default_value = T{});
    
    /**
     * @brief Set a configuration value
     * 
     * @tparam T The type of the value to set
     * @param key The configuration key
     * @param value The value to set
     */
    template<typename T>
    static void set(const std::string& key, const T& value);
};

} // namespace cpp_template

// Template implementations
#include "cpp_template/core_impl.hpp"