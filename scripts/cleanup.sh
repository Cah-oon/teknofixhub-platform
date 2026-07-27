#!/bin/bash

# TeknoFixHub Cleanup Script

echo "🧹 Cleaning up..."

# Clean node_modules and lock files
echo "Removing node_modules..."
find . -name "node_modules" -type d -exec rm -rf {} + 2>/dev/null

echo "Removing lock files..."
find . -name "package-lock.json" -delete
find . -name "yarn.lock" -delete

# Clean build artifacts
echo "Removing build artifacts..."
find . -name "dist" -type d -exec rm -rf {} + 2>/dev/null
find . -name "build" -type d -exec rm -rf {} + 2>/dev/null

# Clean cache
echo "Removing cache files..."
find . -name ".cache" -type d -exec rm -rf {} + 2>/dev/null
find . -name ".eslintcache" -delete

echo "✅ Cleanup complete!"
