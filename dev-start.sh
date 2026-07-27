#!/bin/bash

# TeknoFixHub Development Environment Start

echo "🚀 TeknoFixHub Development Environment"
echo "======================================="
echo ""

# Make scripts executable
chmod +x scripts/*.sh

# Check requirements
echo "📋 Checking requirements..."

if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed"
    exit 1
fi

echo "✅ Node.js $(node -v)"
echo "✅ npm $(npm -v)"
echo ""

# Run setup
echo "📦 Installing dependencies..."
./scripts/setup.sh

echo ""
echo "✅ Development environment ready!"
echo ""
echo "🚀 To start development, run in separate terminals:"
echo ""
echo "Terminal 1 (Backend):"
echo "  cd backend && npm run dev"
echo ""
echo "Terminal 2 (Frontend):"
echo "  cd frontend && npm run dev"
echo ""
echo "Terminal 3 (Admin):"
echo "  cd admin && npm run dev"
echo ""
echo "🌐 Access services at:"
echo "   Frontend: http://localhost:3000"
echo "   Backend: http://localhost:5000"
echo "   Admin: http://localhost:3001"
echo ""
echo "Or use Docker:"
echo "  ./docker-start.sh"
