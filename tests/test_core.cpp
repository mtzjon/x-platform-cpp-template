/**
 * @file test_core.cpp
 * @brief Unit tests for the core functionality
 * @version 1.0.0
 * @date 2024
 *
 * @copyright Copyright (c) 2024 Your Company
 *
 */

#include "cpp_template/core.hpp"

#include <filesystem>
#include <fstream>

#include <gtest/gtest.h>
#include <gmock/gmock.h>

using namespace cpp_template;
using namespace testing;

class CoreTest : public ::testing::Test {
protected:
    void SetUp() override {
        test_config_path = "test_config.json";

        // Create a test configuration file
        std::ofstream config_file(test_config_path);
        config_file << R"({
            "test_string": "hello",
            "test_int": 42,
            "test_bool": true,
            "test_float": 3.14
        })";
    }

    void TearDown() override {
        // Clean up test files
        if (std::filesystem::exists(test_config_path)) {
            std::filesystem::remove(test_config_path);
        }
    }

    std::string test_config_path;
};

TEST_F(CoreTest, ConstructorSetsName) {
    Core core("test_name");
    EXPECT_EQ(core.name(), "test_name");
}

TEST_F(CoreTest, SetNameChangesName) {
    Core core("initial_name");
    core.set_name("new_name");
    EXPECT_EQ(core.name(), "new_name");
}

TEST_F(CoreTest, VersionReturnsCorrectFormat) {
    std::string version = Core::version();
    EXPECT_THAT(version, MatchesRegex(R"(\d+\.\d+\.\d+)"));
}

TEST_F(CoreTest, InitializeWithoutConfigSucceeds) {
    Core core("test");
    EXPECT_TRUE(core.initialize());
}

TEST_F(CoreTest, InitializeWithValidConfigSucceeds) {
    Core core("test");
    EXPECT_TRUE(core.initialize(test_config_path));
}

TEST_F(CoreTest, InitializeWithInvalidConfigFails) {
    Core core("test");
    EXPECT_FALSE(core.initialize("nonexistent_config.json"));
}

TEST_F(CoreTest, ProcessItemsAppliesFunction) {
    Core core("test");
    std::vector<int> input{1, 2, 3, 4, 5};

    auto result = core.process_items<int>(input, [](const int& x) { return x * 2; });

    std::vector<int> expected{2, 4, 6, 8, 10};
    EXPECT_EQ(result, expected);
}

TEST_F(CoreTest, ProcessItemsWorksWithStrings) {
    Core core("test");
    std::vector<std::string> input{"hello", "world"};

    auto result = core.process_items<std::string>(input,
                                                   [](const std::string& s) { return s + "!"; });

    std::vector<std::string> expected{"hello!", "world!"};
    EXPECT_EQ(result, expected);
}

class ConfigTest : public ::testing::Test {
protected:
    void SetUp() override {
        test_config_path = "test_config.json";

        // Create a test configuration file
        std::ofstream config_file(test_config_path);
        config_file << R"({
            "test_string": "hello",
            "test_int": 42,
            "test_bool": true,
            "test_float": 3.14
        })";
    }

    void TearDown() override {
        // Clean up test files
        if (std::filesystem::exists(test_config_path)) {
            std::filesystem::remove(test_config_path);
        }
    }

    std::string test_config_path;
};

TEST_F(ConfigTest, LoadFromFileSucceeds) {
    EXPECT_TRUE(Config::load_from_file(test_config_path));
}

TEST_F(ConfigTest, LoadFromNonexistentFileFails) {
    EXPECT_FALSE(Config::load_from_file("nonexistent.json"));
}

TEST_F(ConfigTest, GetReturnsCorrectValues) {
    ASSERT_TRUE(Config::load_from_file(test_config_path));

    EXPECT_EQ(Config::get<std::string>("test_string"), "hello");
    EXPECT_EQ(Config::get<int>("test_int"), 42);
    EXPECT_EQ(Config::get<bool>("test_bool"), true);
    EXPECT_DOUBLE_EQ(Config::get<double>("test_float"), 3.14);
}

TEST_F(ConfigTest, GetReturnsDefaultForMissingKey) {
    ASSERT_TRUE(Config::load_from_file(test_config_path));

    EXPECT_EQ(Config::get<std::string>("missing_key", "default"), "default");
    EXPECT_EQ(Config::get<int>("missing_key", 99), 99);
}

TEST_F(ConfigTest, SetAndGetNewValues) {
    Config::set<std::string>("new_string", "new_value");
    Config::set<int>("new_int", 123);

    EXPECT_EQ(Config::get<std::string>("new_string"), "new_value");
    EXPECT_EQ(Config::get<int>("new_int"), 123);
}

// Copy and move semantics tests
TEST(CoreSemanticsTest, CopyConstructor) {
    Core original("original");
    Core copy(original);

    EXPECT_EQ(copy.name(), "original");
    // Both should be independent
    copy.set_name("copy");
    EXPECT_EQ(original.name(), "original");
    EXPECT_EQ(copy.name(), "copy");
}

TEST(CoreSemanticsTest, MoveConstructor) {
    Core original("original");
    std::string original_name = original.name();

    Core moved(std::move(original));
    EXPECT_EQ(moved.name(), original_name);
}

TEST(CoreSemanticsTest, CopyAssignment) {
    Core original("original");
    Core other("other");

    other = original;
    EXPECT_EQ(other.name(), "original");
}

TEST(CoreSemanticsTest, MoveAssignment) {
    Core original("original");
    Core other("other");
    std::string original_name = original.name();

    other = std::move(original);
    EXPECT_EQ(other.name(), original_name);
}