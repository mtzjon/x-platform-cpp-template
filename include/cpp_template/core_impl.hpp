/**
 * @file core_impl.hpp
 * @brief Template implementations for the core functionality
 * @version 1.0.0
 * @date 2024
 *
 * @copyright Copyright (c) 2024 Your Company
 *
 */

#pragma once

#include <algorithm>

#include <nlohmann/json.hpp>

namespace cpp_template {

template<typename T>
std::vector<T> Core::process_items(const std::vector<T>& items,
                                   std::function<T(const T&)> processor) const {
    std::vector<T> result;
    result.reserve(items.size());

    std::transform(items.begin(), items.end(), std::back_inserter(result), processor);

    return result;
}

namespace detail {
// Internal storage for configuration
extern nlohmann::json config_data;
}  // namespace detail

template<typename T>
T Config::get(const std::string& key, const T& default_value) {
    try {
        if (detail::config_data.contains(key)) {
            return detail::config_data[key].get<T>();
        }
    } catch (const std::exception&) {
        // Return default value on any error
    }
    return default_value;
}

template<typename T>
void Config::set(const std::string& key, const T& value) {
    detail::config_data[key] = value;
}

}  // namespace cpp_template