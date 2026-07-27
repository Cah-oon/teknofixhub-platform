#!/bin/bash

# TeknoFixHub Database Backup Script

BACKUP_DIR="backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "💾 Starting database backup..."

# MongoDB backup
if command -v mongodump &> /dev/null; then
    echo "Backing up MongoDB..."
    mongodump --uri="$MONGO_URI" --archive="$BACKUP_DIR/mongodb_$TIMESTAMP.archive"
    echo "✅ MongoDB backup complete: $BACKUP_DIR/mongodb_$TIMESTAMP.archive"
fi

# PostgreSQL backup
if command -v pg_dump &> /dev/null; then
    echo "Backing up PostgreSQL..."
    pg_dump $DATABASE_URL > "$BACKUP_DIR/postgresql_$TIMESTAMP.sql"
    echo "✅ PostgreSQL backup complete: $BACKUP_DIR/postgresql_$TIMESTAMP.sql"
fi

# Compress backups
if command -v gzip &> /dev/null; then
    echo "Compressing backups..."
    gzip -r "$BACKUP_DIR/"*_$TIMESTAMP.*
    echo "✅ Compression complete"
fi

echo "💾 Backup complete!"
