/**
 * @file interface_lib_example.hpp
 * @brief Example interface (header-only) library
 * @version 1.0.0
 * @date 2024
 * 
 * @copyright Copyright (c) 2024 Your Company
 * 
 */

#pragma once

#include <type_traits>
#include <algorithm>
#include <numeric>
#include <vector>
#include <chrono>

namespace examples {

/**
 * @brief Template utilities for mathematical operations
 * 
 * This header-only library demonstrates interface libraries in the template.
 */
namespace math_utils {

/**
 * @brief Check if a type is numeric
 * 
 * @tparam T The type to check
 */
template<typename T>
constexpr bool is_numeric_v = std::is_arithmetic_v<T>;

/**
 * @brief Calculate the mean of a container
 * 
 * @tparam Container The container type
 * @param container The container of values
 * @return auto The mean value
 */
template<typename Container>
auto mean(const Container& container) -> typename Container::value_type {
    static_assert(is_numeric_v<typename Container::value_type>, 
                  "Container must contain numeric values");
    
    if (container.empty()) {
        return typename Container::value_type{};
    }
    
    auto sum = std::accumulate(container.begin(), container.end(), 
                              typename Container::value_type{});
    return sum / static_cast<typename Container::value_type>(container.size());
}

/**
 * @brief Calculate the variance of a container
 * 
 * @tparam Container The container type
 * @param container The container of values
 * @return auto The variance
 */
template<typename Container>
auto variance(const Container& container) -> typename Container::value_type {
    static_assert(is_numeric_v<typename Container::value_type>, 
                  "Container must contain numeric values");
    
    if (container.size() < 2) {
        return typename Container::value_type{};
    }
    
    auto mean_val = mean(container);
    auto sum_sq_diff = std::accumulate(container.begin(), container.end(), 
                                      typename Container::value_type{},
        [mean_val](const auto& acc, const auto& val) {
            auto diff = val - mean_val;
            return acc + diff * diff;
        });
    
    return sum_sq_diff / static_cast<typename Container::value_type>(container.size() - 1);
}

/**
 * @brief Apply a function to each element and return transformed container
 * 
 * @tparam Container The input container type
 * @tparam Function The transformation function type
 * @param container The input container
 * @param func The transformation function
 * @return auto The transformed container
 */
template<typename Container, typename Function>
auto transform_container(const Container& container, Function func) {
    using InputType = typename Container::value_type;
    using OutputType = std::invoke_result_t<Function, InputType>;
    
    std::vector<OutputType> result;
    result.reserve(container.size());
    
    std::transform(container.begin(), container.end(), std::back_inserter(result), func);
    
    return result;
}

/**
 * @brief Filter container elements based on a predicate
 * 
 * @tparam Container The container type
 * @tparam Predicate The predicate function type
 * @param container The input container
 * @param pred The predicate function
 * @return Container The filtered container
 */
template<typename Container, typename Predicate>
Container filter(const Container& container, Predicate pred) {
    Container result;
    
    std::copy_if(container.begin(), container.end(), std::back_inserter(result), pred);
    
    return result;
}

/**
 * @brief Find the minimum and maximum elements in a container
 * 
 * @tparam Container The container type
 * @param container The input container
 * @return std::pair<typename Container::value_type, typename Container::value_type> 
 *         A pair containing min and max values
 */
template<typename Container>
std::pair<typename Container::value_type, typename Container::value_type>
min_max(const Container& container) {
    static_assert(is_numeric_v<typename Container::value_type>, 
                  "Container must contain numeric values");
    
    if (container.empty()) {
        return {typename Container::value_type{}, typename Container::value_type{}};
    }
    
    auto [min_it, max_it] = std::minmax_element(container.begin(), container.end());
    return {*min_it, *max_it};
}

} // namespace math_utils

/**
 * @brief RAII wrapper for timing operations
 */
class Timer {
public:
    /**
     * @brief Construct a new Timer object and start timing
     */
    Timer() : start_(std::chrono::high_resolution_clock::now()) {}
    
    /**
     * @brief Get elapsed time in milliseconds
     * 
     * @return double Elapsed time in milliseconds
     */
    double elapsed_ms() const {
        auto end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start_);
        return duration.count() / 1000.0;
    }
    
    /**
     * @brief Reset the timer
     */
    void reset() {
        start_ = std::chrono::high_resolution_clock::now();
    }

private:
    std::chrono::high_resolution_clock::time_point start_;
};

} // namespace examples