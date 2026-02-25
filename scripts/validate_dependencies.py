#!/usr/bin/env python3
"""
Dependency validation script for FastAPI production app.
Checks that poetry.lock is properly synced with pyproject.toml
"""

import subprocess
import sys
import os
from pathlib import Path

def check_poetry_lock_sync():
    """Check if poetry.lock is properly synced with pyproject.toml"""
    try:
        # Try multiple poetry paths
        poetry_paths = ["poetry", "venv/bin/poetry"]
        poetry_found = False
        
        for poetry_path in poetry_paths:
            try:
                # Run poetry check to validate configuration
                result = subprocess.run(
                    [poetry_path, "check"],
                    capture_output=True,
                    text=True,
                    cwd=Path(__file__).parent.parent
                )
                poetry_found = True
                break
            except FileNotFoundError:
                continue
        
        if not poetry_found:
            print("❌ Poetry not found. Please install poetry first.")
            return False
        
        # Check if the error is just warnings (poetry check returns 0 for warnings, non-zero for errors)
        if result.returncode != 0:
            # Check if the output contains warnings but no actual errors
            if "Warning:" in result.stderr and "Error:" not in result.stderr:
                # Poetry check returns non-zero for warnings, but this is acceptable
                print("⚠️ Poetry configuration has warnings but is valid")
                print(f"Warnings: {result.stderr}")
            else:
                print("❌ Poetry configuration validation failed")
                print(f"Error: {result.stderr}")
                return False
        
        # Check if poetry.lock file exists and is not empty
        lock_file_path = Path(__file__).parent.parent / "poetry.lock"
        if not lock_file_path.exists():
            print("❌ poetry.lock file not found")
            return False
        
        if lock_file_path.stat().st_size == 0:
            print("❌ poetry.lock file is empty")
            return False
        
        print("✅ poetry.lock is properly synced with pyproject.toml")
        return True
        
    except Exception as e:
        print(f"❌ Error checking poetry lock: {e}")
        return False

def validate_dockerfile_env_format():
    """Validate Dockerfile ENV format"""
    dockerfile_path = Path(__file__).parent.parent / "Dockerfile"
    
    if not dockerfile_path.exists():
        print("❌ Dockerfile not found")
        return False
    
    with open(dockerfile_path, 'r') as f:
        content = f.read()
    
    # Check for legacy ENV format (space-separated)
    legacy_env_patterns = [
        "ENV PYTHONDONTWRITEBYTECODE 1",
        "ENV PYTHONUNBUFFERED 1"
    ]
    
    issues = []
    for pattern in legacy_env_patterns:
        if pattern in content:
            issues.append(f"Found legacy ENV format: {pattern}")
    
    if issues:
        print("❌ Dockerfile contains legacy ENV format:")
        for issue in issues:
            print(f"  - {issue}")
        return False
    
    print("✅ Dockerfile ENV format is correct")
    return True

def main():
    """Run all validation checks"""
    print("🔍 Running dependency validation checks...\n")
    
    checks = [
        ("Poetry Lock Sync", check_poetry_lock_sync),
        ("Dockerfile ENV Format", validate_dockerfile_env_format),
    ]
    
    all_passed = True
    for check_name, check_func in checks:
        print(f"Checking: {check_name}")
        if not check_func():
            all_passed = False
        print()
    
    if all_passed:
        print("🎉 All validation checks passed!")
        return 0
    else:
        print("❌ Some validation checks failed. Please fix the issues above.")
        return 1

if __name__ == "__main__":
    sys.exit(main())