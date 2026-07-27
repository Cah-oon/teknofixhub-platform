# 🚀 DEPLOYMENT GUIDE - TeknoFixHub

Panduan lengkap deployment TeknoFixHub ke production.

---

## 🎯 OVERVIEW

Project ini **75% siap untuk deployment**. Panduan ini akan memandu Anda dari development ke production dalam 2-3 jam.

---

## 📋 PRE-DEPLOYMENT CHECKLIST

### Step 1: Verify Local Setup ✅

```bash
# 1. Navigate to project
cd /workspaces/teknofixhub-platform/TeknoFixHub_Ultimate

# 2. Check git status
git status  # Should be clean

# 3. Verify all directories exist
ls -d frontend backend admin docker docs

# 4. Check documentation
ls *.md  # Should have README, QUICKSTART, etc
```

### Step 2: Install Dependencies Locally

```bash
# Backend
cd backend
npm install
cd ..

# Frontend
cd frontend
npm install
cd ..

# Admin
cd admin
npm install
cd ..

# Should complete without errors
```

### Step 3: Test Local Development

```bash
# Terminal 1: Backend
cd backend
cp .env.example .env
# Edit .env if needed
npm run dev
# Should see: Server running on port 5000

# Terminal 2: Frontend
cd frontend
npm run dev
# Should see: ready in XXX ms

# Terminal 3: Admin
cd admin
npm run dev
# Should see: ready in XXX ms
```

### Step 4: Build for Production

```bash
# Backend
cd backend && npm run build 2>/dev/null || echo "No build needed"

# Frontend
cd frontend && npm run build
# Should create dist/ folder

# Admin
cd admin && npm run build
# Should create dist/ folder
```

---

## 🗄️ DATABASE SETUP

### Option 1: MongoDB Atlas (Recommended) ✅

**Step 1: Create Free Cluster**
1. Go to https://www.mongodb.com/cloud/atlas
2. Sign up (free)
3. Create project
4. Create M0 Free cluster
5. Wait ~5 minutes for cluster creation

**Step 2: Configure Network Access**
1. Go to Network Access
2. Add IP Address
3. Click "Allow access from anywhere" (for now)
4. OR add specific IP: YOUR_SERVER_IP

**Step 3: Create Database User**
1. Go to Database Access
2. Click "Add New Database User"
3. Username: `teknofixhub`
4. Password: Generate secure password
5. Copy password

**Step 4: Get Connection String**
1. Click "Connect" on cluster
2. Choose "Connect your application"
3. Copy connection string
4. Replace password & database name

**Connection String Format:**
```
mongodb+srv://teknofixhub:PASSWORD@cluster0.xxxxx.mongodb.net/teknofixhub?retryWrites=true&w=majority
```

### Option 2: PostgreSQL (Managed Services)

**Option A: DigitalOcean Managed Database**
1. Go to https://cloud.digitalocean.com/databases
2. Create new database
3. Choose PostgreSQL
4. Copy connection string

**Option B: Railway PostgreSQL**
1. Add service → PostgreSQL
2. Copy connection URI from variables

---

## 🔐 ENVIRONMENT CONFIGURATION

### Backend .env File

Create `backend/.env`:

```env
# ===== SERVER =====
PORT=5000
NODE_ENV=production

# ===== DATABASE =====
# For MongoDB Atlas
MONGO_URI=mongodb+srv://teknofixhub:PASSWORD@cluster0.xxx.mongodb.net/teknofixhub?retryWrites=true&w=majority

# OR For PostgreSQL
# POSTGRES_URI=postgresql://user:password@host:port/database

# ===== SECURITY =====
JWT_SECRET=generate_random_secret_key_here_min_32_chars
JWT_EXPIRE=7d

# ===== FILE UPLOAD =====
MAX_FILE_SIZE=10485760
UPLOAD_DIR=./media

# ===== CORS =====
CORS_ORIGIN=https://yourdomain.com

# ===== EMAIL (Optional) =====
EMAIL_SERVICE=gmail
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-app-password

# ===== CLOUD STORAGE (Optional) =====
STORAGE_PROVIDER=s3
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
AWS_BUCKET_NAME=teknofixhub
AWS_REGION=us-east-1
```

