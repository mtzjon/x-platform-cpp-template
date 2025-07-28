#!/bin/bash

# Script to check formatting issues that might occur in CI

set -e

echo "🔍 Checking C++ formatting..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Find all C++ source files
SOURCE_FILES=$(find src include examples tests -name "*.cpp" -o -name "*.hpp" 2>/dev/null | sort)

if [ -z "$SOURCE_FILES" ]; then
    print_error "No C++ source files found!"
    exit 1
fi

echo "Found $(echo "$SOURCE_FILES" | wc -l) source files to check"

# Check basic formatting issues manually since clang-format might not be available

ISSUES_FOUND=0

echo ""
echo "Checking for common formatting issues..."

# Check for overly long lines (>120 characters)
echo "• Checking line length (max 120 characters)..."
LONG_LINES=$(grep -n ".\{121,\}" $SOURCE_FILES 2>/dev/null || true)
if [ -n "$LONG_LINES" ]; then
    print_warning "Found lines longer than 120 characters:"
    echo "$LONG_LINES" | head -10
    if [ $(echo "$LONG_LINES" | wc -l) -gt 10 ]; then
        echo "... and $(( $(echo "$LONG_LINES" | wc -l) - 10 )) more"
    fi
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    print_success "No overly long lines found"
fi

# Check for tabs instead of spaces
echo "• Checking for tabs..."
TAB_FILES=$(grep -l $'\t' $SOURCE_FILES 2>/dev/null || true)
if [ -n "$TAB_FILES" ]; then
    print_warning "Found files with tabs:"
    echo "$TAB_FILES"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    print_success "No tabs found"
fi

# Check for trailing whitespace
echo "• Checking for trailing whitespace..."
TRAILING_WS=$(grep -n " $" $SOURCE_FILES 2>/dev/null || true)
if [ -n "$TRAILING_WS" ]; then
    print_warning "Found trailing whitespace:"
    echo "$TRAILING_WS" | head -5
    if [ $(echo "$TRAILING_WS" | wc -l) -gt 5 ]; then
        echo "... and $(( $(echo "$TRAILING_WS" | wc -l) - 5 )) more"
    fi
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    print_success "No trailing whitespace found"
fi

# Check for inconsistent include ordering
echo "• Checking include order..."
for file in $SOURCE_FILES; do
    if [[ $file == *.cpp ]] || [[ $file == *.hpp ]]; then
        # Check if includes are roughly ordered (system includes after local)
        LOCAL_INCLUDES=$(grep -n '^#include "' "$file" 2>/dev/null | tail -1 | cut -d: -f1 || echo "0")
        SYSTEM_INCLUDES=$(grep -n '^#include <' "$file" 2>/dev/null | head -1 | cut -d: -f1 || echo "999")
        
        if [ "$LOCAL_INCLUDES" -gt "$SYSTEM_INCLUDES" ] && [ "$LOCAL_INCLUDES" != "0" ] && [ "$SYSTEM_INCLUDES" != "999" ]; then
            print_warning "Possible include order issue in $file (local includes should come before system includes)"
            ISSUES_FOUND=$((ISSUES_FOUND + 1))
        fi
    fi
done

# Check for missing namespace closing comments
echo "• Checking namespace closing comments..."
NAMESPACE_ISSUES=0
for file in $SOURCE_FILES; do
    if [[ $file == *.hpp ]] || [[ $file == *.cpp ]]; then
        # Look for namespace declarations and check if they have proper closing comments
        NAMESPACES=$(grep -n "^namespace " "$file" 2>/dev/null || true)
        if [ -n "$NAMESPACES" ]; then
            # Check if there are closing braces with comments
            CLOSING_COMMENTS=$(grep -n "^}  // namespace" "$file" 2>/dev/null || true)
            CLOSING_SIMPLE=$(grep -n "^} // namespace" "$file" 2>/dev/null || true)
            
            if [ -z "$CLOSING_COMMENTS" ] && [ -z "$CLOSING_SIMPLE" ]; then
                print_warning "Missing namespace closing comment in $file"
                NAMESPACE_ISSUES=$((NAMESPACE_ISSUES + 1))
            fi
        fi
    fi
done

if [ $NAMESPACE_ISSUES -eq 0 ]; then
    print_success "Namespace closing comments look good"
else
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
fi

# Check for consistent brace style
echo "• Checking brace style..."
BRACE_ISSUES=0
for file in $SOURCE_FILES; do
    # Check for opening braces on same line (Allman style should be avoided)
    WRONG_BRACES=$(grep -n ")\s*$" "$file" | grep -v "//" | head -5 2>/dev/null || true)
    if [ -n "$WRONG_BRACES" ]; then
        # Check if next line has opening brace
        while IFS= read -r line; do
            line_num=$(echo "$line" | cut -d: -f1)
            next_line_num=$((line_num + 1))
            next_line=$(sed -n "${next_line_num}p" "$file" 2>/dev/null || true)
            if [[ "$next_line" =~ ^[[:space:]]*\{[[:space:]]*$ ]]; then
                print_warning "Possible brace style issue in $file at line $line_num (prefer same-line braces)"
                BRACE_ISSUES=$((BRACE_ISSUES + 1))
                break
            fi
        done <<< "$WRONG_BRACES"
    fi
done

if [ $BRACE_ISSUES -eq 0 ]; then
    print_success "Brace style looks consistent"
else
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
fi

echo ""
echo "=== Summary ==="
if [ $ISSUES_FOUND -eq 0 ]; then
    print_success "✅ No major formatting issues found!"
    echo "The code should pass clang-format checks in CI."
else
    print_warning "⚠️  Found $ISSUES_FOUND potential formatting issues"
    echo "These might cause failures in CI clang-format checks."
    echo ""
    echo "To fix formatting issues:"
    echo "  1. Use 'make format' to auto-fix formatting"
    echo "  2. Or run clang-format manually on affected files"
    echo "  3. Check the .clang-format configuration for style rules"
fi

exit $ISSUES_FOUND