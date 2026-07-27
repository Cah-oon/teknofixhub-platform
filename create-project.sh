#!/usr/bin/env bash
set -euo pipefail

# create-project.sh
# Usage:
#   ./create-project.sh [--init-git] [--remote <git-remote-url>] [--branch <branch-name>]
# Example:
#   ./create-project.sh --init-git --remote git@github.com:Cah-oon/teknofixhub-platform.git --branch feat/bootstrap/download-service

INIT_GIT=false
REMOTE_URL=""
BRANCH_NAME="feat/bootstrap/download-service"
MAIN_BRANCH="main"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --init-git) INIT_GIT=true; shift ;;
    --remote) REMOTE_URL="$2"; shift 2 ;;
    --branch) BRANCH_NAME="$2"; shift 2 ;;
    --main) MAIN_BRANCH="$2"; shift 2 ;;
    -h|--help) echo "Usage: $0 [--init-git] [--remote <git-remote-url>] [--branch <branch-name>]"; exit 0;;
    *) echo "Unknown arg: $1"; exit 1;;
  esac
done

ROOT_DIR="$(pwd)/teknofixhub-platform"
echo "Creating project at: $ROOT_DIR"
mkdir -p "$ROOT_DIR"

# Helper to write file with parent dirs
write_file() {
  local path="$ROOT_DIR/$1"
  mkdir -p "$(dirname "$path")"
  cat > "$path"
  echo "Wrote $1"
}

# README
cat > "$ROOT_DIR/README.md" <<'EOF'
# TeknoFixHub Platform - Download Service & DB Schema

This repository contains the scaffold for TeknoFixHub platform components, starting with the Download Service and Prisma schema.

Contents:
- prisma/schema.prisma - Full database schema
- prisma/seed.ts - Seed script for roles/permissions/admin
- download-service/ - NestJS download-service scaffold
- storage-proxy/ - Simple storage proxy to validate HMAC and stream files
- docker-compose.dev.yml - Local development stack (Postgres, Redis, MinIO, storage-proxy, download-service)
- .github/workflows/ci-cd.yml - CI/CD skeleton
- k8s/ - Kubernetes manifests (deployment & service)

Instructions: See README in the download-service directory for quickstart.
EOF
echo "Wrote README.md"

# Prisma schema
mkdir -p "$ROOT_DIR/prisma"
cat > "$ROOT_DIR/prisma/schema.prisma" <<'PRISMA'
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

enum StorageProvider {
  CLOUD_FLARE_R2
  AWS_S3
  BACKBLAZE_B2
  MINIO
  OTHER
}

enum FirmwareStatus {
  DRAFT
  PUBLISHED
  ARCHIVED
  DEPRECATED
}

enum UserStatus {
  ACTIVE
  SUSPENDED
  PENDING
  BANNED
}

enum VideoProvider {
  YOUTUBE
  TIKTOK
  FACEBOOK
  INSTAGRAM
  INTERNAL
}

enum OrderStatus {
  PENDING
  PROCESSING
  SHIPPED
  COMPLETED
  CANCELLED
  REFUNDED
}

enum ServiceStatus {
  CREATED
  RECEIVED
  IN_PROGRESS
  READY
  SHIPPED
  DELIVERED
  CLOSED
  CANCELLED
}

model User {
  id             String     @id @default(uuid())
  email          String     @unique
  username       String?    @unique
  fullName       String?
  passwordHash   String
  phone          String?
  avatarUrl      String?
  roleId         String
  twoFactorEnabled Boolean  @default(false)
  status         UserStatus @default(ACTIVE)
  meta           Json?      
  createdBy      String?
  updatedBy      String?
  createdAt      DateTime   @default(now())
  updatedAt      DateTime   @updatedAt
  deletedAt      DateTime?
  version        Int        @default(1)

  role           Role       @relation(fields: [roleId], references: [id])
  downloads      Download[] 
  auditLogs      AuditLog[] @relation("actorLogs")
  serviceOrders  ServiceOrder[]
  shops          Shop[]     @relation("shopOwners")
  technicians    Technician[]
  favorites      Favorite[]
  comments       Comment[]
  ratings        Rating[]
  orders         Order[]
  @@index([email])
}

model Role {
  id          String     @id @default(uuid())
  name        String     @unique
  description String?
  permissions Json?      
  createdAt   DateTime   @default(now())
  updatedAt   DateTime   @updatedAt
  deletedAt   DateTime?
  version     Int        @default(1)
  users       User[]
  rolePermissions RolePermission[]
}

model Permission {
  id          String   @id @default(uuid())
  key         String   @unique
  description String?
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
  deletedAt   DateTime?
  version     Int      @default(1)
  rolePermissions RolePermission[]
}

model RolePermission {
  id           String   @id @default(uuid())
  roleId       String
  permissionId String
  createdAt    DateTime @default(now())
  role         Role     @relation(fields: [roleId], references: [id])
  permission   Permission @relation(fields: [permissionId], references: [id])
  @@unique([roleId, permissionId])
}

model Manufacturer {
  id        String    @id @default(uuid())
  name      String
  slug      String     @unique
  logoUrl   String?
  website   String?
  createdAt DateTime   @default(now())
  updatedAt DateTime   @updatedAt
  deletedAt DateTime?
  version   Int        @default(1)
  models    DeviceModel[]
}

model DeviceModel {
  id             String    @id @default(uuid())
  manufacturerId String
  name           String
  slug           String
  series         String?
  createdAt      DateTime  @default(now())
  updatedAt      DateTime  @updatedAt
  deletedAt      DateTime?
  version        Int       @default(1)
  manufacturer   Manufacturer @relation(fields: [manufacturerId], references: [id])
  firmwares      Firmware[]
  @@index([manufacturerId])
  @@unique([manufacturerId, slug])
}

