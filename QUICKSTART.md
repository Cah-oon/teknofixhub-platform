# 🚀 TeknoFixHub - Web Blog Platform Lengkap

Platform blog teknologi terpadu dengan fitur e-commerce, affiliate program, dan IoT integration.

## 📋 Daftar Isi

1. [Overview](#overview)
2. [Fitur Utama](#fitur-utama)
3. [Tech Stack](#tech-stack)
4. [Instalasi Cepat](#instalasi-cepat)
5. [Struktur Project](#struktur-project)
6. [Setup & Konfigurasi](#setup--konfigurasi)
7. [Development Workflow](#development-workflow)
8. [Deployment](#deployment)
9. [Dokumentasi](#dokumentasi)
10. [Troubleshooting](#troubleshooting)

---

## Overview

TeknoFixHub adalah platform blog dan e-commerce modern yang dirancang untuk tech enthusiasts dan profesional. Platform ini menyediakan:

- 📝 **Blog Platform** - Publish dan manage konten teknis
- 🛒 **E-Commerce** - Jual produk dan digital goods
- 💰 **Affiliate Program** - Earning program untuk publishers
- 📱 **Admin Dashboard** - Comprehensive management interface
- 🔌 **IoT Integration** - Support untuk IoT devices dan firmware
- 🐳 **Containerized** - Production-ready Docker setup

---

## Fitur Utama

### 👥 User Features
- ✅ User authentication & authorization
- ✅ Profile management
- ✅ Comment & discussion system
- ✅ Newsletter subscription
- ✅ Wishlist & favorites
- ✅ Search & filtering

### 📝 Blog Features
- ✅ Article creation & editing
- ✅ Category & tag management
- ✅ SEO optimization
- ✅ Draft & scheduled publishing
- ✅ Article analytics
- ✅ Comment moderation

### 🛍️ E-Commerce Features
- ✅ Product catalog
- ✅ Shopping cart
- ✅ Order management
- ✅ Payment integration
- ✅ Inventory tracking
- ✅ Customer reviews

### 💳 Affiliate Features
- ✅ Affiliate dashboard
- ✅ Commission tracking
- ✅ Real-time earnings
- ✅ Withdrawal management
- ✅ Marketing materials
- ✅ Performance analytics

### 🔧 Admin Features
- ✅ Complete dashboard
- ✅ User management
- ✅ Content moderation
- ✅ Sales analytics
- ✅ Settings management
- ✅ Activity logs

---

## Tech Stack

### Frontend
- **Framework**: React 18.2
- **Build Tool**: Vite 4.1
- **Styling**: Tailwind CSS 3.2
- **State Management**: Zustand 4.3
- **HTTP Client**: Axios 1.3
- **Routing**: React Router 6.8

### Backend
- **Runtime**: Node.js 18+
- **Framework**: Express.js 4.18
- **Database**: MongoDB 6.0 / PostgreSQL 15
- **Authentication**: JWT (JSON Web Token)
- **ORM/ODM**: Mongoose 7.0
- **File Upload**: Multer 1.4
- **Password Hashing**: bcryptjs 2.4

### DevOps
- **Containerization**: Docker & Docker Compose
- **Reverse Proxy**: Nginx
- **Cache**: Redis 7
- **CI/CD**: GitHub Actions
- **Version Control**: Git

---

## Instalasi Cepat

### Option 1: Manual Setup (Development)

```bash
# Clone repository
cd /workspaces/teknofixhub-platform/TeknoFixHub_Ultimate

# Run setup script
./dev-start.sh

# Or manual installation
# Backend
cd backend && npm install && npm run dev

# Frontend (terminal baru)
cd frontend && npm install && npm run dev

# Admin (terminal baru)
cd admin && npm install && npm run dev
```

**Akses di:**
- Frontend: http://localhost:3000
- Backend: http://localhost:5000
- Admin: http://localhost:3001

### Option 2: Docker Setup (Production-like)

```bash
# Start all services with Docker
./docker-start.sh

# Or manual
docker-compose up -d
```

Services akan berjalan di:
- Frontend: http://localhost:3000
- Backend: http://localhost:5000
- Admin: http://localhost:3001
- MongoDB: localhost:27017
- PostgreSQL: localhost:5432
- Redis: localhost:6379

---

## Struktur Project

```
TeknoFixHub_Ultimate/
│
├── 📁 frontend/                 # React Frontend
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── hooks/
│   │   ├── stores/             # Zustand state
│   │   ├── services/           # API services
│   │   └── styles/
│   ├── package.json
│   ├── vite.config.js
│   └── README.md
│
├── 📁 backend/                  # Node.js Express Backend
│   ├── src/
│   │   ├── controllers/        # Request handlers
│   │   ├── models/             # Database schemas
│   │   ├── routes/             # API routes
│   │   ├── middleware/         # Custom middleware
│   │   ├── services/           # Business logic
│   │   ├── config/             # Configuration
│   │   └── index.js            # Entry point
│   ├── tests/
│   ├── package.json
│   ├── .env.example
│   └── README.md
│
├── 📁 admin/                    # Admin Dashboard (React)
│   ├── src/
│   ├── package.json
│   └── README.md
│
├── 📁 api/                      # API Documentation
│   ├── API_DOCUMENTATION.md    # Complete API docs
│   ├── POSTMAN_COLLECTION.md   # Postman collection
│   └── examples/
│
├── 📁 database/                 # Database Setup
│   ├── migrations.sql          # Database migrations
│   ├── README.md
│   └── seeds/
│
├── 📁 docker/                   # Docker Configuration
│   ├── docker-compose.yml      # Compose file
│   ├── Dockerfile.backend
│   ├── Dockerfile.frontend
│   ├── nginx/
│   │   └── nginx.conf
│   └── README.md
│
├── 📁 docs/                     # Documentation
│   ├── INSTALLATION.md         # Setup guide
│   ├── ARCHITECTURE.md         # System architecture
│   ├── API_STRUCTURE.md        # API design
│   ├── DEVELOPMENT.md          # Dev guide
│   ├── DEPLOYMENT.md           # Deploy guide
│   └── README.md
│
├── 📁 config/                   # Configuration Files
│   ├── app.config.js           # App configuration
│   ├── database.config.js      # Database config
│   └── README.md
│
├── 📁 scripts/                  # Utility Scripts
│   ├── setup.sh               # Setup script
│   ├── build.sh               # Build script
│   ├── backup.sh              # Backup script
│   └── cleanup.sh             # Cleanup script
│
├── 📁 products/                 # Product Catalog
│   ├── products.json          # Sample products
│   └── README.md
│
├── 📁 affiliate/                # Affiliate Program
│   └── README.md
│
├── 📁 firmware/                 # IoT Firmware
│   └── README.md
│
├── 📁 github/                   # GitHub Workflows
│   └── workflows/
│       └── ci-cd.yml          # CI/CD pipeline
│
├── 📁 assets/                   # Static Assets
│   ├── images/
│   ├── icons/
│   ├── fonts/
│   └── README.md
│
├── 📁 public/                   # Public Resources
│   └── README.md
│
├── 📁 media/                    # Media Storage
├── 📁 storage/                  # Cloud Storage Config
├── 📁 logs/                     # Application Logs
├── 📁 backups/                  # Database Backups
│
├── 📄 package.json             # Root package.json
├── 📄 .gitignore               # Git ignore rules
├── 📄 dev-start.sh             # Start dev environment
├── 📄 docker-start.sh          # Start with Docker
└── 📄 README.md                # This file
```

---

## Setup & Konfigurasi

### 1. Environment Variables

#### Backend (.env)

```bash
# Server
PORT=5000
NODE_ENV=development

# Database
MONGO_URI=mongodb://localhost:27017/teknofixhub
DB_NAME=teknofixhub
# Atau untuk PostgreSQL
POSTGRES_URI=postgresql://user:pass@localhost:5432/teknofixhub

# Authentication
JWT_SECRET=your_secret_key_here
JWT_EXPIRE=7d

# File Upload
MAX_FILE_SIZE=10485760
UPLOAD_DIR=../media

# CORS
CORS_ORIGIN=http://localhost:3000

# Email (Optional)
EMAIL_SERVICE=gmail
EMAIL_USER=your_email@gmail.com
EMAIL_PASS=your_app_password

# Cloud Storage (Optional)
STORAGE_PROVIDER=s3
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
AWS_BUCKET_NAME=teknofixhub
AWS_REGION=us-east-1
```

#### Frontend (.env)

```bash
VITE_API_URL=http://localhost:5000/api
VITE_APP_NAME=TeknoFixHub
```

### 2. Database Setup

#### MongoDB (Default)

```bash
# Start MongoDB
docker run -d -p 27017:27017 --name teknofixhub-mongo -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=admin123 mongo:6.0

# Connect
mongodb://admin:admin123@localhost:27017/teknofixhub
```

#### PostgreSQL (Alternative)

```bash
# Start PostgreSQL
docker run -d -p 5432:5432 --name teknofixhub-postgres -e POSTGRES_USER=teknofixhub -e POSTGRES_PASSWORD=teknofixhub123 -e POSTGRES_DB=teknofixhub postgres:15

# Run migrations
psql -U teknofixhub -d teknofixhub -f database/migrations.sql
```

### 3. Install Dependencies

```bash
# Backend
cd backend && npm install

# Frontend
cd frontend && npm install

# Admin
cd admin && npm install
```

---

## Development Workflow

### Terminal 1: Backend

```bash
cd backend
npm run dev
# Running on http://localhost:5000
```

### Terminal 2: Frontend

```bash
cd frontend
npm run dev
# Running on http://localhost:3000
```

### Terminal 3: Admin

```bash
cd admin
npm run dev
# Running on http://localhost:3001
```

### Hot Reload

Semua services support hot reload:
- **Backend**: Nodemon watches file changes
- **Frontend**: Vite HMR untuk instant updates
- **Admin**: Vite HMR untuk instant updates

### Testing

```bash
# Backend tests
cd backend && npm test

# Frontend tests
cd frontend && npm test

# Run with coverage
npm test -- --coverage
```

### Linting & Formatting

```bash
# Lint code
npm run lint

# Format code
npm run format

# Fix linting issues
npm run lint --fix
```

---

## Deployment

### Build Production

```bash
# Build all services
./scripts/build.sh

# Or individual
cd frontend && npm run build
cd backend && npm run build
cd admin && npm run build
```

### Docker Deployment

```bash
# Build images
docker-compose build

# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f service_name
```

### Cloud Deployment Options

- **Heroku**: Use Procfile & buildpacks
- **AWS**: EC2 + RDS + S3
- **DigitalOcean**: App Platform or Droplets
- **Vercel**: Frontend only
- **Railway**: Full-stack deployment
- **Render**: Full-stack deployment

---

## Dokumentasi

### Important Files

| File | Purpose |
|------|---------|
| [docs/INSTALLATION.md](./docs/INSTALLATION.md) | Setup guide |
| [docs/README.md](./docs/README.md) | Dokumentasi index |
| [api/API_DOCUMENTATION.md](./api/API_DOCUMENTATION.md) | API reference |
| [backend/README.md](./backend/README.md) | Backend guide |
| [frontend/README.md](./frontend/README.md) | Frontend guide |
| [admin/README.md](./admin/README.md) | Admin guide |
| [database/README.md](./database/README.md) | Database schema |

### External Resources

- [Express.js Docs](https://expressjs.com/)
- [React Documentation](https://react.dev/)
- [MongoDB Documentation](https://docs.mongodb.com/)
- [Tailwind CSS](https://tailwindcss.com/)
- [JWT Introduction](https://jwt.io/)

---

## Common Commands

### Development

```bash
# Start all services
npm run dev

# Setup project
./dev-start.sh

# Cleanup node_modules
./scripts/cleanup.sh
```

### Database

```bash
# Run migrations
npm run migrate

# Seed database
npm run seed

# Backup database
./scripts/backup.sh
```

### Docker

```bash
# Start with Docker
./docker-start.sh

# View logs
docker-compose logs -f

# Access service
docker-compose exec backend bash
```

### Building

```bash
# Build all
./scripts/build.sh

# Production build
npm run build

# Preview build
npm run preview
```

---

## Troubleshooting

### Port Already in Use

```bash
# Find process using port
lsof -i :5000

# Kill process
kill -9 <PID>
```

### Database Connection Error

```bash
# Check MongoDB
mongosh "mongodb://localhost:27017"

# Check PostgreSQL
psql -U teknofixhub -d teknofixhub -h localhost

# Reset connection string in .env
```

### Module Not Found

```bash
# Clean install
rm -rf node_modules package-lock.json
npm install
```

### Port 3000 in Use (Frontend)

```bash
# Use different port
npm run dev -- --port 3002
```

### API CORS Error

Check CORS_ORIGIN in backend .env matches frontend URL.

### Docker Issues

```bash
# Remove all containers
docker-compose down -v

# Rebuild images
docker-compose build --no-cache

# Start fresh
docker-compose up -d
```

---

## 📊 Project Statistics

- **Total Directories**: 23
- **Total Files**: 35+
- **Frontend**: React 18.2, Vite 4.1
- **Backend**: Node.js, Express 4.18
- **Database**: MongoDB 6.0 / PostgreSQL 15
- **Documentation**: Comprehensive guides included
- **CI/CD**: GitHub Actions workflow
- **Containerization**: Docker & Docker Compose

---

## 📞 Support & Contribution

### Getting Help

1. Check [docs/README.md](./docs/README.md) for documentation
2. Read [api/API_DOCUMENTATION.md](./api/API_DOCUMENTATION.md) for API help
3. Open an issue on GitHub
4. Check troubleshooting section above

### Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/AmazingFeature`
3. Commit changes: `git commit -m 'Add AmazingFeature'`
4. Push to branch: `git push origin feature/AmazingFeature`
5. Open a Pull Request

### Code of Conduct

Please be respectful and constructive in all interactions.

---

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

---

## 🎯 Roadmap

- [ ] Mobile app (React Native)
- [ ] Advanced analytics
- [ ] Payment gateway integration
- [ ] Email notifications
- [ ] Real-time notifications (WebSocket)
- [ ] Multi-language support
- [ ] Dark mode
- [ ] Advanced search with Elasticsearch
- [ ] GraphQL API
- [ ] Microservices architecture

---

## ⭐ Credits

Built with ❤️ by TeknoFixHub Team

---

**Last Updated**: July 27, 2024
**Version**: 1.0.0

---

### Quick Links

- 🚀 [Getting Started](./docs/INSTALLATION.md)
- 📚 [API Documentation](./api/API_DOCUMENTATION.md)
- 🔧 [Development Guide](./docs/README.md)
- 🐳 [Docker Setup](./docker/README.md)
- 💻 [Frontend Guide](./frontend/README.md)
- 🔌 [Backend Guide](./backend/README.md)

---

**Happy Coding! 🎉**
