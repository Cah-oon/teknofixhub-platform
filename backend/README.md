# TeknoFixHub Backend

Node.js + Express.js backend API server untuk TeknoFixHub platform.

## 📦 Struktur Folder

```
backend/
├── src/
│   ├── controllers/    # Route controllers
│   ├── models/         # Database models
│   ├── routes/         # API routes
│   ├── middleware/     # Custom middleware
│   ├── services/       # Business logic
│   ├── utils/          # Utility functions
│   ├── config/         # Configuration
│   ├── index.js        # Server entry point
│   └── database.js     # Database connection
├── tests/              # Test files
├── scripts/            # Migration scripts
├── .env.example        # Environment variables template
└── package.json
```

## 🚀 Setup

```bash
npm install
cp .env.example .env
npm run dev
```

## 📡 API Endpoints

### Blog
- `GET /api/blogs` - Get all blogs
- `GET /api/blogs/:id` - Get blog detail
- `POST /api/blogs` - Create new blog
- `PUT /api/blogs/:id` - Update blog
- `DELETE /api/blogs/:id` - Delete blog

### Users
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `GET /api/users/:id` - Get user profile
- `PUT /api/users/:id` - Update user

### Products
- `GET /api/products` - Get all products
- `POST /api/products` - Create product
- `PUT /api/products/:id` - Update product
- `DELETE /api/products/:id` - Delete product

## 🔐 Authentication

Menggunakan JWT (JSON Web Token) untuk authentication.

## 🗄️ Database

MongoDB untuk storage dengan Mongoose ODM.

## 📝 Environment Variables

```
MONGO_URI=mongodb://localhost:27017/teknofixhub
JWT_SECRET=your_secret_key
PORT=5000
NODE_ENV=development
```