model Chip {
  id        String   @id @default(uuid())
  name      String
  vendor    String?
  partNumber String?
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  deletedAt DateTime?
  version   Int      @default(1)
  firmwares Firmware[] @relation("FirmwareChip")
}

model Category {
  id        String    @id @default(uuid())
  name      String
  slug      String    @unique
  parentId  String?
  createdAt DateTime  @default(now())
  updatedAt DateTime  @updatedAt
  deletedAt DateTime?
  version   Int       @default(1)
  children  Category[] @relation("CategoryChildren", fields: [parentId], references: [id])
  parent    Category?  @relation("CategoryChildren")
  firmwares Firmware[]
}

model Tag {
  id        String   @id @default(uuid())
  name      String   @unique
  slug      String   @unique
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  deletedAt DateTime?
  version   Int      @default(1)
  firmwareTags FirmwareTag[]
  articleTags  ArticleTag[]
  productTags  ProductTag[]
}

model Firmware {
  id               String    @id @default(uuid())
  uuidPublic       String    @unique @default(uuid())
  slug             String    @unique
  title            String
  manufacturerId   String?
  modelId          String?
  categoryId       String?
  chipsetId        String?
  ic               String?
  resolution       String?
  fileSizeApprox   BigInt?
  screenshotUrl    String?
  manualUrl        String?
  zipPassword      String?
  md5              String?
  sha256           String?
  downloadsCount   Int       @default(0)
  viewsCount       Int       @default(0)
  status           FirmwareStatus @default(PUBLISHED)
  versionCurrent   String?
  tagsMeta         Json?
  createdAt        DateTime  @default(now())
  updatedAt        DateTime  @updatedAt
  deletedAt        DateTime?
  version          Int       @default(1)

  manufacturer     Manufacturer? @relation(fields: [manufacturerId], references: [id])
  deviceModel      DeviceModel?  @relation(fields: [modelId], references: [id])
  chip             Chip?         @relation("FirmwareChip", fields: [chipsetId], references: [id])
  versions         FirmwareVersion[]
  firmwareTags     FirmwareTag[]
  relatedVideos    Video[]       @relation("FirmwareVideos")
  @@index([slug])
  @@index([manufacturerId])
  @@index([modelId])
}

model FirmwareTag {
  id         String   @id @default(uuid())
  firmwareId String
  tagId      String
  firmware   Firmware @relation(fields: [firmwareId], references: [id])
  tag        Tag      @relation(fields: [tagId], references: [id])
  @@unique([firmwareId, tagId])
}

model FirmwareVersion {
  id           String    @id @default(uuid())
  firmwareId   String
  versionLabel String
  changelog    String?
  uploadDate   DateTime  @default(now())
  fileCount    Int       @default(0)
  createdAt    DateTime  @default(now())
  updatedAt    DateTime  @updatedAt
  deletedAt    DateTime?
  version      Int       @default(1)
  firmware     Firmware  @relation(fields: [firmwareId], references: [id])
  files        FirmwareFile[]
  @@index([firmwareId])
}

model FirmwareFile {
  id                 String   @id @default(uuid())
  firmwareVersionId  String
  storageLocationId  String
  mirrorServerId     String?
  filename           String
  filesize           BigInt
  md5                String?
  sha256             String?
  checksumVerified   Boolean  @default(false)
  pathKey            String   
  downloadCount      Int      @default(0)
  downloadsLimit     Int?     
  createdAt          DateTime @default(now())
  updatedAt          DateTime @updatedAt
  deletedAt          DateTime?
  version            Int      @default(1)
  firmwareVersion    FirmwareVersion @relation(fields: [firmwareVersionId], references: [id])
  storageLocation    StorageLocation  @relation(fields: [storageLocationId], references: [id])
  mirrorServer       MirrorServer?    @relation(fields: [mirrorServerId], references: [id])
  downloadTokens     DownloadToken[]
  downloads          Download[]
  checksumLogs       ChecksumLog[]
  brokenLinkLogs     BrokenLinkLog[]
  @@index([firmwareVersionId])
  @@index([storageLocationId])
}

model StorageLocation {
  id        String          @id @default(uuid())
  provider  StorageProvider @default(CLOUD_FLARE_R2)
  bucket    String
  region    String?
  baseUrl   String
  isPrimary Boolean         @default(false)
  config    Json?
  createdAt DateTime        @default(now())
  updatedAt DateTime        @updatedAt
  deletedAt DateTime?
  version   Int             @default(1)
  files     FirmwareFile[]
}

model MirrorServer {
  id        String   @id @default(uuid())
  name      String
  baseUrl   String
  priority  Int      @default(10)
  isActive  Boolean  @default(true)
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  deletedAt DateTime?
  version   Int      @default(1)
  files     FirmwareFile[]
}

model DownloadToken {
  id                String   @id @default(uuid())
  firmwareFileId    String
  token             String   @unique
  signedUrl         String?  
  expiresAt         DateTime
  maxUses           Int      @default(1)
  usedCount         Int      @default(0)
  ipRestrictions    String?  
  userAgentRestrict String?  
  createdBy         String?  
  createdAt         DateTime @default(now())
  revoked           Boolean  @default(false)
  firmwareFile      FirmwareFile @relation(fields: [firmwareFileId], references: [id])
  downloads         Download[]
  @@index([token])
  @@index([expiresAt])
}

