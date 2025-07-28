/**
 * @file static_lib_example.hpp
 * @brief Example static library header
 * @version 1.0.0
 * @date 2024
 *
 * @copyright Copyright (c) 2024 Your Company
 *
 */

#pragma once

#include <string>
#include <vector>

namespace examples {

/**
 * @brief Example static library class
 *
 * This class demonstrates how to create a static library using the template.
 */
class StaticLibExample {
public:
    /**
     * @brief Construct a new Static Lib Example object
     *
     * @param name The name of the instance
     */
    explicit StaticLibExample(const std::string& name);

    /**
     * @brief Get the name of this instance
     *
     * @return const std::string& The name
     */
    const std::string& name() const;

    /**
     * @brief Process a list of numbers
     *
     * @param numbers The input numbers
     * @return std::vector<double> The processed numbers
     */
    std::vector<double> process_numbers(const std::vector<int>& numbers) const;

    /**
     * @brief Get a greeting message
     *
     * @return std::string The greeting
     */
    std::string get_greeting() const;

private:
    std::string name_;
};

} // namespace examples