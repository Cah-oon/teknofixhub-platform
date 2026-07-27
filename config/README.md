# TeknoFixHub Config

Konfigurasi aplikasi TeknoFixHub.

## 📁 Files

- `app.config.js` - Konfigurasi aplikasi
- `database.config.js` - Konfigurasi database
- `email.config.js` - Konfigurasi email
- `storage.config.js` - Konfigurasi cloud storage
- `cdn.config.js` - Konfigurasi CDN

## 🔧 Penggunaan

```javascript
const config = require('./config');

const apiUrl = config.api.baseUrl;
const dbUri = config.database.uri;
```

Lihat file konfigurasi untuk detail lebih lanjut.