model Download {
  id             String   @id @default(uuid())
  downloadTokenId String?
  firmwareFileId  String
  userId         String?
  ip             String?
  userAgent      String?
  referrer       String?
  startedAt      DateTime @default(now())
  completedAt    DateTime?
  bytesTransferred BigInt?
  status         String   
  createdAt      DateTime @default(now())
  firmwareFile   FirmwareFile @relation(fields: [firmwareFileId], references: [id])
  downloadToken  DownloadToken? @relation(fields: [downloadTokenId], references: [id])
  user           User? @relation(fields: [userId], references: [id])
  downloadLogs   DownloadLog[]
  @@index([firmwareFileId])
  @@index([downloadTokenId])
  @@index([userId])
}

model DownloadLog {
  id         String   @id @default(uuid())
  downloadId String
  eventType  String
  message    String?
  meta       Json?
  createdAt  DateTime @default(now())
  download   Download @relation(fields: [downloadId], references: [id])
  @@index([downloadId])
}

model BrokenLinkLog {
  id             String   @id @default(uuid())
  firmwareFileId String
  reportedBy     String?  
  reportedAt     DateTime @default(now())
  status         String?  
  notes          String?
  firmwareFile   FirmwareFile @relation(fields: [firmwareFileId], references: [id])
  @@index([firmwareFileId])
}

model ChecksumLog {
  id             String   @id @default(uuid())
  firmwareFileId String
  expectedMd5    String?
  expectedSha256 String?
  actualMd5      String?
  actualSha256   String?
  result         String   
  checkedAt      DateTime @default(now())
  details        Json?
  firmwareFile   FirmwareFile @relation(fields: [firmwareFileId], references: [id])
  @@index([firmwareFileId])
  @@index([checkedAt])
}

model BackupLog {
  id         String   @id @default(uuid())
  backupType String   
  target     String   
  status     String
  startedAt  DateTime @default(now())
  finishedAt DateTime?
  details    Json?
  createdAt  DateTime @default(now())
}

model AuditLog {
  id         String   @id @default(uuid())
  entityType String
  entityId   String
  action     String
  actorId    String?  
  actor      User?    @relation("actorLogs", fields: [actorId], references: [id])
  details    Json?
  createdAt  DateTime @default(now())
  @@index([entityType, entityId])
}

