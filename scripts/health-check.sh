#!/bin/bash
# health-check.sh - Simple health check script for deployment

set -e

echo "🏥 Running health checks..."

# Check backend
echo "Checking backend..."
curl -f http://localhost:5000/api/health || { echo "❌ Backend health check failed"; exit 1; }
echo "✅ Backend health check passed"

# Check frontend
echo "Checking frontend..."
curl -f http://localhost:3000 || { echo "❌ Frontend health check failed"; exit 1; }
echo "✅ Frontend health check passed"

echo "✅ All health checks passed!"
