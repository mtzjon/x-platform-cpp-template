/**
 * @file benchmark_core.cpp
 * @brief Benchmark tests for the core functionality
 * @version 1.0.0
 * @date 2024
 *
 * @copyright Copyright (c) 2024 Your Company
 *
 */

#include "cpp_template/core.hpp"

#include <algorithm>
#include <random>
#include <vector>

#include <benchmark/benchmark.h>

using namespace cpp_template;

// Benchmark data preparation
class BenchmarkFixture : public benchmark::Fixture {
public:
    void SetUp(const benchmark::State& state) override {
        core = std::make_unique<Core>("benchmark_core");

        // Generate test data
        std::random_device rd;
        std::mt19937 gen(rd());
        std::uniform_int_distribution<> dis(1, 1000);

        small_data.reserve(100);
        medium_data.reserve(1000);
        large_data.reserve(10000);

        for (int i = 0; i < 100; ++i) {
            small_data.push_back(dis(gen));
        }

        for (int i = 0; i < 1000; ++i) {
            medium_data.push_back(dis(gen));
        }

        for (int i = 0; i < 10000; ++i) {
            large_data.push_back(dis(gen));
        }
    }

    void TearDown(const benchmark::State& state) override { core.reset(); }

protected:
    std::unique_ptr<Core> core;
    std::vector<int> small_data;
    std::vector<int> medium_data;
    std::vector<int> large_data;
};

// Benchmark Core construction
static void BM_CoreConstruction(benchmark::State& state) {
    for (auto _ : state) {
        Core core("benchmark");
        benchmark::DoNotOptimize(core);
    }
}
BENCHMARK(BM_CoreConstruction);

// Benchmark Core name operations
static void BM_CoreNameOperations(benchmark::State& state) {
    Core core("initial");
    for (auto _ : state) {
        core.set_name("new_name");
        auto name = core.name();
        benchmark::DoNotOptimize(name);
    }
}
BENCHMARK(BM_CoreNameOperations);

// Benchmark process_items with different data sizes
BENCHMARK_DEFINE_F(BenchmarkFixture, BM_ProcessItemsSmall)(benchmark::State& state) {
    auto processor = [](const int& x) { return x * 2; };

    for (auto _ : state) {
        auto result = core->process_items(small_data, processor);
        benchmark::DoNotOptimize(result);
    }

    state.SetItemsProcessed(state.iterations() * small_data.size());
}
BENCHMARK_REGISTER_F(BenchmarkFixture, BM_ProcessItemsSmall);

BENCHMARK_DEFINE_F(BenchmarkFixture, BM_ProcessItemsMedium)(benchmark::State& state) {
    auto processor = [](const int& x) { return x * 2; };

    for (auto _ : state) {
        auto result = core->process_items(medium_data, processor);
        benchmark::DoNotOptimize(result);
    }

    state.SetItemsProcessed(state.iterations() * medium_data.size());
}
BENCHMARK_REGISTER_F(BenchmarkFixture, BM_ProcessItemsMedium);

BENCHMARK_DEFINE_F(BenchmarkFixture, BM_ProcessItemsLarge)(benchmark::State& state) {
    auto processor = [](const int& x) { return x * 2; };

    for (auto _ : state) {
        auto result = core->process_items(large_data, processor);
        benchmark::DoNotOptimize(result);
    }

    state.SetItemsProcessed(state.iterations() * large_data.size());
}
BENCHMARK_REGISTER_F(BenchmarkFixture, BM_ProcessItemsLarge);

// Benchmark different processor complexities
BENCHMARK_DEFINE_F(BenchmarkFixture, BM_SimpleProcessor)(benchmark::State& state) {
    auto processor = [](const int& x) { return x * 2; };

    for (auto _ : state) {
        auto result = core->process_items(medium_data, processor);
        benchmark::DoNotOptimize(result);
    }
}
BENCHMARK_REGISTER_F(BenchmarkFixture, BM_SimpleProcessor);

BENCHMARK_DEFINE_F(BenchmarkFixture, BM_ComplexProcessor)(benchmark::State& state) {
    auto processor = [](const int& x) {
        int result = x;
        for (int i = 0; i < 10; ++i) {
            result = (result * 13 + 7) % 1000;
        }
        return result;
    };

    for (auto _ : state) {
        auto result = core->process_items(medium_data, processor);
        benchmark::DoNotOptimize(result);
    }
}
BENCHMARK_REGISTER_F(BenchmarkFixture, BM_ComplexProcessor);

// Benchmark configuration operations
static void BM_ConfigSetGet(benchmark::State& state) {
    for (auto _ : state) {
        Config::set("benchmark_key", 42);
        auto value = Config::get<int>("benchmark_key", 0);
        benchmark::DoNotOptimize(value);
    }
}
BENCHMARK(BM_ConfigSetGet);

// Benchmark version string generation
static void BM_VersionString(benchmark::State& state) {
    for (auto _ : state) {
        auto version = Core::version();
        benchmark::DoNotOptimize(version);
    }
}
BENCHMARK(BM_VersionString);

// Main function for benchmarks
BENCHMARK_MAIN();