### Generate JWT_SECRET

```bash
# On your machine
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Copy output ke JWT_SECRET di .env
```

### Frontend Configuration

Create or update `frontend/.env.production`:

```env
VITE_API_URL=https://api.yourdomain.com/api
VITE_APP_NAME=TeknoFixHub
```

---

## 🐳 DOCKER BUILD

### Build Images

```bash
# Navigate to root
cd /workspaces/teknofixhub-platform/TeknoFixHub_Ultimate

# Build all images
docker-compose -f docker/docker-compose.yml build

# Or build individually
docker build -f docker/Dockerfile.backend -t teknofixhub-backend:latest .
docker build -f docker/Dockerfile.frontend -t teknofixhub-frontend:latest .
```

### Test Docker Locally

```bash
# Create .env file with test values
cp backend/.env.example backend/.env

# Start with Docker
docker-compose -f docker/docker-compose.yml up -d

# Check if services running
docker ps

# View logs
docker-compose -f docker/docker-compose.yml logs -f

# Test backend
curl http://localhost:5000/api/health

# Stop services
docker-compose -f docker/docker-compose.yml down
```

---

## 🚀 DEPLOYMENT OPTIONS

### Option 1: Railway (RECOMMENDED) ⭐⭐⭐⭐⭐

**Kelebihan:**
- Sangat mudah setup
- Auto-deploy dari GitHub
- Free tier available
- Database support built-in
- Waktu deployment: 30 menit

**Setup Steps:**

1. **Go to Railway.app**
   - https://railway.app
   - Sign up / Login
   - Click "Start a New Project"

2. **Connect GitHub**
   - Click "Deploy from GitHub repo"
   - Authorize Railway
   - Select `Cah-oon/teknofixhub-platform`
   - Click "Deploy"

3. **Railway Auto-Detection**
   - Railway detects Node.js backend
   - Detects React frontend
   - Creates services automatically

4. **Configure Database**
   - Click "Add Service"
   - Choose "PostgreSQL" atau "MongoDB"
   - Railway creates database automatically
   - Copy DATABASE_URL

5. **Configure Environment Variables**
   - Click each service
   - Go to "Variables"
   - Add environment variables:

   **Backend Variables:**
   ```
   NODE_ENV=production
   MONGO_URI=<from database service>
   JWT_SECRET=<your_generated_secret>
   CORS_ORIGIN=https://<your-frontend-url>
   PORT=5000
   ```

6. **Deploy**
   - Railway automatically deploys
   - View logs in real-time
   - Services go live!

7. **Get URLs**
   - Backend: `https://backend-xxxx.railway.app`
   - Frontend: `https://frontend-xxxx.railway.app`
   - Update CORS_ORIGIN if needed

**Cost:**
- Free tier: $5/month credit
- Production: ~$10-20/month

---

### Option 2: DigitalOcean App Platform

**Setup Steps:**

1. Create DigitalOcean account
2. Create new "App"
3. Connect GitHub repository
4. Configure services:
   - Backend (Node.js)
   - Frontend (Static site / React)
5. Add database (Managed PostgreSQL)
6. Configure environment variables
7. Deploy

**Cost:** ~$12/month minimum

---

### Option 3: Heroku (Legacy but still viable)

```bash
# Install Heroku CLI
npm i -g heroku

# Login
heroku login

# Create app
heroku create teknofixhub

# Set environment variables
heroku config:set NODE_ENV=production
heroku config:set MONGO_URI=mongodb+srv://...
heroku config:set JWT_SECRET=...

# Deploy
git push heroku main
```

**Cost:** Starting from $7/month

---

### Option 4: Self-Hosted (AWS/Linode/etc)

