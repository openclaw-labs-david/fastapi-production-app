#!/bin/bash

# CI/CD Validation Script for FastAPI Production App
# Ensures code quality and dependency management standards

set -e

echo "🚀 Starting CI/CD Validation..."

# Check if poetry.lock exists
if [ ! -f "poetry.lock" ]; then
    echo "❌ ERROR: poetry.lock file not found"
    exit 1
fi

# Check poetry.lock file size (should not be empty)
if [ ! -s "poetry.lock" ]; then
    echo "❌ ERROR: poetry.lock file is empty"
    exit 1
fi

# Validate Dockerfile ENV format
if grep -q "ENV PYTHONDONTWRITEBYTECODE 1" Dockerfile; then
    echo "❌ ERROR: Dockerfile contains legacy ENV format"
    echo "   Please use: ENV PYTHONDONTWRITEBYTECODE=1"
    exit 1
fi

if grep -q "ENV PYTHONUNBUFFERED 1" Dockerfile; then
    echo "❌ ERROR: Dockerfile contains legacy ENV format"
    echo "   Please use: ENV PYTHONUNBUFFERED=1"
    exit 1
fi

# Check if poetry is installed
if ! command -v poetry &> /dev/null; then
    echo "⚠️  Poetry not found, installing..."
    pip install poetry
fi

# Validate poetry configuration
if ! poetry check; then
    echo "❌ ERROR: Poetry configuration validation failed"
    exit 1
fi

# Check if poetry.lock is synced with pyproject.toml
if ! poetry lock --check; then
    echo "❌ ERROR: poetry.lock is not synced with pyproject.toml"
    echo "   Run 'poetry lock' to regenerate the lock file"
    exit 1
fi

# Validate dependencies
if ! poetry install --sync; then
    echo "❌ ERROR: Dependency validation failed"
    exit 1
fi

# Run Python validation script
if [ -f "scripts/validate_dependencies.py" ]; then
    python scripts/validate_dependencies.py
    if [ $? -ne 0 ]; then
        echo "❌ ERROR: Python validation script failed"
        exit 1
    fi
fi

echo "✅ All validation checks passed!"
echo "✨ Ready for production deployment"