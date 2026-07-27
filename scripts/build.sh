#!/bin/bash

# TeknoFixHub Build Script

echo "🏗️  Building TeknoFixHub..."

# Build Backend
echo "Building backend..."
cd backend
npm run build 2>/dev/null || echo "Backend build skipped"
cd ..

# Build Frontend
echo "Building frontend..."
cd frontend
npm run build
cd ..

# Build Admin
echo "Building admin..."
cd admin
npm run build
cd ..

echo "✅ Build complete!"
echo "📦 Ready for deployment"