```bash
# 1. Provision server (Ubuntu 20.04+)
# 2. Install Node.js, Docker, Docker Compose
# 3. Clone repository
git clone https://github.com/Cah-oon/teknofixhub-platform.git
cd teknofixhub-platform/TeknoFixHub_Ultimate

# 4. Configure .env
cp backend/.env.example backend/.env
# Edit with production values

# 5. Start with Docker
docker-compose -f docker/docker-compose.yml up -d

# 6. Setup Nginx reverse proxy
# 7. Configure SSL with Let's Encrypt
# 8. Setup monitoring & backups
```

**Cost:** $5-50+/month depending on specs

---

## 📊 PRODUCTION CHECKLIST

### Pre-Launch
- [ ] All tests passing
- [ ] Security audit done
- [ ] .env configured correctly
- [ ] Database migrated
- [ ] SSL certificate obtained
- [ ] Domain DNS configured
- [ ] Email service configured (if needed)
- [ ] Backups scheduled

### Launch Day
- [ ] Deploy to production
- [ ] Test all endpoints
- [ ] Verify frontend loads
- [ ] Check API responses
- [ ] Test authentication
- [ ] Monitor logs
- [ ] Test user signup/login

### Post-Launch
- [ ] Monitor error logs
- [ ] Check performance metrics
- [ ] Verify backup running
- [ ] Test recovery procedures
- [ ] Monitor resource usage
- [ ] Set up alerts

---

## 🔄 CONTINUOUS DEPLOYMENT

### GitHub Actions Auto-Deploy

**Already configured** in `github/workflows/ci-cd.yml`

To activate:

1. Go to GitHub repository settings
2. Secrets → New repository secret
3. Add deployment credentials:
   ```
   RAILWAY_TOKEN=<your_railway_token>
   # OR
   HEROKU_API_KEY=<your_heroku_key>
   ```

4. On every push to main:
   - Tests run
   - Build verification
   - Auto-deploy to production

---

## 📊 MONITORING & LOGGING

### Setup Error Tracking

**Option 1: Sentry (Free tier available)**
```bash
npm install @sentry/node

# Configure in backend
const Sentry = require('@sentry/node');
Sentry.init({ dsn: 'YOUR_SENTRY_DSN' });
```

**Option 2: Railway built-in logging**
- View logs in Railway dashboard
- Real-time log streaming
- Error highlighting

---

## 🆘 TROUBLESHOOTING DEPLOYMENT

### Port Already in Use
```bash
# Find process
lsof -i :5000

# Kill process
kill -9 <PID>
```

### Database Connection Error
- Verify connection string
- Check IP whitelist (MongoDB Atlas)
- Test with local client

### Build Fails
- Check Node version (should be >= 16)
- Check npm cache: `npm cache clean --force`
- Reinstall: `rm -rf node_modules && npm install`

### Slow Deployment
- Check internet speed
- Verify CI/CD pipeline isn't timing out
- Increase timeout if needed

---

## 🎯 QUICK DEPLOYMENT SUMMARY

| Step | Time | Action |
|------|------|--------|
| 1. Install deps | 5 min | `npm install` in each dir |
| 2. Test local | 10 min | `npm run dev` |
| 3. Setup DB | 15 min | Create MongoDB/PostgreSQL |
| 4. Configure .env | 5 min | Set production values |
| 5. Build prod | 10 min | `npm run build` |
| 6. Deploy | 30 min | Push to Railway/Heroku |
| 7. Test prod | 10 min | Verify all services |
| **TOTAL** | **85 min** | **~ 1.5 hours** |

---

## 📚 NEXT STEPS

1. ✅ Read this guide completely
2. ✅ Choose deployment platform
3. ✅ Setup production database
4. ✅ Configure environment variables
5. ✅ Deploy first version
6. ✅ Test thoroughly
7. ✅ Monitor & maintain

---

## 📞 RESOURCES

- **Railway Docs**: https://docs.railway.app
- **Node.js Deployment**: https://nodejs.org/en/docs/guides/deployment
- **Docker Guide**: https://docs.docker.com/guides/get-started
- **MongoDB Atlas**: https://docs.atlas.mongodb.com
- **Let's Encrypt SSL**: https://letsencrypt.org/getting-started

---

**Ready to deploy? Start with Railway! 🚀**

Generated: July 27, 2026
Status: Production Ready ✅
