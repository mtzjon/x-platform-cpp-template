/**
 * @file shared_lib_example.hpp
 * @brief Example shared library header
 * @version 1.0.0
 * @date 2024
 *
 * @copyright Copyright (c) 2024 Your Company
 *
 */

#pragma once

#include <string>
#include <memory>

// Export macros for shared library
#ifdef _WIN32
    #ifdef SHARED_LIB_EXPORTS
        #define SHARED_LIB_API __declspec(dllexport)
    #else
        #define SHARED_LIB_API __declspec(dllimport)
    #endif
#else
    #define SHARED_LIB_API __attribute__((visibility("default")))
#endif

namespace examples {

/**
 * @brief Example shared library class
 *
 * This class demonstrates how to create a shared library using the template.
 */
class SHARED_LIB_API SharedLibExample {
public:
    /**
     * @brief Construct a new Shared Lib Example object
     *
     * @param identifier The identifier for this instance
     */
    explicit SharedLibExample(const std::string& identifier);

    /**
     * @brief Destroy the Shared Lib Example object
     */
    ~SharedLibExample();

    // Non-copyable but moveable
    SharedLibExample(const SharedLibExample&) = delete;
    SharedLibExample& operator=(const SharedLibExample&) = delete;
    SharedLibExample(SharedLibExample&&) noexcept;
    SharedLibExample& operator=(SharedLibExample&&) noexcept;

    /**
     * @brief Get the identifier
     *
     * @return const std::string& The identifier
     */
    const std::string& identifier() const;

    /**
     * @brief Perform some computation
     *
     * @param input The input value
     * @return double The computed result
     */
    double compute(double input) const;

    /**
     * @brief Get library information
     *
     * @return std::string Information about the shared library
     */
    std::string get_info() const;

private:
    class Impl;
    std::unique_ptr<Impl> pimpl_;
};

/**
 * @brief Factory function for creating shared library instances
 *
 * @param identifier The identifier for the new instance
 * @return std::unique_ptr<SharedLibExample> The created instance
 */
SHARED_LIB_API std::unique_ptr<SharedLibExample>
create_shared_lib_example(const std::string& identifier);

} // namespace examples