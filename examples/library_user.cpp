/**
 * @file library_user.cpp
 * @brief Application demonstrating usage of all example libraries
 * @version 1.0.0
 * @date 2024
 *
 * @copyright Copyright (c) 2024 Your Company
 *
 */

#include "interface_lib_example.hpp"
#include "shared_lib_example.hpp"
#include "static_lib_example.hpp"

#include <iostream>
#include <random>
#include <vector>

int main() {
    std::cout << "=== Library Usage Demonstration ===" << std::endl;

    // Generate some test data
    std::vector<int> test_data;
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(1, 100);

    for (int i = 0; i < 20; ++i) {
        test_data.push_back(dis(gen));
    }

    std::cout << "Generated test data: ";
    for (const auto& val : test_data) {
        std::cout << val << " ";
    }
    std::cout << std::endl;

    // Test static library
    std::cout << "\n--- Static Library Example ---" << std::endl;
    examples::StaticLibExample static_lib("static_example");
    std::cout << static_lib.get_greeting() << std::endl;

    auto processed_static = static_lib.process_numbers(test_data);
    std::cout << "Static lib processed first 5 values: ";
    for (size_t i = 0; i < std::min(processed_static.size(), size_t(5)); ++i) {
        std::cout << processed_static[i] << " ";
    }
    std::cout << std::endl;

    // Test shared library
    std::cout << "\n--- Shared Library Example ---" << std::endl;
    auto shared_lib = examples::create_shared_lib_example("shared_example");
    std::cout << shared_lib->get_info() << std::endl;

    double shared_result = shared_lib->compute(42.0);
    std::cout << "Shared lib computation result: " << shared_result << std::endl;

    // Test interface library
    std::cout << "\n--- Interface Library Example ---" << std::endl;

    // Convert test data to double for math operations
    std::vector<double> double_data;
    std::transform(test_data.begin(), test_data.end(), std::back_inserter(double_data),
                   [](int x) { return static_cast<double>(x); });

    // Time the operations
    examples::Timer timer;

    auto mean_val = examples::math_utils::mean(double_data);
    auto variance_val = examples::math_utils::variance(double_data);
    auto [min_val, max_val] = examples::math_utils::min_max(double_data);

    std::cout << "Statistical analysis:" << std::endl;
    std::cout << "  Mean: " << mean_val << std::endl;
    std::cout << "  Variance: " << variance_val << std::endl;
    std::cout << "  Min: " << min_val << std::endl;
    std::cout << "  Max: " << max_val << std::endl;
    std::cout << "  Computation time: " << timer.elapsed_ms() << " ms" << std::endl;

    // Test transformation
    timer.reset();
    auto squared = examples::math_utils::transform_container(double_data,
                                                             [](double x) { return x * x; });
    std::cout << "\nTransformed (squared) first 5 values: ";
    for (size_t i = 0; i < std::min(squared.size(), size_t(5)); ++i) {
        std::cout << squared[i] << " ";
    }
    std::cout << std::endl;
    std::cout << "Transformation time: " << timer.elapsed_ms() << " ms" << std::endl;

    // Test filtering
    timer.reset();
    auto filtered = examples::math_utils::filter(double_data,
                                                  [mean_val](double x) { return x > mean_val; });
    std::cout << "\nValues above mean (" << filtered.size() << " values): ";
    for (const auto& val : filtered) {
        std::cout << val << " ";
    }
    std::cout << std::endl;
    std::cout << "Filtering time: " << timer.elapsed_ms() << " ms" << std::endl;

    // Demonstrate template constraints
    std::cout << "\n--- Template Constraints Demo ---" << std::endl;
    std::cout << "Is int numeric? " << examples::math_utils::is_numeric_v<int> << std::endl;
    std::cout << "Is double numeric? " << examples::math_utils::is_numeric_v<double> << std::endl;
    std::cout << "Is string numeric? " << examples::math_utils::is_numeric_v<std::string>
              << std::endl;

    // Chain operations
    std::cout << "\n--- Chained Operations ---" << std::endl;
    timer.reset();

    auto chained_result = examples::math_utils::transform_container(
        examples::math_utils::filter(double_data, [](double x) { return x > 25.0; }),
        [](double x) { return std::sqrt(x); });

    auto chained_mean = examples::math_utils::mean(chained_result);

    std::cout << "Chained operation result (filter > 25, then sqrt, then mean): " << chained_mean
              << std::endl;
    std::cout << "Chained operation time: " << timer.elapsed_ms() << " ms" << std::endl;

    // Test move semantics of shared library
    std::cout << "\n--- Move Semantics Test ---" << std::endl;
    auto shared_lib2 = examples::create_shared_lib_example("moveable_example");
    auto identifier_before = shared_lib2->identifier();

    auto shared_lib3 = std::move(shared_lib2);
    std::cout << "Moved shared library identifier: " << shared_lib3->identifier() << std::endl;
    std::cout << "Move operation successful: " << (shared_lib3->identifier() == identifier_before)
              << std::endl;

    std::cout << "\n=== All library demonstrations completed successfully! ===" << std::endl;

    return 0;
}