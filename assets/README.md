# TeknoFixHub Asset Management

Folder untuk managing static assets (images, icons, fonts, etc).

## 📁 Struktur

```
assets/
├── images/
│   ├── logo/
│   ├── icons/
│   ├── illustrations/
│   └── screenshots/
├── icons/
│   ├── svg/
│   └── fonts/
├── fonts/
│   ├── inter/
│   ├── roboto/
│   └── ...
├── styles/
│   └── global.css
└── README.md
```

## 🎨 Image Optimization

Semua images harus dioptimasi:

```bash
# Using imagemin
npx imagemin assets/images/* --out-dir=public/images

# Or using sharp
node scripts/optimize-images.js
```

## 🔤 Font Management

1. Place font files di `assets/fonts/`
2. Define font faces di global CSS
3. Load di main application

Contoh:
```css
@font-face {
  font-family: 'Inter';
  src: url('/fonts/inter/inter.woff2') format('woff2');
}
```

## 📦 SVG Icons

Gunakan SVG untuk icons karena scalable dan lightweight.

Lokasi: `assets/icons/svg/`

## 🚀 Deployment

Semua assets akan dicopy ke `public/` folder saat build.

```bash
npm run build
```
