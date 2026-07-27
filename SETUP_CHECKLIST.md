# 📋 TeknoFixHub Setup Checklist

Panduan lengkap untuk setup dan memulai development TeknoFixHub.

## ✅ Pre-Setup Checklist

### System Requirements
- [ ] Node.js >= 16.x installed
- [ ] npm >= 8.x installed
- [ ] Git installed and configured
- [ ] Code editor installed (VS Code recommended)
- [ ] 2GB free disk space minimum
- [ ] Internet connection

### Verify Installation
```bash
node --version  # Should be >= 16.x
npm --version   # Should be >= 8.x
git --version   # Should be installed
docker --version  # Optional but recommended
```

## 📦 Initial Setup (Choose One)

### Option 1: Automated Setup ✅ RECOMMENDED

```bash
cd /workspaces/teknofixhub-platform/TeknoFixHub_Ultimate
./dev-start.sh
```

**Apa yang dilakukan:**
- ✅ Memeriksa Node.js
- ✅ Menginstall dependencies untuk semua services
- ✅ Membuat environment files

**Waktu:** ~5-10 menit

### Option 2: Manual Setup

```bash
# Backend
cd backend
npm install
cp .env.example .env
# Edit .env dengan konfigurasi Anda

# Frontend
cd ../frontend
npm install

# Admin
cd ../admin
npm install
```

**Waktu:** ~10-15 menit

### Option 3: Docker Setup

```bash
./docker-start.sh
```

**Keuntungan:**
- Isolated environment
- No dependency conflicts
- Easier to manage

**Waktu:** ~5 menit (setelah Docker image built)

## 🔧 Configuration

### Backend Configuration

Edit `backend/.env`:

```env
# Required
PORT=5000
MONGO_URI=mongodb://localhost:27017/teknofixhub
JWT_SECRET=your_secret_key_change_this

# Optional
NODE_ENV=development
CORS_ORIGIN=http://localhost:3000
```

### Frontend Configuration

Default `.env`:
```env
VITE_API_URL=http://localhost:5000/api
```

Jika localhost tidak cocok, sesuaikan dengan backend URL Anda.

## 🗄️ Database Setup

### Using Docker (Easiest)

```bash
# MongoDB
docker run -d -p 27017:27017 --name mongodb \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=admin123 \
  mongo:6.0

# PostgreSQL (Alternative)
docker run -d -p 5432:5432 --name postgres \
  -e POSTGRES_USER=teknofixhub \
  -e POSTGRES_PASSWORD=teknofixhub123 \
  -e POSTGRES_DB=teknofixhub \
  postgres:15
```

### Using Local Installation

Lihat dokumentasi untuk MongoDB atau PostgreSQL resmi.

## 🚀 Start Development

### Terminal 1: Backend
```bash
cd backend
npm run dev
# Output: Server running on port 5000
```

### Terminal 2: Frontend
```bash
cd frontend
npm run dev
# Output: VITE v4.1.0 ready in 500 ms
```

### Terminal 3: Admin Dashboard
```bash
cd admin
npm run dev
# Output: VITE v4.1.0 ready in 500 ms
```

### Verify Everything Works

- [ ] Backend: http://localhost:5000/api/health
- [ ] Frontend: http://localhost:3000
- [ ] Admin: http://localhost:3001

## 📝 First Tasks

### 1. Explore the Project
```bash
# Read main README
cat README.md

# Read quick start guide
cat QUICKSTART.md

# Check documentation
ls docs/
```

### 2. Test API Connection
```bash
# Open in browser
http://localhost:5000/api/health

# Should return
{ "status": "OK", "message": "Server is running" }
```

### 3. Make First Changes
- Edit `frontend/src/App.jsx`
- Edit `backend/src/index.js`
- See hot reload in action

### 4. Create Feature Branch
```bash
git checkout -b feature/your-feature-name
```

### 5. Setup IDE Extensions (VS Code)

Recommended Extensions:
- [ ] ES7+ React/Redux/React-Native snippets
- [ ] Prettier - Code formatter
- [ ] ESLint
- [ ] Thunder Client / REST Client
- [ ] MongoDB for VS Code (optional)
- [ ] PostgreSQL (optional)
- [ ] Docker
- [ ] Git Graph

## 🧪 Testing Setup

### Backend Tests
```bash
cd backend
npm test
```

### Frontend Tests
```bash
cd frontend
npm test
```

### Check Test Coverage
```bash
npm test -- --coverage
```

## 📚 Documentation Review

Read in this order:

1. [ ] [QUICKSTART.md](./QUICKSTART.md) - Overview
2. [ ] [docs/INSTALLATION.md](./docs/INSTALLATION.md) - Setup detail
3. [ ] [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md) - System design
4. [ ] [docs/DEVELOPMENT.md](./docs/DEVELOPMENT.md) - Dev guide
5. [ ] [backend/README.md](./backend/README.md) - Backend guide
6. [ ] [frontend/README.md](./frontend/README.md) - Frontend guide
7. [ ] [api/API_DOCUMENTATION.md](./api/API_DOCUMENTATION.md) - API reference