model Setting {
  id        String   @id @default(uuid())
  key       String   @unique
  value     Json
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model ActivityLog {
  id        String   @id @default(uuid())
  userId    String?
  action    String
  meta      Json?
  createdAt DateTime @default(now())
  user      User? @relation(fields: [userId], references: [id])
  @@index([userId])
}

model Article {
  id         String   @id @default(uuid())
  slug       String   @unique
  title      String
  excerpt    String?
  content    String   
  seoMeta    Json?
  schemaOrg  Json?
  authorId   String?
  views      Int      @default(0)
  status     String   
  createdAt  DateTime @default(now())
  updatedAt  DateTime @updatedAt
  deletedAt  DateTime?
  version    Int      @default(1)
  author     User?    @relation(fields: [authorId], references: [id])
  comments   Comment[]
  articleTags ArticleTag[]
  ratings   Rating[]
  @@index([slug])
  @@index([authorId])
}

model ArticleTag {
  id        String   @id @default(uuid())
  articleId String
  tagId     String
  article   Article  @relation(fields: [articleId], references: [id])
  tag       Tag      @relation(fields: [tagId], references: [id])
  @@unique([articleId, tagId])
}

model Comment {
  id         String   @id @default(uuid())
  articleId  String?
  videoId    String?
  firmwareId String?
  userId     String?
  parentId   String?
  content    String
  createdAt  DateTime @default(now())
  updatedAt  DateTime @updatedAt
  deletedAt  DateTime?
  user       User? @relation(fields: [userId], references: [id])
  replies    Comment[] @relation("CommentReplies", fields: [parentId], references: [id])
  parent     Comment?  @relation("CommentReplies")
  @@index([articleId])
  @@index([userId])
}

model Rating {
  id         String   @id @default(uuid())
  userId     String?
  articleId  String?
  firmwareId String?
  productId  String?
  value      Int
  review     String?
  createdAt  DateTime @default(now())
  user       User? @relation(fields: [userId], references: [id])
  @@index([userId])
}

model Favorite {
  id        String   @id @default(uuid())
  userId    String
  type      String   
  targetId  String
  createdAt DateTime @default(now())
  user      User     @relation(fields: [userId], references: [id])
  @@unique([userId, type, targetId])
}

model Video {
  id            String        @id @default(uuid())
  provider      VideoProvider @default(YOUTUBE)
  externalId    String
  title         String
  description   String?
  codeError     String?
  causes        String?
  solution      String?
  estimatedCost String?
  relatedFirmware Json?
  relatedArticles  Json?
  comments      Comment[]
  createdAt     DateTime      @default(now())
  updatedAt     DateTime      @updatedAt
  deletedAt     DateTime?
  version       Int           @default(1)
  @@index([provider, externalId])
}

model ProductCategory {
  id        String   @id @default(uuid())
  name      String
  slug      String   @unique
  parentId  String?
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  deletedAt DateTime?
  version   Int      @default(1)
  products  Product[]
}

model Product {
  id             String   @id @default(uuid())
  sku            String   @unique
  name           String
  description    String?
  priceCents     Int
  costCents      Int?
  currency       String   @default("IDR")
  discountCents  Int?
  stockQuantity  Int      @default(0)
  supplierId     String?
  productCategoryId String?
  images         Json?
  affiliateMeta   Json?
  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt
  deletedAt      DateTime?
  version        Int      @default(1)
  supplier       Supplier? @relation(fields: [supplierId], references: [id])
  category       ProductCategory? @relation(fields: [productCategoryId], references: [id])
  stockMovements StockMovement[]
  orders         OrderItem[]
  productTags    ProductTag[]
  @@index([sku])
}

model ProductTag {
  id        String   @id @default(uuid())
  productId String
  tagId     String
  product   Product  @relation(fields: [productId], references: [id])
  tag       Tag      @relation(fields: [tagId], references: [id])
  @@unique([productId, tagId])
}

model Stock {
  id         String   @id @default(uuid())
  productId  String
  quantity   Int
  location   String?  
  reserved   Int      @default(0)
  createdAt  DateTime @default(now())
  updatedAt  DateTime @updatedAt
  product    Product  @relation(fields: [productId], references: [id])
  stockMovements StockMovement[]
  @@index([productId])
}

model StockMovement {
  id          String   @id @default(uuid())
  productId   String
  change      Int
  type        String   
  reference   String?
  note        String?
  createdAt   DateTime @default(now())
  product     Product  @relation(fields: [productId], references: [id])
  @@index([productId])
}

model Supplier {
  id         String   @id @default(uuid())
  name       String
  contact    Json?
  createdAt  DateTime @default(now())
  updatedAt  DateTime @updatedAt
  deletedAt  DateTime?
  version    Int      @default(1)
  products   Product[]
}

model Technician {
  id         String   @id @default(uuid())
  userId     String?
  name       String
  photoUrl   String?
  experienceYears Int?
  certificates Json?
  areaServed  String?
  rating      Float?
  contact     Json?
  portfolio   Json?
  workingHours Json?
  verified    Boolean @default(false)
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
  deletedAt   DateTime?
  version     Int      @default(1)
  user        User?    @relation(fields: [userId], references: [id])
  @@index([userId])
}

model Shop {
  id           String   @id @default(uuid())
  ownerId      String?
  name         String
  logoUrl      String?
  photos       Json?
  rating       Float?
  reviewsCount Int?
  googleMaps   Json?
  whatsapp     String?
  telegram     String?
  marketplaces Json?
  codAvailable Boolean   @default(false)
  couriers     Json?
  openingHours Json?
  verified     Boolean   @default(false)
  createdAt    DateTime  @default(now())
  updatedAt    DateTime  @updatedAt
  deletedAt    DateTime?
  version      Int       @default(1)
  owner        User?     @relation("shopOwners", fields: [ownerId], references: [id])
  products     Product[]
}

model AffiliateLink {
  id          String   @id @default(uuid())
  platform    String   
  productId   String?
  externalUrl String
  commission  Float?
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
  meta        Json?
}

model "Order" {
  id            String   @id @default(uuid())
  orderNumber   String   @unique
  userId        String?
  status        OrderStatus @default(PENDING)
  totalCents    Int
  currency      String @default("IDR")
  paymentMeta   Json?
  shippingMeta  Json?
  createdAt     DateTime @default(now())
  updatedAt     DateTime @updatedAt
  deletedAt     DateTime?
  version       Int      @default(1)
  user          User?    @relation(fields: [userId], references: [id])
  items         OrderItem[]
}

model OrderItem {
  id        String   @id @default(uuid())
  orderId   String
  productId String
  priceCents Int
  qty       Int
  totalCents Int
  order     "Order"  @relation(fields: [orderId], references: [id])
  product   Product  @relation(fields: [productId], references: [id])
  @@index([orderId])
  @@index([productId])
}

model ServiceOrder {
  id             String      @id @default(uuid())
  serviceNumber  String      @unique
  userId         String?
  technicianId   String?
  shopId         String?
  deviceInfo     Json?
  problemSummary String?
  estimatedCost  Int?
  status         ServiceStatus @default(CREATED)
  createdAt      DateTime    @default(now())
  updatedAt      DateTime    @updatedAt
  tracking       ServiceTracking[]
  user           User?       @relation(fields: [userId], references: [id])
  technician     Technician? @relation(fields: [technicianId], references: [id])
  shop           Shop?       @relation(fields: [shopId], references: [id])
  @@index([serviceNumber])
}

model ServiceTracking {
  id            String   @id @default(uuid())
  serviceOrderId String
  status        ServiceStatus
  note          String?
  location      String?
  createdAt     DateTime @default(now())
  serviceOrder  ServiceOrder @relation(fields: [serviceOrderId], references: [id])
  @@index([serviceOrderId])
}

model Contact {
  id        String   @id @default(uuid())
  name      String
  email     String?
  phone     String?
  message   String
  channel   String?  
  metadata  Json?
  createdAt DateTime @default(now())
}

model FAQ {
  id        String   @id @default(uuid())
  question  String
  answer    String
  category  String?
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  deletedAt DateTime?
}

model Banner {
  id        String   @id @default(uuid())
  title     String
  imageUrl  String
  linkUrl   String?
  position  String?  
  isActive  Boolean  @default(true)
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model Notification {
  id        String   @id @default(uuid())
  userId    String?
  title     String
  body      String
  meta      Json?
  read      Boolean  @default(false)
  createdAt DateTime @default(now())
  user      User?    @relation(fields: [userId], references: [id])
}

model Newsletter {
  id        String   @id @default(uuid())
  email     String   @unique
  subscribed Boolean @default(true)
  meta      Json?
  createdAt DateTime @default(now())
}

model Visitor {
  id        String   @id @default(uuid())
  sessionId String?
  ip        String?
  userAgent String?
  path      String?
  referrer  String?
  createdAt DateTime @default(now())
  meta      Json?
  @@index([sessionId])
  @@index([ip])
}

model Analytics {
  id          String   @id @default(uuid())
  key         String
  value       Json
  createdAt   DateTime @default(now())
  @@index([key])
}

model SocialLink {
  id        String   @id @default(uuid())
  platform  String
  url       String
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model SearchIndex {
  id         String   @id @default(uuid())
  entityType String
  entityId   String
  content    String
  createdAt  DateTime @default(now())
  @@index([entityType])
  @@index([entityId])
}
PRISMA
echo "Wrote prisma/schema.prisma"

# prisma seed
cat > "$ROOT_DIR/prisma/seed.ts" <<'SEED'
import { PrismaClient } from '@prisma/client';
import * as argon2 from 'argon2';

const prisma = new PrismaClient();

async function main() {
  console.log('Seeding roles & permissions...');
  const adminRole = await prisma.role.upsert({
    where: { name: 'admin' },
    update: {},
    create: { name: 'admin', description: 'Administrator dengan semua hak' },
  });

  const userRole = await prisma.role.upsert({
    where: { name: 'user' },
    update: {},
    create: { name: 'user', description: 'Pengguna terdaftar' },
  });

  const perms = [
    { key: 'firmware.create', description: 'Create firmware' },
    { key: 'firmware.read', description: 'Read firmware' },
    { key: 'download.manage', description: 'Manage downloads' },
    { key: 'admin.*', description: 'All admin permissions' },
  ];

  for (const p of perms) {
    await prisma.permission.upsert({
      where: { key: p.key },
      update: {},
      create: p,
    });
  }

  for (const p of perms) {
    const perm = await prisma.permission.findUnique({ where: { key: p.key }});
    if (perm) {
      try {
        await prisma.rolePermission.create({
          data: { roleId: adminRole.id, permissionId: perm.id }
        });
      } catch {}
    }
  }

  // create default admin user
  const adminEmail = process.env.SEED_ADMIN_EMAIL || 'admin@tekno-fix.local';
  const adminPass = process.env.SEED_ADMIN_PASSWORD || 'ChangeMe123!';
  const hash = await argon2.hash(adminPass);

  const adminUser = await prisma.user.upsert({
    where: { email: adminEmail },
    update: {},
    create: {
      email: adminEmail,
      username: 'admin',
      fullName: 'TeknoFix Admin',
      passwordHash: hash,
      roleId: adminRole.id,
    }
  });

  console.log('Seed completed. Admin user:', adminEmail);
}

main()
  .catch(e => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
SEED
echo "Wrote prisma/seed.ts"

# Create download-service scaffold
mkdir -p "$ROOT_DIR/download-service/src/prisma"
mkdir -p "$ROOT_DIR/download-service/src/storage"
mkdir -p "$ROOT_DIR/download-service/src/download"
cat > "$ROOT_DIR/download-service/package.json" <<'PKG'
{
  "name": "download-service",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "start:dev": "ts-node-dev --respawn --transpile-only src/main.ts",
    "start": "node dist/main.js",
    "build": "tsc -p tsconfig.build.json",
    "test": "jest"
  },
  "dependencies": {
    "@nestjs/common": "^9.0.0",
    "@nestjs/core": "^9.0.0",
    "@nestjs/platform-express": "^9.0.0",
    "@prisma/client": "^4.0.0",
    "class-transformer": "^0.5.1",
    "class-validator": "^0.14.0",
    "dotenv": "^16.0.0",
    "express-rate-limit": "^6.7.0",
    "ioredis": "^5.0.0",
    "uuid": "^9.0.0"
  },
  "devDependencies": {
    "prisma": "^4.0.0",
    "ts-node": "^10.0.0",
    "ts-node-dev": "^2.0.0",
    "typescript": "^4.8.0",
    "@types/express": "^4.17.13",
    "jest": "^28.0.0",
    "@types/jest": "^28.0.0",
    "supertest": "^6.2.4"
  }
}
PKG

cat > "$ROOT_DIR/download-service/tsconfig.json" <<'TSC'
{
  "compilerOptions": {
    "module": "CommonJS",
    "declaration": true,
    "removeComments": true,
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true,
    "target": "ES2020",
    "sourceMap": true,
    "outDir": "dist",
    "incremental": true,
    "skipLibCheck": true,
    "strict": true,
    "esModuleInterop": true
  },
  "exclude": ["node_modules", "dist"]
}
TSC

cat > "$ROOT_DIR/download-service/src/main.ts" <<'MAIN'
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as dotenv from 'dotenv';
dotenv.config();

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.setGlobalPrefix('api');
  await app.listen(process.env.PORT ? parseInt(process.env.PORT) : 3000);
  console.log(`Download service started on port ${process.env.PORT || 3000}`);
}
bootstrap();
MAIN

cat > "$ROOT_DIR/download-service/src/app.module.ts" <<'AM'
import { Module } from '@nestjs/common';
import { PrismaModule } from './prisma/prisma.module';
import { DownloadModule } from './download/download.module';
import { StorageModule } from './storage/storage.module';

@Module({
  imports: [PrismaModule, StorageModule, DownloadModule],
})
export class AppModule {}
AM

cat > "$ROOT_DIR/download-service/src/prisma/prisma.module.ts" <<'PM'
import { Global, Module } from '@nestjs/common';
import { PrismaService } from './prisma.service';

@Global()
@Module({
  providers: [PrismaService],
  exports: [PrismaService],
})
export class PrismaModule {}
PM

cat > "$ROOT_DIR/download-service/src/prisma/prisma.service.ts" <<'PS'
import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  async onModuleInit() {
    await this.$connect();
  }
  async onModuleDestroy() {
    await this.$disconnect();
  }
}
PS

cat > "$ROOT_DIR/download-service/src/storage/storage.module.ts" <<'SM'
import { Module } from '@nestjs/common';
import { StorageService } from './storage.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [StorageService],
  exports: [StorageService],
})
export class StorageModule {}
SM

