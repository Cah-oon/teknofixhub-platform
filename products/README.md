# TeknoFixHub Product Catalog

Database dan dokumentasi product catalog.

## 📦 Product Categories

- **Electronics** - Gadget dan elektronik
- **Components** - Spare part dan komponen
- **Tools** - Software dan tools
- **Books** - E-book dan tutorials
- **Courses** - Online courses
- **Premium** - Premium membership

## 📊 Product Structure

```
{
  id: string,
  name: string,
  slug: string,
  description: string,
  category: string,
  price: number,
  discountPrice: number,
  stock: number,
  image: string,
  images: [string],
  rating: number,
  reviews: number,
  affiliate: boolean,
  featured: boolean,
  createdAt: date,
  updatedAt: date
}
```

## 🛒 Features

- Product search & filtering
- Advanced product management
- Inventory tracking
- Product reviews & ratings
- Affiliate product support
- Bulk operations
- Analytics

## 📁 Files

- `products.json` - Sample product data
- `categories.json` - Category data
- `schema.md` - Database schema

Lihat documentation untuk info lebih lengkap.
