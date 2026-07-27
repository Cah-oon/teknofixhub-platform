# TeknoFixHub Installation Guide

Panduan lengkap instalasi dan setup project TeknoFixHub.

## 📋 Requirements

- Node.js >= 16.x
- npm >= 8.x atau yarn >= 3.x
- MongoDB >= 5.0 atau PostgreSQL >= 13
- Docker & Docker Compose (optional)
- Git

## 🔧 Step-by-Step Installation

### 1. Clone Repository

```bash
git clone https://github.com/yourusername/teknofixhub.git
cd teknofixhub
```

### 2. Backend Setup

```bash
cd backend

# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Edit .env dengan database credentials Anda
nano .env

# Run migrations
npm run migrate

# Start server
npm run dev
```

Server akan berjalan di `http://localhost:5000`

### 3. Frontend Setup

```bash
cd ../frontend

# Install dependencies
npm install

# Start development server
npm run dev
```

Frontend akan berjalan di `http://localhost:3000`

### 4. Admin Dashboard Setup

```bash
cd ../admin

# Install dependencies
npm install

# Start admin
npm run dev
```

Admin akan berjalan di `http://localhost:3001`

## 🐳 Docker Installation (Recommended)

```bash
# Build dan run semua services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

Services akan berjalan di:
- Frontend: http://localhost:3000
- Backend: http://localhost:5000
- Admin: http://localhost:3001
- MongoDB: localhost:27017

## ✅ Verification

Cek apakah semuanya berjalan dengan baik:

```bash
# Check backend
curl http://localhost:5000/api/health

# Check frontend (buka di browser)
http://localhost:3000
```

## 📝 Environment Variables

Lihat file `.env.example` di folder backend untuk variabel yang diperlukan.

### Contoh .env

```
PORT=5000
MONGO_URI=mongodb://localhost:27017/teknofixhub
JWT_SECRET=your_secret_key_here
NODE_ENV=development
```

## 🆘 Troubleshooting

### Port sudah digunakan?

```bash
# Cek port yang digunakan
lsof -i :5000  # untuk backend
lsof -i :3000  # untuk frontend

# Kill process
kill -9 <PID>
```

### Database connection error?

Pastikan MongoDB/PostgreSQL berjalan dan connection string sudah benar di .env

### Module not found?

```bash
# Clear npm cache dan reinstall
rm -rf node_modules package-lock.json
npm install
```

## 🎉 Setup Complete!

Selamat! Project sudah siap untuk development. Silakan baca dokumentasi lainnya untuk info lebih lanjut.