cat > "$ROOT_DIR/download-service/src/storage/storage.service.ts" <<'SS'
import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import * as crypto from 'crypto';
import { getSignedUrl as getAwsSignedUrl } from '@aws-sdk/s3-request-presigner';
import { S3Client, GetObjectCommand } from '@aws-sdk/client-s3';

@Injectable()
export class StorageService {
  private readonly logger = new Logger(StorageService.name);
  private s3Client?: S3Client;

  constructor(private prisma: PrismaService) {
    if (process.env.AWS_S3_ACCESS_KEY && process.env.AWS_S3_SECRET) {
      this.s3Client = new S3Client({
        region: process.env.AWS_REGION || 'us-east-1',
        credentials: {
          accessKeyId: process.env.AWS_S3_ACCESS_KEY!,
          secretAccessKey: process.env.AWS_S3_SECRET!,
        }
      });
    }
  }

  async getPresignedUrl(storageLocationId: string, pathKey: string, expiresSeconds = 300): Promise<string> {
    const storage = await this.prisma.storageLocation.findUnique({ where: { id: storageLocationId }});
    if (!storage) throw new Error('Storage location not found');

    if (this.s3Client && storage.provider === 'AWS_S3') {
      const [bucket, ...rest] = storage.bucket.split('/');
      const key = rest.join('/') || pathKey;
      const cmd = new GetObjectCommand({ Bucket: bucket, Key: key });
      const url = await getAwsSignedUrl(this.s3Client, cmd, { expiresIn: expiresSeconds });
      return url;
    }

    const base = storage.baseUrl.replace(/\/$/, '');
    const secret = process.env.STORAGE_SIGN_SECRET || 'change-me-secret';
    const expires = Math.floor(Date.now() / 1000) + expiresSeconds;
    const payload = `${pathKey}.${expires}`;
    const sig = crypto.createHmac('sha256', secret).update(payload).digest('hex');
    return `${base}/_internal/serve/${encodeURIComponent(pathKey)}?exp=${expires}&sig=${sig}`;
  }
}
SS

