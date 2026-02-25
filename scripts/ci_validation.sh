#!/bin/bash

# CI/CD Validation Script for FastAPI Production App
# Ensures code quality and dependency management standards

set -uo pipefail

echo "🚀 Starting CI/CD Validation..."

# Track if any validation fails
VALIDATION_FAILED=false

# Check if uv.lock exists
if [ ! -f "uv.lock" ]; then
    echo "❌ ERROR: uv.lock file not found"
    VALIDATION_FAILED=true
fi

# Check uv.lock file size (should not be empty)
if [ ! -s "uv.lock" ]; then
    echo "❌ ERROR: uv.lock file is empty"
    VALIDATION_FAILED=true
fi

# Validate Dockerfile ENV format
if grep -q "ENV PYTHONDONTWRITEBYTECODE 1" Dockerfile; then
    echo "❌ ERROR: Dockerfile contains legacy ENV format"
    echo "   Please use: ENV PYTHONDONTWRITEBYTECODE=1"
    VALIDATION_FAILED=true
fi

if grep -q "ENV PYTHONUNBUFFERED 1" Dockerfile; then
    echo "❌ ERROR: Dockerfile contains legacy ENV format"
    echo "   Please use: ENV PYTHONUNBUFFERED=1"
    VALIDATION_FAILED=true
fi

echo "✅ Dockerfile ENV format is correct"

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "⚠️  UV not found, installing..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Validate UV configuration
set +e
UV_CHECK_OUTPUT=$(uv sync --check 2>&1)
UV_CHECK_EXIT=$?
set -e

if [ $UV_CHECK_EXIT -ne 0 ]; then
    echo "❌ ERROR: UV dependency validation failed"
    echo "$UV_CHECK_OUTPUT"
    VALIDATION_FAILED=true
else
    echo "✅ UV dependency validation passed"
fi

# Check uv.lock file integrity
if [ ! -f "uv.lock" ]; then
    echo "❌ ERROR: uv.lock file not found"
    exit 1
fi

if [ ! -s "uv.lock" ]; then
    echo "❌ ERROR: uv.lock file is empty"
    exit 1
fi

# Run Python validation script
if [ -f "scripts/validate_dependencies.py" ]; then
    python scripts/validate_dependencies.py
    if [ $? -ne 0 ]; then
        echo "❌ ERROR: Python validation script failed"
        VALIDATION_FAILED=true
    fi
fi

# Final validation check
if [ "$VALIDATION_FAILED" = true ]; then
    echo "❌ Some validation checks failed. Please fix the issues above."
    exit 1
else
    echo "✅ All validation checks passed!"
    echo "✨ Ready for production deployment"
fi