/**
 * @file shared_lib_example.cpp
 * @brief Implementation of the shared library example
 * @version 1.0.0
 * @date 2024
 * 
 * @copyright Copyright (c) 2024 Your Company
 * 
 */

#include "shared_lib_example.hpp"
#include "cpp_template/core.hpp"
#include <cmath>
#include <sstream>

namespace examples {

// Pimpl implementation
class SharedLibExample::Impl {
public:
    explicit Impl(const std::string& identifier) 
        : identifier_(identifier), core_("shared_lib_" + identifier) {
        core_.initialize();
    }
    
    const std::string& identifier() const { return identifier_; }
    
    double compute(double input) const {
        // Some example computation using the core library
        std::vector<double> data{input, input * 2, input * 3};
        auto processed = core_.process_items<double>(data, [](const double& x) {
            return std::sin(x) * std::cos(x) + std::sqrt(std::abs(x));
        });
        
        double result = 0.0;
        for (const auto& val : processed) {
            result += val;
        }
        return result / processed.size();
    }
    
    std::string get_info() const {
        std::ostringstream oss;
        oss << "SharedLibExample{identifier: " << identifier_ 
            << ", core: " << core_.name() 
            << ", version: " << cpp_template::Core::version() << "}";
        return oss.str();
    }

private:
    std::string identifier_;
    cpp_template::Core core_;
};

SharedLibExample::SharedLibExample(const std::string& identifier)
    : pimpl_(std::make_unique<Impl>(identifier)) {
}

SharedLibExample::~SharedLibExample() = default;

SharedLibExample::SharedLibExample(SharedLibExample&&) noexcept = default;
SharedLibExample& SharedLibExample::operator=(SharedLibExample&&) noexcept = default;

const std::string& SharedLibExample::identifier() const {
    return pimpl_->identifier();
}

double SharedLibExample::compute(double input) const {
    return pimpl_->compute(input);
}

std::string SharedLibExample::get_info() const {
    return pimpl_->get_info();
}

std::unique_ptr<SharedLibExample> create_shared_lib_example(const std::string& identifier) {
    return std::make_unique<SharedLibExample>(identifier);
}

} // namespace examples