cat > "$ROOT_DIR/download-service/src/download/download.module.ts" <<'DM'
import { Module } from '@nestjs/common';
import { DownloadService } from './download.service';
import { DownloadController } from './download.controller';
import { PrismaModule } from '../prisma/prisma.module';
import { StorageModule } from '../storage/storage.module';

@Module({
  imports: [PrismaModule, StorageModule],
  providers: [DownloadService],
  controllers: [DownloadController],
})
export class DownloadModule {}
DM

cat > "$ROOT_DIR/download-service/src/download/download.controller.ts" <<'DC'
import { Controller, Post, Param, Get, Req, Res, NotFoundException, ForbiddenException, BadRequestException } from '@nestjs/common';
import { DownloadService } from './download.service';
import { Request, Response } from 'express';

@Controller()
export class DownloadController {
  constructor(private readonly downloadService: DownloadService) {}

  @Post('api/firmware-files/:fileId/request-download')
  async requestDownload(@Param('fileId') fileId: string, @Req() req: Request) {
    const ip = req.ip || (req.headers['x-forwarded-for'] as string) || '';
    const userAgent = req.headers['user-agent'] || '';
    const createdBy = (req as any).user?.id;
    try {
      const token = await this.downloadService.createDownloadToken(fileId, { ip, userAgent, createdBy });
      return { token: token.token, downloadUrl: `${process.env.PUBLIC_URL || 'http://localhost:3000'}/download/${token.token}`, expiresAt: token.expiresAt };
    } catch (err) {
      throw new BadRequestException(err.message || 'Unable to create token');
    }
  }

  @Get('download/:token')
  async handleDownloadRedirect(@Param('token') token: string, @Req() req: Request, @Res() res: Response) {
    const ip = req.ip || (req.headers['x-forwarded-for'] as string) || '';
    const userAgent = req.headers['user-agent'] || '';
    try {
      const presigned = await this.downloadService.consumeTokenAndGetPresigned(token, { ip, userAgent, referer: req.headers.referer as string | undefined });
      return res.redirect(302, presigned);
    } catch (err) {
      if (err.message === 'TOKEN_NOT_FOUND') throw new NotFoundException('Token not found or expired');
      if (['TOKEN_REVOKED','TOKEN_MAXED','TOKEN_EXPIRED'].includes(err.message)) throw new ForbiddenException(err.message);
      throw err;
    }
  }
}
DC

cat > "$ROOT_DIR/download-service/src/download/download.service.ts" <<'DS'
import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { StorageService } from '../storage/storage.service';
import * as crypto from 'crypto';

@Injectable()
export class DownloadService {
  private readonly logger = new Logger(DownloadService.name);

  constructor(private prisma: PrismaService, private storage: StorageService) {}

  async createDownloadToken(firmwareFileId: string, opts: { ip?: string; userAgent?: string; createdBy?: string }) {
    const file = await this.prisma.firmwareFile.findUnique({ where: { id: firmwareFileId }});
    if (!file) throw new Error('FILE_NOT_FOUND');

    const token = crypto.randomBytes(24).toString('hex');
    const ttl = parseInt(process.env.DOWNLOAD_TOKEN_TTL_SECONDS || '900');
    const expiresAt = new Date(Date.now() + ttl * 1000);
    const rec = await this.prisma.downloadToken.create({
      data: {
        firmwareFileId,
        token,
        expiresAt,
        maxUses: 1,
        createdBy: opts.createdBy,
      }
    });
    await this.prisma.auditLog.create({
      data: {
        entityType: 'download_token',
        entityId: rec.id,
        action: 'create',
        actorId: opts.createdBy,
        details: { ip: opts.ip, userAgent: opts.userAgent }
      }
    });
    return rec;
  }

