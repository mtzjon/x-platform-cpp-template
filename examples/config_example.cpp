/**
 * @file config_example.cpp
 * @brief Configuration management example
 * @version 1.0.0
 * @date 2024
 *
 * @copyright Copyright (c) 2024 Your Company
 *
 */

#include "cpp_template/core.hpp"

#include <filesystem>
#include <fstream>
#include <iostream>

int main() {
    std::cout << "=== Configuration Management Example ===" << std::endl;

    // Create a sample configuration file
    const std::string config_file = "example_config.json";

    std::cout << "Creating sample configuration file: " << config_file << std::endl;
    {
        std::ofstream file(config_file);
        file << R"({
    "application": {
        "name": "Configuration Example",
        "version": "1.0.0",
        "debug": true
    },
    "database": {
        "host": "localhost",
        "port": 5432,
        "name": "example_db",
        "timeout": 30.0
    },
    "processing": {
        "max_threads": 8,
        "batch_size": 1000,
        "enabled_features": ["feature_a", "feature_b", "feature_c"]
    }
})";
    }

    // Create core instance
    cpp_template::Core core("config_example");

    // Initialize with configuration file
    if (core.initialize(config_file)) {
        std::cout << "Configuration loaded successfully!" << std::endl;
    } else {
        std::cout << "Failed to load configuration!" << std::endl;
        return 1;
    }

    // Retrieve configuration values
    std::cout << "\n--- Application Configuration ---" << std::endl;
    auto app_name = cpp_template::Config::get<std::string>("application.name", "Unknown App");
    auto app_version = cpp_template::Config::get<std::string>("application.version", "0.0.0");
    auto debug_mode = cpp_template::Config::get<bool>("application.debug", false);

    std::cout << "App Name: " << app_name << std::endl;
    std::cout << "App Version: " << app_version << std::endl;
    std::cout << "Debug Mode: " << (debug_mode ? "enabled" : "disabled") << std::endl;

    std::cout << "\n--- Database Configuration ---" << std::endl;
    auto db_host = cpp_template::Config::get<std::string>("database.host", "localhost");
    auto db_port = cpp_template::Config::get<int>("database.port", 5432);
    auto db_name = cpp_template::Config::get<std::string>("database.name", "default_db");
    auto db_timeout = cpp_template::Config::get<double>("database.timeout", 10.0);

    std::cout << "Database Host: " << db_host << std::endl;
    std::cout << "Database Port: " << db_port << std::endl;
    std::cout << "Database Name: " << db_name << std::endl;
    std::cout << "Database Timeout: " << db_timeout << "s" << std::endl;

    std::cout << "\n--- Processing Configuration ---" << std::endl;
    auto max_threads = cpp_template::Config::get<int>("processing.max_threads", 1);
    auto batch_size = cpp_template::Config::get<int>("processing.batch_size", 100);

    std::cout << "Max Threads: " << max_threads << std::endl;
    std::cout << "Batch Size: " << batch_size << std::endl;

    // Demonstrate runtime configuration changes
    std::cout << "\n--- Runtime Configuration Changes ---" << std::endl;

    // Set new values
    cpp_template::Config::set<std::string>("runtime.user", "example_user");
    cpp_template::Config::set<int>("runtime.session_id", 12345);
    cpp_template::Config::set<bool>("runtime.authenticated", true);

    // Retrieve the new values
    auto user = cpp_template::Config::get<std::string>("runtime.user", "guest");
    auto session_id = cpp_template::Config::get<int>("runtime.session_id", 0);
    auto authenticated = cpp_template::Config::get<bool>("runtime.authenticated", false);

    std::cout << "Runtime User: " << user << std::endl;
    std::cout << "Session ID: " << session_id << std::endl;
    std::cout << "Authenticated: " << (authenticated ? "yes" : "no") << std::endl;

    // Demonstrate default value handling
    std::cout << "\n--- Default Value Handling ---" << std::endl;

    auto missing_string = cpp_template::Config::get<std::string>("missing.key", "default_string");
    auto missing_int = cpp_template::Config::get<int>("missing.number", 999);
    auto missing_bool = cpp_template::Config::get<bool>("missing.flag", true);

    std::cout << "Missing string (default): " << missing_string << std::endl;
    std::cout << "Missing int (default): " << missing_int << std::endl;
    std::cout << "Missing bool (default): " << (missing_bool ? "true" : "false") << std::endl;

    // Use configuration in processing
    std::cout << "\n--- Using Configuration in Processing ---" << std::endl;

    std::vector<int> data;
    for (int i = 1; i <= batch_size; ++i) {
        data.push_back(i);
    }

    // Process data using configuration-driven batch size
    auto multiplier = cpp_template::Config::get<int>("processing.multiplier", 2);
    cpp_template::Config::set<int>("processing.multiplier", 3); // Set if not exists
    multiplier = cpp_template::Config::get<int>("processing.multiplier", 2);

    auto processed = core.process_items<int>(data, [multiplier](const int& x) {
        return x * multiplier;
    });

    std::cout << "Processed " << processed.size() << " items with multiplier " << multiplier
              << std::endl;
    std::cout << "First 10 processed values: ";
    for (size_t i = 0; i < std::min(processed.size(), size_t(10)); ++i) {
        std::cout << processed[i] << " ";
    }
    std::cout << std::endl;

    // Clean up
    if (std::filesystem::exists(config_file)) {
        std::filesystem::remove(config_file);
        std::cout << "\nCleaned up configuration file." << std::endl;
    }

    std::cout << "\n=== Configuration example completed successfully! ===" << std::endl;

    return 0;
}