/**
 * @file version.hpp
 * @brief Version information for the C++ template library
 * @version 1.0.0
 * @date 2024
 *
 * @copyright Copyright (c) 2024 Your Company
 *
 */

#pragma once

namespace cpp_template {

/**
 * @brief Version information constants
 */
namespace version {
    constexpr int MAJOR = 1;
    constexpr int MINOR = 0;
    constexpr int PATCH = 0;
    constexpr const char* STRING = "1.0.0";
    constexpr const char* BUILD_TYPE =
#ifdef NDEBUG
        "Release";
#else
        "Debug";
#endif
}

} // namespace cpp_template