  async consumeTokenAndGetPresigned(tokenStr: string, opts: { ip?: string; userAgent?: string; referer?: string }) {
    return await this.prisma.$transaction(async (tx) => {
      const tokenRow = await tx.downloadToken.findUnique({ where: { token: tokenStr }, include: { firmwareFile: true }});
      if (!tokenRow) { throw new Error('TOKEN_NOT_FOUND'); }
      if (tokenRow.revoked) { throw new Error('TOKEN_REVOKED'); }
      if (tokenRow.expiresAt < new Date()) { throw new Error('TOKEN_EXPIRED'); }
      if (tokenRow.maxUses && tokenRow.usedCount >= tokenRow.maxUses) { throw new Error('TOKEN_MAXED'); }

      await tx.downloadToken.update({ where: { id: tokenRow.id }, data: { usedCount: { increment: 1 } }});

      const dl = await tx.download.create({
        data: {
          downloadTokenId: tokenRow.id,
          firmwareFileId: tokenRow.firmwareFileId,
          ip: opts.ip,
          userAgent: opts.userAgent,
          status: 'STARTED'
        }
      });

      const presigned = await this.storage.getPresignedUrl(tokenRow.firmwareFile.storageLocationId, tokenRow.firmwareFile.pathKey, parseInt(process.env.PRESIGN_EXPIRY || '300'));

      await tx.downloadLog.create({ data: { downloadId: dl.id, eventType: 'TOKEN_CONSUMED', message: 'Token consumed, redirecting', meta: { referer: opts.referer } }});

      return presigned;
    });
  }

  async revokeToken(tokenIdOrToken: string) {
    return this.prisma.downloadToken.updateMany({
      where: { OR: [{ id: tokenIdOrToken }, { token: tokenIdOrToken }] },
      data: { revoked: true },
    });
  }
}
DS

cat > "$ROOT_DIR/download-service/Dockerfile" <<'DOCK'
FROM node:18-alpine AS builder
WORKDIR /app
COPY package.json pnpm-lock.yaml* ./
RUN npm install --production
COPY . .
RUN npm run build

FROM node:18-alpine
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/dist ./dist
COPY package.json package.json
RUN npm install --production
CMD ["node", "dist/main.js"]
DOCK

echo "Wrote download-service scaffold"

# Storage proxy
mkdir -p "$ROOT_DIR/storage-proxy"
cat > "$ROOT_DIR/storage-proxy/index.ts" <<'PROXY'
import express from 'express';
import fetch from 'node-fetch';
import crypto from 'crypto';
import { S3Client, GetObjectCommand } from '@aws-sdk/client-s3';

const app = express();
const PORT = process.env.PORT || 8080;
const SECRET = process.env.STORAGE_SIGN_SECRET || 'change-me-secret';
const S3_CLIENT = (process.env.AWS_S3_ACCESS_KEY && process.env.AWS_S3_SECRET) ? new S3Client({
  region: process.env.AWS_REGION || 'us-east-1',
  credentials: {
    accessKeyId: process.env.AWS_S3_ACCESS_KEY!,
    secretAccessKey: process.env.AWS_S3_SECRET!,
  }
}) : null;

function verifySig(pathKey: string, exp: number, sig: string) {
  const now = Math.floor(Date.now() / 1000);
  if (exp < now) return false;
  const expected = crypto.createHmac('sha256', SECRET).update(`${pathKey}.${exp}`).digest('hex');
  return crypto.timingSafeEqual(Buffer.from(expected,'hex'), Buffer.from(sig,'hex'));
}

app.get('/_internal/serve/:pathKey', async (req, res) => {
  const { pathKey } = req.params;
  const exp = parseInt(req.query.exp as string);
  const sig = req.query.sig as string;
  if (!verifySig(pathKey, exp, sig)) return res.status(403).send('Invalid or expired signature');

  if (S3_CLIENT && process.env.STORAGE_BUCKET) {
    const [bucket, ...rest] = process.env.STORAGE_BUCKET.split('/');
    const key = pathKey;
    const cmd = new GetObjectCommand({ Bucket: bucket, Key: key });
    const obj = await S3_CLIENT.send(cmd);
    res.setHeader('content-type', (obj.ContentType || 'application/octet-stream'));
    res.setHeader('content-length', (obj.ContentLength as any) || '');
    (obj.Body as any).pipe(res);
    return;
  }

  const storageBase = process.env.STORAGE_BASE_URL || 'http://minio:9000';
  const fetchUrl = `${storageBase}/${encodeURIComponent(pathKey)}`;
  const upstreamRes = await fetch(fetchUrl);
  if (!upstreamRes.ok) {
    return res.status(502).send('Upstream fetch error');
  }
  res.status(upstreamRes.status);
  upstreamRes.body.pipe(res);
});

app.listen(PORT, () => {
  console.log(`Storage proxy listening ${PORT}`);
});
PROXY
echo "Wrote storage-proxy"

