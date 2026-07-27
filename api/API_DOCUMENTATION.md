# TeknoFixHub API Documentation

Dokumentasi API lengkap untuk TeknoFixHub platform.

## 🔗 Base URL

```
http://localhost:5000/api/v1
```

## 📡 Endpoints

### Authentication

#### Register User
```
POST /auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "username": "username",
  "firstName": "John",
  "lastName": "Doe"
}

Response: 201
{
  "success": true,
  "user": { ... },
  "token": "jwt_token"
}
```

#### Login
```
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}

Response: 200
{
  "success": true,
  "user": { ... },
  "token": "jwt_token"
}
```

### Blog Endpoints

#### Get All Blog Posts
```
GET /blogs?page=1&limit=10&category=technology

Response: 200
{
  "success": true,
  "data": [ ... ],
  "pagination": { ... }
}
```

#### Get Blog Detail
```
GET /blogs/:slug

Response: 200
{
  "success": true,
  "data": { ... }
}
```

#### Create Blog Post
```
POST /blogs
Authorization: Bearer {token}
Content-Type: application/json

{
  "title": "Blog Title",
  "content": "Blog content...",
  "category": "Technology",
  "tags": ["javascript", "react"],
  "featuredImage": "image_url"
}

Response: 201
```

### Product Endpoints

#### Get Products
```
GET /products?category=electronics&page=1

Response: 200
{
  "success": true,
  "data": [ ... ]
}
```

#### Get Product Detail
```
GET /products/:id

Response: 200
{
  "success": true,
  "data": { ... }
}
```

### User Endpoints

#### Get User Profile
```
GET /users/profile
Authorization: Bearer {token}

Response: 200
{
  "success": true,
  "data": { ... }
}
```

## 🔐 Authentication

Gunakan JWT token di header:
```
Authorization: Bearer {token}
```

## ❌ Error Response

```
{
  "success": false,
  "error": "Error message",
  "status": 400
}
```

## 📊 Status Codes

- 200: OK
- 201: Created
- 400: Bad Request
- 401: Unauthorized
- 403: Forbidden
- 404: Not Found
- 500: Internal Server Error
