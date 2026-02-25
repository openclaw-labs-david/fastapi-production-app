#!/usr/bin/env python3
"""
Dependency validation script for FastAPI production app.
Checks that uv.lock is properly synced with pyproject.toml
"""

import subprocess
import sys
import os
from pathlib import Path

def check_uv_lock_sync():
    """Check if uv.lock is properly synced with pyproject.toml"""
    try:
        # Check if uv is available
        try:
            result = subprocess.run(
                ["uv", "sync", "--check"],
                capture_output=True,
                text=True,
                cwd=Path(__file__).parent.parent
            )
        except FileNotFoundError:
            print("❌ UV not found. Please install UV first.")
            return False
        
        # Check if the sync check passed
        if result.returncode != 0:
            print("❌ UV dependency validation failed")
            print(f"Error: {result.stderr}")
            return False
        
        # Check if uv.lock file exists and is not empty
        lock_file_path = Path(__file__).parent.parent / "uv.lock"
        if not lock_file_path.exists():
            print("❌ uv.lock file not found")
            return False
        
        if lock_file_path.stat().st_size == 0:
            print("❌ uv.lock file is empty")
            return False
        
        print("✅ uv.lock is properly synced with pyproject.toml")
        return True
        
    except Exception as e:
        print(f"❌ Error checking UV lock: {e}")
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

def validate_python_version():
    """Validate that Python version meets requirements"""
    try:
        import sys
        python_version = sys.version_info
        
        if python_version.major != 3 or python_version.minor < 10:
            print(f"❌ Python version {python_version.major}.{python_version.minor} does not meet requirement >=3.10")
            return False
        
        print(f"✅ Python version {python_version.major}.{python_version.minor} meets requirement >=3.10")
        return True
        
    except Exception as e:
        print(f"❌ Error validating Python version: {e}")
        return False

def main():
    """Run all validation checks"""
    print("🔍 Running dependency validation checks...\n")
    
    checks = [
        ("Python Version", validate_python_version),
        ("UV Lock Sync", check_uv_lock_sync),
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