# docker-compose.dev.yml
cat > "$ROOT_DIR/docker-compose.dev.yml" <<'DCOMPOSE'
version: '3.8'
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_USER: tekno
      POSTGRES_PASSWORD: tekno
      POSTGRES_DB: teknofix
    volumes:
      - db-data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7
    ports:
      - "6379:6379"

  minio:
    image: minio/minio:RELEASE.2023-08-02T03-11-05Z
    environment:
      MINIO_ROOT_USER: minio
      MINIO_ROOT_PASSWORD: minio123
    command: server /data
    ports:
      - "9000:9000"

  storage-proxy:
    build:
      context: ./storage-proxy
    environment:
      STORAGE_SIGN_SECRET: "dev-secret-change"
      STORAGE_BASE_URL: "http://minio:9000"
      STORAGE_BUCKET: "minio-bucket"
    depends_on:
      - minio
    ports:
      - "8080:8080"

  download-service:
    build:
      context: ./download-service
    environment:
      DATABASE_URL: "postgresql://tekno:tekno@postgres:5432/teknofix"
      REDIS_URL: "redis://redis:6379"
      STORAGE_SIGN_SECRET: "dev-secret-change"
      PRESIGN_EXPIRY: "300"
      DOWNLOAD_TOKEN_TTL_SECONDS: "900"
      PUBLIC_URL: "http://localhost:3000"
      STORAGE_BASE_URL: "http://storage-proxy:8080"
      AWS_S3_ACCESS_KEY: ""
      AWS_S3_SECRET: ""
    depends_on:
      - postgres
      - redis
      - storage-proxy
    ports:
      - "3000:3000"

volumes:
  db-data:
DCOMPOSE
echo "Wrote docker-compose.dev.yml"

# GitHub Actions
mkdir -p "$ROOT_DIR/.github/workflows"
cat > "$ROOT_DIR/.github/workflows/ci-cd.yml" <<'GHA'
name: CI/CD
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_USER: tekno
          POSTGRES_PASSWORD: tekno
          POSTGRES_DB: teknofix
        options: --health-cmd pg_isready --health-interval 10s --health-timeout 5s --health-retries 5
      redis:
        image: redis:7
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 18
      - name: Install deps
        run: npm ci
      - name: Generate Prisma client
        env:
          DATABASE_URL: postgresql://tekno:tekno@localhost:5432/teknofix
        run: npx prisma generate
      - name: Run tests
        run: npm test

  build-and-push:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build and push Docker
        uses: docker/build-push-action@v4
        with:
          context: ./download-service
          push: true
          tags: ${{ secrets.DOCKER_REGISTRY }}/${{ secrets.DOCKER_REPO }}:latest
GHA
echo "Wrote .github/workflows/ci-cd.yml"

# k8s manifests
mkdir -p "$ROOT_DIR/k8s"
cat > "$ROOT_DIR/k8s/download-deployment.yaml" <<'K8S'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: download-service
spec:
  replicas: 2
  selector:
    matchLabels:
      app: download-service
  template:
    metadata:
      labels:
        app: download-service
    spec:
      containers:
        - name: download
          image: ghcr.io/your-org/download-service:latest
          env:
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: teknofix-secrets
                  key: DATABASE_URL
            - name: REDIS_URL
              value: redis://redis:6379
          ports:
            - containerPort: 3000
---
apiVersion: v1
kind: Service
metadata:
  name: download-service
spec:
  selector:
    app: download-service
  ports:
    - port: 80
      targetPort: 3000
  type: ClusterIP
K8S
echo "Wrote k8s manifests"

# .gitignore
cat > "$ROOT_DIR/.gitignore" <<'GI'
node_modules
dist
.env
.env.local
.vscode
.DS_Store
coverage
prisma/dev.db
GI
echo "Wrote .gitignore"

# Final message and optional git init actions
echo
echo "Project files created under: $ROOT_DIR"
echo

if [ "$INIT_GIT" = true ]; then
  echo "Initializing git repository..."
  cd "$ROOT_DIR"
  git init
  git checkout -b "$MAIN_BRANCH"
  git add .
  git commit -m "chore: initial commit - bootstrap download-service and prisma schema"
  echo "Committed to $MAIN_BRANCH"

  if [ -n "$REMOTE_URL" ]; then
    echo "Adding remote: $REMOTE_URL"
    git remote add origin "$REMOTE_URL"
    echo "Pushing main branch to remote..."
    git push -u origin "$MAIN_BRANCH"
    echo "Creating feature branch $BRANCH_NAME..."
    git checkout -b "$BRANCH_NAME"
    git commit --allow-empty -m "chore: create feature branch $BRANCH_NAME"
    git push -u origin "$BRANCH_NAME"
    echo "Feature branch pushed: $BRANCH_NAME"
  else
    echo "No remote provided. Local repo initialized with branch $MAIN_BRANCH and feature branch $BRANCH_NAME can be created manually."
    echo "To create feature branch now locally:"
    echo "  git checkout -b $BRANCH_NAME"
  fi
else
  echo "Git init not requested. To initialize git, run these commands:"
  echo "  cd $ROOT_DIR"
  echo "  git init"
  echo "  git checkout -b $MAIN_BRANCH"
  echo "  git add ."
  echo "  git commit -m \"chore: initial commit - bootstrap download-service and prisma schema\""
  echo "  git push -u origin $MAIN_BRANCH (after adding remote)"
  echo "Then create feature branch:"
  echo "  git checkout -b $BRANCH_NAME"
fi

echo
echo "Next steps:"
echo "  - Add production secrets to GitHub (DATABASE_URL, REDIS_URL, STORAGE_SIGN_SECRET, DOCKER credentials)."
echo "  - From repo root: docker-compose -f docker-compose.dev.yml up --build"
echo "  - From prisma folder: npx prisma generate && npx prisma migrate dev --name init"
echo "  - Seed: npx ts-node prisma/seed.ts (or transpile then node)"
echo

echo "Done."