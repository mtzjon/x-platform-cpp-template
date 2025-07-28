/**
 * @file static_lib_example.cpp
 * @brief Implementation of the static library example
 * @version 1.0.0
 * @date 2024
 *
 * @copyright Copyright (c) 2024 Your Company
 *
 */

#include "static_lib_example.hpp"

#include "cpp_template/core.hpp"

#include <algorithm>
#include <cmath>

namespace examples {

StaticLibExample::StaticLibExample(const std::string& name) : name_(name) {}

const std::string& StaticLibExample::name() const {
    return name_;
}

std::vector<double> StaticLibExample::process_numbers(const std::vector<int>& numbers) const {
    std::vector<double> result;
    result.reserve(numbers.size());

    std::transform(numbers.begin(), numbers.end(), std::back_inserter(result),
                   [](int x) { return std::sqrt(static_cast<double>(x * x + 1)); });

    return result;
}

std::string StaticLibExample::get_greeting() const {
    return "Hello from static library: " + name_;
}

}  // namespace examples