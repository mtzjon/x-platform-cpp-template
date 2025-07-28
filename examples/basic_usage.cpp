/**
 * @file basic_usage.cpp
 * @brief Basic usage example of the C++ template library
 * @version 1.0.0
 * @date 2024
 * 
 * @copyright Copyright (c) 2024 Your Company
 * 
 */

#include "cpp_template/core.hpp"
#include <iostream>
#include <vector>
#include <string>

int main() {
    std::cout << "=== C++ Template Library Basic Usage Example ===" << std::endl;
    
    // Create a core instance
    cpp_template::Core core("example_core");
    std::cout << "Created core with name: " << core.name() << std::endl;
    
    // Show version information
    std::cout << "Library version: " << cpp_template::Core::version() << std::endl;
    
    // Initialize the core
    if (core.initialize()) {
        std::cout << "Core initialized successfully!" << std::endl;
    } else {
        std::cout << "Failed to initialize core!" << std::endl;
        return 1;
    }
    
    // Demonstrate name change
    core.set_name("renamed_core");
    std::cout << "Core renamed to: " << core.name() << std::endl;
    
    // Demonstrate item processing with integers
    std::cout << "\n--- Integer Processing Example ---" << std::endl;
    std::vector<int> numbers{1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    
    std::cout << "Original numbers: ";
    for (const auto& num : numbers) {
        std::cout << num << " ";
    }
    std::cout << std::endl;
    
    // Square each number
    auto squared = core.process_items<int>(numbers, [](const int& x) { return x * x; });
    std::cout << "Squared numbers: ";
    for (const auto& num : squared) {
        std::cout << num << " ";
    }
    std::cout << std::endl;
    
    // Double each number
    auto doubled = core.process_items<int>(numbers, [](const int& x) { return x * 2; });
    std::cout << "Doubled numbers: ";
    for (const auto& num : doubled) {
        std::cout << num << " ";
    }
    std::cout << std::endl;
    
    // Demonstrate item processing with strings
    std::cout << "\n--- String Processing Example ---" << std::endl;
    std::vector<std::string> words{"hello", "world", "cpp", "template", "library"};
    
    std::cout << "Original words: ";
    for (const auto& word : words) {
        std::cout << word << " ";
    }
    std::cout << std::endl;
    
    // Convert to uppercase
    auto uppercase = core.process_items<std::string>(words, [](const std::string& s) {
        std::string result = s;
        std::transform(result.begin(), result.end(), result.begin(), ::toupper);
        return result;
    });
    
    std::cout << "Uppercase words: ";
    for (const auto& word : uppercase) {
        std::cout << word << " ";
    }
    std::cout << std::endl;
    
    // Add exclamation marks
    auto excited = core.process_items<std::string>(words, [](const std::string& s) {
        return s + "!";
    });
    
    std::cout << "Excited words: ";
    for (const auto& word : excited) {
        std::cout << word << " ";
    }
    std::cout << std::endl;
    
    // Demonstrate configuration
    std::cout << "\n--- Configuration Example ---" << std::endl;
    
    // Set some configuration values
    cpp_template::Config::set<std::string>("app_name", "Basic Usage Example");
    cpp_template::Config::set<int>("max_iterations", 100);
    cpp_template::Config::set<double>("threshold", 0.75);
    cpp_template::Config::set<bool>("debug_mode", true);
    
    // Retrieve configuration values
    auto app_name = cpp_template::Config::get<std::string>("app_name", "Unknown");
    auto max_iterations = cpp_template::Config::get<int>("max_iterations", 10);
    auto threshold = cpp_template::Config::get<double>("threshold", 0.5);
    auto debug_mode = cpp_template::Config::get<bool>("debug_mode", false);
    
    std::cout << "Configuration:" << std::endl;
    std::cout << "  App Name: " << app_name << std::endl;
    std::cout << "  Max Iterations: " << max_iterations << std::endl;
    std::cout << "  Threshold: " << threshold << std::endl;
    std::cout << "  Debug Mode: " << (debug_mode ? "enabled" : "disabled") << std::endl;
    
    // Test default values
    auto missing_value = cpp_template::Config::get<std::string>("missing_key", "default_value");
    std::cout << "Missing key default: " << missing_value << std::endl;
    
    std::cout << "\n=== Example completed successfully! ===" << std::endl;
    
    return 0;
}