## 🔐 Security Setup

### Generate JWT Secret
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

Add to `backend/.env`:
```env
JWT_SECRET=your_generated_secret_here
```

### Password Hashing
Backend sudah menggunakan bcryptjs. Pastikan:
- [ ] Never store plain passwords
- [ ] Always hash before storing
- [ ] Use salt rounds >= 10

## 🐳 Docker (Optional)

### Build Images
```bash
docker-compose build
```

### Start Services
```bash
docker-compose up -d
```

### View Logs
```bash
docker-compose logs -f
```

### Stop Services
```bash
docker-compose down
```

## ✨ Pre-Launch Checklist

### Code Quality
- [ ] Run linter: `npm run lint`
- [ ] Format code: `npm run format`
- [ ] Run tests: `npm test`
- [ ] Check console for errors

### Functionality
- [ ] Test authentication flow
- [ ] Test blog creation
- [ ] Test product catalog
- [ ] Test affiliate system
- [ ] Test admin dashboard

### Performance
- [ ] Check network tab (< 3s load)
- [ ] Check bundle size
- [ ] Monitor API response time

### Security
- [ ] JWT tokens working
- [ ] CORS properly configured
- [ ] No sensitive data in logs
- [ ] Passwords hashed

### Documentation
- [ ] README.md complete
- [ ] API docs updated
- [ ] Comments added
- [ ] Architecture documented

## 🚨 Troubleshooting Checklist

| Problem | Solution |
|---------|----------|
| Port already in use | Kill process: `lsof -i :5000 \| kill -9` |
| Module not found | Reinstall: `rm -rf node_modules && npm install` |
| Database error | Check DB running: `mongosh` or `psql` |
| CORS error | Check CORS_ORIGIN in .env |
| Hot reload not working | Restart server and clear cache |
| Node version error | Install correct Node: `nvm install 18` |

## 📊 Project Statistics

- **Total Files**: 50+
- **Total Lines of Code**: 5000+
- **Documentation**: 10+ guides
- **Code Examples**: 20+
- **Scripts**: 5 automation scripts
- **Configuration Files**: 10+

## 🎯 Next Steps

### Immediate (Today)
1. [ ] Complete setup
2. [ ] Verify all services running
3. [ ] Read QUICKSTART.md
4. [ ] Explore project structure

### Short Term (This Week)
1. [ ] Read all documentation
2. [ ] Create first feature branch
3. [ ] Make small code change
4. [ ] Submit first pull request

### Medium Term (This Month)
1. [ ] Implement major feature
2. [ ] Write tests
3. [ ] Deploy to staging
4. [ ] Get code review

### Long Term
1. [ ] Add new features
2. [ ] Performance optimization
3. [ ] Scalability improvements
4. [ ] Production deployment

## 💬 Getting Help

### Documentation
- Check relevant README files
- Read docs/ folder
- Check API documentation

### Debugging
- Use browser DevTools
- Check server logs
- Use Postman for API testing
- Check browser console

### Community
- Ask teammates
- Search GitHub issues
- Check stack overflow
- Read source code comments

## 📞 Support Contacts

- **Project Lead**: [Name]
- **DevOps**: [Name]
- **Frontend Lead**: [Name]
- **Backend Lead**: [Name]

## ✅ Completion Checklist

- [ ] All prerequisites installed
- [ ] Project cloned successfully
- [ ] Dependencies installed
- [ ] Database configured
- [ ] All 3 services running
- [ ] No error messages
- [ ] Can access all URLs
- [ ] Documentation read
- [ ] First commit made
- [ ] Ready to develop!

---

## 🎉 You're All Set!

Jika Anda sudah menyelesaikan semua checklist di atas, Anda siap untuk:

✅ Start developing features
✅ Create pull requests
✅ Contribute to the project
✅ Collaborate with team

## 📖 Quick Reference

**Common Commands:**
```bash
# Development
npm run dev          # Start dev server
npm run build        # Build production
npm run test         # Run tests
npm run lint         # Check code quality

# Database
npm run migrate      # Run migrations
npm run seed         # Seed database
npm run backup       # Backup database

# Docker
docker-compose up    # Start all services
docker-compose down  # Stop all services
docker-compose logs  # View logs

# Utilities
./dev-start.sh       # Setup dev environment
./docker-start.sh    # Setup with Docker
./scripts/cleanup.sh # Clean node_modules
```

**Important URLs (Local Dev):**
- Frontend: http://localhost:3000
- Backend: http://localhost:5000
- Admin: http://localhost:3001
- API Health: http://localhost:5000/api/health

---

**Selamat mengembangkan! Happy Coding! 🚀**

Terakhir diupdate: July 27, 2024
