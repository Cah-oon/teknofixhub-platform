#!/bin/bash

# TeknoFixHub Setup Script

echo "🚀 TeknoFixHub Setup"
echo "===================="
echo ""

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed"
    exit 1
fi

echo "✅ Node.js version: $(node -v)"
echo ""

# Backend Setup
echo "📦 Setting up Backend..."
cd backend
npm install
cp .env.example .env
echo "✅ Backend setup complete"
cd ..
echo ""

# Frontend Setup
echo "📦 Setting up Frontend..."
cd frontend
npm install
echo "✅ Frontend setup complete"
cd ..
echo ""

# Admin Setup
echo "📦 Setting up Admin..."
cd admin
npm install
echo "✅ Admin setup complete"
cd ..
echo ""

echo "🎉 Setup complete!"
echo ""
echo "📝 Next steps:"
echo "1. Edit backend/.env with your database credentials"
echo "2. Run 'npm run dev' in separate terminals for:"
echo "   - Backend: cd backend && npm run dev"
echo "   - Frontend: cd frontend && npm run dev"
echo "   - Admin: cd admin && npm run dev"
echo ""
echo "🌐 Services will be available at:"
echo "   - Frontend: http://localhost:3000"
echo "   - Backend: http://localhost:5000"
echo "   - Admin: http://localhost:3001"
