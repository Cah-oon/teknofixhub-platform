# Database Schema

Dokumentasi database struktur untuk TeknoFixHub platform.

## 📊 Collections/Tables

### Users
```
{
  _id: ObjectId,
  email: String,
  password: String (hashed),
  username: String,
  firstName: String,
  lastName: String,
  avatar: String,
  role: String (admin, user, writer),
  isActive: Boolean,
  createdAt: Date,
  updatedAt: Date
}
```

### Blog Posts
```
{
  _id: ObjectId,
  title: String,
  slug: String,
  content: String,
  excerpt: String,
  author: ObjectId (ref: User),
  category: String,
  tags: [String],
  featuredImage: String,
  views: Number,
  published: Boolean,
  publishedAt: Date,
  createdAt: Date,
  updatedAt: Date
}
```

### Products
```
{
  _id: ObjectId,
  name: String,
  slug: String,
  description: String,
  price: Number,
  discountPrice: Number,
  stock: Number,
  category: String,
  image: String,
  images: [String],
  rating: Number,
  reviews: [ObjectId],
  affiliate: Boolean,
  createdAt: Date,
  updatedAt: Date
}
```

### Categories
```
{
  _id: ObjectId,
  name: String,
  slug: String,
  description: String,
  image: String,
  order: Number,
  createdAt: Date
}
```

## 🔑 Indexes

- Users: email (unique)
- Blog Posts: slug (unique), authorId
- Products: slug (unique), category
- Categories: slug (unique)

## 📝 Migrations

Lihat folder `scripts/` untuk migration files.
