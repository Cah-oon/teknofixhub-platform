![TeknoFixHub Banner](.github/assets/banner.png)
# <img src=".github/assets/icon-color.png" width="40" align="left"> TeknoFixHub Platform 🚀

![CI/CD](https://github.com/Cah-oon/teknofixhub-platform/actions/workflows/ci-cd.yml/badge.svg)
![Node](https://img.shields.io/badge/Node.js-18%2B-green)
![Prisma](https://img.shields.io/badge/Prisma-5.x-blue)
![Docker](https://img.shields.io/badge/Docker-Ready-2496ED)
![License](https://img.shields.io/badge/License-MIT-yellow)

Platform servis elektronik, firmware download, marketplace, dan manajemen teknisi terpusat.

> **Repo:** `Cah-oon/teknofixhub-platform`

---

## ✨ Fitur Utama

- **Download Service** - NestJS service untuk manajemen firmware dengan HMAC signed URL
- **Prisma Schema** - Full DB schema (User, Role, Firmware, Device, Order, ServiceOrder, Shop, Technician, dsb)
- **Storage Proxy** - Proxy aman untuk stream file dari S3 / R2 / MinIO dengan validasi HMAC
- **Docker Dev Stack** - Postgres 15, Redis 7, MinIO, Storage Proxy, Download Service
- **CI/CD Ready** - GitHub Actions + K8s manifests

## 🏗️ Arsitektur

```
[Client] -> [Download Service :3000] -> [Storage Proxy :8080] -> [S3/R2/MinIO]
                  |
                  +-> [Postgres] + [Redis] 
                  +-> [Prisma ORM]
```

**Flow Download Aman:**
1. Client request `POST /downloads/token` -> dapat `downloadToken`
2. Service generate `presigned URL` dengan `HMAC(STORAGE_SIGN_SECRET)`
3. Client redirect ke Storage Proxy
4. Proxy validasi HMAC & expiry, lalu stream file

## ⚡ Quick Start - 1 Klik

### Opsi 1: GitHub Codespace (Tanpa Install)

1. Buka repo > **Code > Codespaces > Create Codespace**
2. Jalankan:
```bash
chmod +x start-all.sh
./start-all.sh
```
3. Buka tab **PORTS** > Forward `3000`

### Opsi 2: Local Docker

```bash
# Clone
git clone https://github.com/Cah-oon/teknofixhub-platform.git
cd teknofixhub-platform

# Setup env
cp .env.example .env

# Start All Infra
chmod +x start-all.sh
./start-all.sh

# Jalanin API (terminal baru)
cd download-service
npm run start:dev
```

### Opsi 3: Manual

```bash
docker-compose -f docker-compose.dev.yml up --build -d
npm install
npx prisma generate
npx prisma migrate dev --name init
npx ts-node prisma/seed.ts
cd download-service && npm run start:dev
```

## 🔧 Environment Variables

Copy `.env.example` ke `.env`:

| Key | Deskripsi | Default Dev |
|-----|-----------|-------------|
| `DATABASE_URL` | Postgres URL | `postgresql://tekno:tekno@localhost:5432/teknofix` |
| `REDIS_URL` | Redis URL | `redis://localhost:6379` |
| `STORAGE_SIGN_SECRET` | Secret HMAC | `dev-secret-change` |
| `STORAGE_BASE_URL` | Proxy URL | `http://localhost:8080` |
| `PRESIGN_EXPIRY` | Expiry link (detik) | `300` |

## 📁 Struktur Project

```
.
├── prisma/
│   ├── schema.prisma      # Full DB Schema (User, Firmware, Device, Order, dll)
│   └── seed.ts            # Seed role & admin
├── download-service/      # NestJS Microservice
│   ├── src/
│   └── Dockerfile
├── storage-proxy/         # Node.js HMAC Validator & Streamer
├── k8s/                   # K8s Deployment & Service
├── .github/workflows/     # CI/CD
├── docker-compose.dev.yml
├── start-all.sh           # One-click starter
└── stop-all.sh
```

## 🧪 Prisma Commands

```bash
npx prisma generate          # Generate client
npx prisma migrate dev       # Migrate dev
npx prisma studio            # Buka GUI DB di http://localhost:5555
npx ts-node prisma/seed.ts   # Seed data
```

## 🚀 Deployment

### Docker Build
```bash
docker build -t ghcr.io/cah-oon/teknofixhub-platform:latest ./download-service
```

### Kubernetes
```bash
kubectl apply -f k8s/
kubectl set image deployment/download-service download=ghcr.io/cah-oon/download-service:latest
```

### GitHub Secrets yang perlu diisi:
`DOCKER_REGISTRY`, `DOCKER_REPO`, `DATABASE_URL`, `REDIS_URL`, `STORAGE_SIGN_SECRET`

## 🤝 Kontribusi

```bash
git checkout -b feat/nama-fitur
git commit -m "feat: deskripsi"
git push -u origin feat/nama-fitur
# Buka PR ke main
```

## 📄 License

MIT © Cah-oon / TeknoFixHub

---
**Made with ❤️ for Teknisi Indonesia**
