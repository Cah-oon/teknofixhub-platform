// TeknoFixHub Application Configuration

module.exports = {
  app: {
    name: 'TeknoFixHub',
    version: '1.0.0',
    environment: process.env.NODE_ENV || 'development',
  },

  server: {
    port: process.env.PORT || 5000,
    baseUrl: process.env.BASE_URL || 'http://localhost:5000',
  },

  database: {
    type: process.env.DB_TYPE || 'mongodb',
    uri: process.env.MONGO_URI || 'mongodb://localhost:27017/teknofixhub',
    postgresUri: process.env.POSTGRES_URI || 'postgresql://user:pass@localhost:5432/teknofixhub',
  },

  jwt: {
    secret: process.env.JWT_SECRET || 'your_secret_key',
    expiresIn: process.env.JWT_EXPIRE || '7d',
  },

  cors: {
    origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
    credentials: true,
  },

  upload: {
    maxFileSize: 10 * 1024 * 1024, // 10MB
    uploadDir: 'media',
    allowedTypes: ['image/jpeg', 'image/png', 'image/gif', 'application/pdf'],
  },

  email: {
    service: process.env.EMAIL_SERVICE || 'gmail',
    from: process.env.EMAIL_FROM || 'noreply@teknofixhub.com',
    auth: {
      user: process.env.EMAIL_USER || '',
      pass: process.env.EMAIL_PASS || '',
    },
  },

  storage: {
    provider: process.env.STORAGE_PROVIDER || 'local', // local, s3, gcs
    bucket: process.env.STORAGE_BUCKET || 'teknofixhub',
    region: process.env.STORAGE_REGION || 'us-east-1',
  },

  api: {
    version: 'v1',
    baseUrl: '/api/v1',
  },

  pagination: {
    defaultLimit: 10,
    maxLimit: 100,
  },
};
