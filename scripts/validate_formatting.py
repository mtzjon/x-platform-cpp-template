#!/usr/bin/env python3

"""
Formatting validation script for C++ Template Project
Checks for common formatting issues that would cause clang-format CI failures
"""

import os
import re
import sys
from pathlib import Path


def print_colored(message, color):
    """Print colored output"""
    colors = {
        'red': '\033[0;31m',
        'green': '\033[0;32m',
        'yellow': '\033[1;33m',
        'blue': '\033[0;34m',
        'reset': '\033[0m'
    }
    print(f"{colors.get(color, '')}{message}{colors['reset']}")


def find_cpp_files():
    """Find all C++ source files"""
    cpp_files = []
    for root in ['src', 'include', 'examples', 'tests']:
        if os.path.exists(root):
            for file_path in Path(root).rglob('*'):
                if file_path.suffix in ['.cpp', '.hpp', '.h', '.cxx', '.cc']:
                    cpp_files.append(str(file_path))
    return sorted(cpp_files)


def check_line_length(file_path, max_length=100):
    """Check for lines that are too long"""
    issues = []
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            for line_num, line in enumerate(f, 1):
                # Remove newline for length check
                line_content = line.rstrip('\n\r')
                if len(line_content) > max_length:
                    issues.append(f"{file_path}:{line_num}: Line too long ({len(line_content)} > {max_length})")
    except Exception as e:
        issues.append(f"{file_path}: Error reading file - {e}")
    return issues


def check_trailing_whitespace(file_path):
    """Check for trailing whitespace"""
    issues = []
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            for line_num, line in enumerate(f, 1):
                if line.rstrip('\n\r') != line.rstrip():
                    issues.append(f"{file_path}:{line_num}: Trailing whitespace")
    except Exception as e:
        issues.append(f"{file_path}: Error reading file - {e}")
    return issues


def check_tabs(file_path):
    """Check for tab characters"""
    issues = []
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            if '\t' in content:
                issues.append(f"{file_path}: Contains tab characters")
    except Exception as e:
        issues.append(f"{file_path}: Error reading file - {e}")
    return issues


def check_include_guards(file_path):
    """Check for proper include guards or #pragma once in headers"""
    if not file_path.endswith(('.hpp', '.h')):
        return []
    
    issues = []
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
            # Check for #pragma once
            if '#pragma once' in content:
                return []
            
            # Check for traditional include guards
            ifndef_pattern = r'#ifndef\s+(\w+)'
            define_pattern = r'#define\s+(\w+)'
            endif_pattern = r'#endif'
            
            ifndef_match = re.search(ifndef_pattern, content)
            define_match = re.search(define_pattern, content)
            endif_match = re.search(endif_pattern, content)
            
            if not (ifndef_match and define_match and endif_match):
                issues.append(f"{file_path}: Missing or incomplete include guards")
                
    except Exception as e:
        issues.append(f"{file_path}: Error reading file - {e}")
    return issues


def check_namespace_comments(file_path):
    """Check for namespace closing comments"""
    issues = []
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            
        namespace_stack = []
        for line_num, line in enumerate(lines, 1):
            stripped = line.strip()
            
            # Track namespace openings
            namespace_match = re.match(r'namespace\s+(\w+)', stripped)
            if namespace_match:
                namespace_stack.append((namespace_match.group(1), line_num))
            
            # Check namespace closings
            if stripped == '}' or stripped.startswith('} '):
                if namespace_stack:
                    namespace_name, _ = namespace_stack.pop()
                    # Check if this closing brace has a proper comment
                    if not re.match(r'}  // namespace \w+', stripped) and \
                       not re.match(r'} // namespace \w+', stripped):
                        # Allow simple '}' for single line or very short namespaces
                        # Only flag it if the namespace spans multiple lines
                        if line_num > 10:  # Heuristic for namespace length
                            issues.append(f"{file_path}:{line_num}: Missing namespace closing comment")
                            
    except Exception as e:
        issues.append(f"{file_path}: Error reading file - {e}")
    return issues


def check_indentation(file_path):
    """Check for consistent indentation (4 spaces)"""
    issues = []
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            for line_num, line in enumerate(f, 1):
                if line.strip() == '':
                    continue
                    
                # Check leading whitespace
                leading_space = len(line) - len(line.lstrip(' '))
                if leading_space > 0 and leading_space % 4 != 0:
                    # Allow some flexibility for alignment
                    if not re.match(r'.*[^\w\s].*', line.lstrip()):  # Not alignment
                        issues.append(f"{file_path}:{line_num}: Inconsistent indentation (not multiple of 4)")
                        break  # Only report first occurrence per file
                        
    except Exception as e:
        issues.append(f"{file_path}: Error reading file - {e}")
    return issues


def main():
    """Main validation function"""
    print_colored("🔍 Validating C++ code formatting...", 'blue')
    
    cpp_files = find_cpp_files()
    if not cpp_files:
        print_colored("❌ No C++ files found!", 'red')
        return 1
    
    print(f"Found {len(cpp_files)} C++ files to validate")
    
    all_issues = []
    
    # Run all checks
    checks = [
        ("Line length", check_line_length),
        ("Trailing whitespace", check_trailing_whitespace),
        ("Tab characters", check_tabs),
        ("Include guards", check_include_guards),
        ("Namespace comments", check_namespace_comments),
        ("Indentation", check_indentation),
    ]
    
    for check_name, check_func in checks:
        print(f"• Checking {check_name.lower()}...")
        check_issues = []
        
        for file_path in cpp_files:
            if check_name == "Line length":
                file_issues = check_func(file_path, 100)  # 100 char limit
            else:
                file_issues = check_func(file_path)
            check_issues.extend(file_issues)
        
        if check_issues:
            print_colored(f"  ⚠️  Found {len(check_issues)} issues", 'yellow')
            # Show first few issues
            for issue in check_issues[:3]:
                print(f"    {issue}")
            if len(check_issues) > 3:
                print(f"    ... and {len(check_issues) - 3} more")
            all_issues.extend(check_issues)
        else:
            print_colored(f"  ✅ No issues found", 'green')
    
    print()
    print("=== Summary ===")
    if not all_issues:
        print_colored("✅ All formatting checks passed!", 'green')
        print("The code should pass clang-format checks in CI.")
        return 0
    else:
        print_colored(f"⚠️  Found {len(all_issues)} formatting issues", 'yellow')
        print()
        print("Common fixes:")
        print("  • Run 'make format' to auto-fix most formatting issues")
        print("  • Ensure lines are under 100 characters")
        print("  • Use 4 spaces for indentation (no tabs)")
        print("  • Add namespace closing comments for long namespaces")
        print("  • Remove trailing whitespace")
        return min(len(all_issues), 10)  # Cap exit code


if __name__ == "__main__":
    sys.exit(main())