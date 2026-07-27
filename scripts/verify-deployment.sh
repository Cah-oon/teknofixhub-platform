#!/bin/bash
# verify-deployment.sh - Comprehensive deployment verification script

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║         TEKNOFIXHUB DEPLOYMENT VERIFICATION SCRIPT             ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

ERROR_COUNT=0
SUCCESS_COUNT=0

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_file() {
    local file=$1
    local name=$2
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅${NC} $name"
        ((SUCCESS_COUNT++))
    else
        echo -e "${RED}❌${NC} $name MISSING"
        ((ERROR_COUNT++))
    fi
}

check_dir() {
    local dir=$1
    local name=$2
    
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✅${NC} $name"
        ((SUCCESS_COUNT++))
    else
        echo -e "${RED}❌${NC} $name MISSING"
        ((ERROR_COUNT++))
    fi
}

check_command() {
    local cmd=$1
    local name=$2
    
    if command -v $cmd &> /dev/null; then
        echo -e "${GREEN}✅${NC} $name installed"
        ((SUCCESS_COUNT++))
    else
        echo -e "${YELLOW}⚠️${NC} $name not installed (optional)"
    fi
}

echo "📁 CHECKING DIRECTORIES..."
check_dir "frontend" "Frontend application"
check_dir "backend" "Backend API"
check_dir "admin" "Admin dashboard"
check_dir "database" "Database migrations"
check_dir "docker" "Docker configuration"
check_dir "docs" "Documentation"
check_dir "scripts" "Utility scripts"
echo ""

echo "📄 CHECKING CRITICAL FILES..."
check_file "backend/package.json" "Backend package.json"
check_file "frontend/package.json" "Frontend package.json"
check_file "admin/package.json" "Admin package.json"
check_file "backend/.env.example" "Backend .env template"
check_file "docker-compose.yml" "Docker compose file"
check_file "docker/Dockerfile.backend" "Backend Dockerfile"
check_file "docker/Dockerfile.frontend" "Frontend Dockerfile"
check_file ".gitignore" "Git ignore file"
check_file "README.md" "Main README"
check_file "QUICKSTART.md" "Quick start guide"
check_file "DEPLOYMENT_READY.md" "Deployment guide"
echo ""

echo "📝 CHECKING DOCUMENTATION..."
check_file "docs/INSTALLATION.md" "Installation guide"
check_file "docs/DEVELOPMENT.md" "Development guide"
check_file "docs/ARCHITECTURE.md" "Architecture documentation"
check_file "docs/DEPLOYMENT.md" "Deployment documentation"
check_file "api/API_DOCUMENTATION.md" "API documentation"
echo ""

echo "🛠️ CHECKING SCRIPTS..."
check_file "scripts/setup.sh" "Setup script"
check_file "scripts/build.sh" "Build script"
check_file "scripts/backup.sh" "Backup script"
check_file "dev-start.sh" "Dev start script"
check_file "docker-start.sh" "Docker start script"
echo ""

echo "🔧 CHECKING SYSTEM REQUIREMENTS..."
check_command "node" "Node.js"
check_command "npm" "npm"
check_command "git" "Git"
check_command "docker" "Docker"
echo ""

echo "📊 VALIDATION RESULTS"
echo "════════════════════════════════════════════════════════════════"
echo -e "${GREEN}✅ Passed: $SUCCESS_COUNT${NC}"
echo -e "${RED}❌ Failed: $ERROR_COUNT${NC}"
echo ""

if [ $ERROR_COUNT -eq 0 ]; then
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║          ✅ ALL CHECKS PASSED - READY TO DEPLOY!              ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Install dependencies: npm install in each directory"
    echo "2. Configure environment: Create .env files"
    echo "3. Start development: ./dev-start.sh"
    echo "4. Deploy: Follow DEPLOYMENT_READY.md guide"
    exit 0
else
    echo -e "${RED}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║          ❌ SOME CHECKS FAILED - FIX ISSUES FIRST             ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════════╝${NC}"
    exit 1
fi
