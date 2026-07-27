# TeknoFixHub Development Guide

Panduan lengkap untuk development TeknoFixHub platform.

## 🎯 Development Setup

### Prerequisites

- Node.js >= 16.x
- npm >= 8.x
- Git
- Code Editor (VS Code recommended)
- MongoDB or PostgreSQL (optional for local dev)

### Initial Setup

```bash
# Clone repository
cd /workspaces/teknofixhub-platform/TeknoFixHub_Ultimate

# Run automated setup
./dev-start.sh

# Or manual setup
cd backend && npm install
cd ../frontend && npm install
cd ../admin && npm install
```

## 🚀 Starting Development

### Start All Services

#### Option 1: Individual Terminals (Recommended)

**Terminal 1 - Backend**
```bash
cd backend
cp .env.example .env
# Edit .env with your config
npm run dev
```

**Terminal 2 - Frontend**
```bash
cd frontend
npm run dev
```

**Terminal 3 - Admin**
```bash
cd admin
npm run dev
```

#### Option 2: Using Docker

```bash
./docker-start.sh
```

#### Option 3: Process Manager (PM2)

```bash
npm install -g pm2

# Backend
cd backend && pm2 start "npm run dev" --name "teknofixhub-backend"

# Frontend
cd frontend && pm2 start "npm run dev" --name "teknofixhub-frontend"

# Admin
cd admin && pm2 start "npm run dev" --name "teknofixhub-admin"

# Monitor all
pm2 monit
```

## 📝 Development Workflow

### Feature Development

1. **Create Feature Branch**
```bash
git checkout -b feature/your-feature-name
```

2. **Make Changes**
   - Follow coding standards
   - Write tests
   - Update documentation

3. **Test Your Changes**
```bash
# Backend
cd backend && npm test

# Frontend
cd frontend && npm test
```

4. **Commit Changes**
```bash
git add .
git commit -m "feat: Add your feature description"
git push origin feature/your-feature-name
```

5. **Create Pull Request**
   - Fill PR template
   - Request reviewers
   - Wait for approval

### Commit Message Convention

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: Feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style
- `refactor`: Refactoring
- `test`: Tests
- `chore`: Dependencies/tooling

**Example:**
```
feat(blog): Add blog post filtering

- Add category filter
- Add tag filter
- Add search functionality

Closes #123
```

## 🛠️ Common Development Tasks

### Add New Backend Route

1. Create controller in `backend/src/controllers/`
```javascript
// backend/src/controllers/blogController.js
const getBlog = async (req, res) => {
  const { id } = req.params;
  // Implementation
  res.json({ data: blog });
};

module.exports = { getBlog };
```

2. Create route in `backend/src/routes/`
```javascript
// backend/src/routes/blogRoutes.js
const express = require('express');
const { getBlog } = require('../controllers/blogController');

const router = express.Router();
router.get('/:id', getBlog);

module.exports = router;
```

3. Register route in `backend/src/index.js`
```javascript
const blogRoutes = require('./routes/blogRoutes');
app.use('/api/blogs', blogRoutes);
```

### Add New Frontend Component

1. Create component in `frontend/src/components/`
```javascript
// frontend/src/components/BlogCard.jsx
import React from 'react';

const BlogCard = ({ blog }) => {
  return (
    <div className="card">
      <h3>{blog.title}</h3>
      <p>{blog.excerpt}</p>
    </div>
  );
};

export default BlogCard;
```

2. Use component in page
```javascript
import BlogCard from '../components/BlogCard';

export default function BlogPage() {
  return (
    <div>
      <BlogCard blog={blogData} />
    </div>
  );
}
```

### Add Database Schema

1. Create migration in `database/`
```sql
-- database/migrations/002_create_categories.sql
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(100) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

2. Run migration
```bash
psql -U teknofixhub -d teknofixhub -f database/migrations/002_create_categories.sql
```

### API Request Example

1. Create API service
```javascript
// frontend/src/services/blogService.js
import axios from 'axios';

const API_URL = import.meta.env.VITE_API_URL;

export const getBlog = (id) => {
  return axios.get(`${API_URL}/blogs/${id}`);
};

export const createBlog = (data, token) => {
  return axios.post(`${API_URL}/blogs`, data, {
    headers: { Authorization: `Bearer ${token}` }
  });
};
```

2. Use in component
```javascript
import { getBlog } from '../services/blogService';
import { useEffect, useState } from 'react';

export default function BlogDetail() {
  const [blog, setBlog] = useState(null);

  useEffect(() => {
    getBlog(1).then(res => setBlog(res.data));
  }, []);

  return <div>{blog && <h1>{blog.title}</h1>}</div>;
}
```

## 🧪 Testing

### Backend Tests

```bash
cd backend

# Run all tests
npm test

# Run specific test
npm test -- tests/blog.test.js

# With coverage
npm test -- --coverage

# Watch mode
npm test -- --watch
```

**Example Test:**
```javascript
// backend/tests/blog.test.js
const request = require('supertest');
const app = require('../src/index');

describe('Blog API', () => {
  test('GET /api/blogs should return all blogs', async () => {
    const res = await request(app)
      .get('/api/blogs');
    
    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body.data)).toBe(true);
  });
});
```

### Frontend Tests

```bash
cd frontend

# Run tests
npm test

# Watch mode
npm test -- --watch

# Coverage
npm test -- --coverage
```

**Example Test:**
```javascript
// frontend/src/components/BlogCard.test.jsx
import { render, screen } from '@testing-library/react';
import BlogCard from './BlogCard';

describe('BlogCard', () => {
  test('renders blog title', () => {
    const blog = { title: 'Test Blog', excerpt: 'Test' };
    render(<BlogCard blog={blog} />);
    
    expect(screen.getByText('Test Blog')).toBeInTheDocument();
  });
});
```

## 🔍 Debugging

### Backend Debugging

1. **Using Node Debugger**
```bash
node --inspect backend/src/index.js
```

2. **VS Code Debugging**

Create `.vscode/launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "program": "${workspaceFolder}/backend/src/index.js",
      "cwd": "${workspaceFolder}/backend"
    }
  ]
}
```

3. **Console Logging**
```javascript
console.log('Debug:', variable);
console.error('Error:', error);
```

### Frontend Debugging

1. **Browser DevTools**
   - F12 or right-click → Inspect
   - Console, Network, Application tabs

2. **VS Code Extension**
   - Install "Debugger for Firefox" or "Debugger for Chrome"

3. **React DevTools**
   - Install React DevTools extension
   - Inspect component hierarchy

### API Debugging with Postman

1. Import Postman collection from `api/POSTMAN_COLLECTION.md`
2. Set environment variables
3. Test API endpoints
4. Check response structure

## 📊 Performance Optimization

### Frontend

```javascript
// Code splitting
const BlogDetail = lazy(() => import('./pages/BlogDetail'));

// Memoization
const BlogCard = memo(({ blog }) => {...});

// Lazy loading images
<img loading="lazy" src={url} />

// Optimize bundle
// Use Tree shaking
// Remove unused packages
```

### Backend

```javascript
// Connection pooling
const mongoose = require('mongoose');
mongoose.connect(uri, {
  maxPoolSize: 10
});

// Caching
const cached = await redis.get(key);
if (cached) return JSON.parse(cached);

// Pagination
const limit = Math.min(req.query.limit || 10, 100);
const skip = (req.query.page - 1) * limit;
```

## 📚 Code Style & Standards

### Formatting

```bash
# Format code
npm run format

# Or manually
npx prettier --write src/
```

### Linting

```bash
# Lint code
npm run lint

# Fix issues
npm run lint --fix
```

### Naming Conventions

**JavaScript/React:**
- Variables: `camelCase`
- Functions: `camelCase`
- Classes: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`
- Components: `PascalCase`
- Files: `camelCase.js` or `PascalCase.jsx`

**Database:**
- Tables: `snake_case`
- Columns: `snake_case`
- Indexes: `idx_table_column`

## 🔐 Security Practices

### Frontend
- Never store sensitive data in localStorage
- Validate user input
- Use HTTPS only
- Sanitize HTML content
- CSRF token validation

### Backend
- Hash passwords with bcrypt
- Validate all inputs
- Use parameterized queries
- Implement rate limiting
- Add CORS restrictions
- Sanitize database queries
- Keep dependencies updated

## 📖 Documentation

### Write Good Comments

```javascript
// Good: Explains why
// User needs to be verified before accessing admin features
if (!user.isVerified) {
  return res.status(403).json({ error: 'User not verified' });
}

// Avoid: Redundant
// Set x to 5
const x = 5;
```

### Update README Files

- When adding new features
- When changing project structure
- When updating dependencies
- When modifying setup instructions

### JSDoc Comments

```javascript
/**
 * Creates a new blog post
 * @param {Object} data - Blog post data
 * @param {string} data.title - Post title
 * @param {string} data.content - Post content
 * @returns {Promise<Object>} Created blog post
 * @throws {Error} If validation fails
 */
const createBlog = async (data) => {
  // implementation
};
```

## 🚀 Deployment Checklist

- [ ] All tests passing
- [ ] Code reviewed
- [ ] Documentation updated
- [ ] Environment variables set
- [ ] Database migrations run
- [ ] Dependencies updated
- [ ] Security audit passed
- [ ] Performance optimized
- [ ] Error handling added
- [ ] Logging configured

## 🆘 Troubleshooting

### Hot Reload Not Working

```bash
# Clear cache
npm cache clean --force

# Reinstall
rm -rf node_modules package-lock.json
npm install

# Restart server
npm run dev
```

### Database Connection Error

Check:
- Database is running
- Connection string in .env
- Username/password correct
- Port accessible

### Module Not Found

```bash
# Verify import path
# Check file exists
# Reinstall dependencies
npm install
```

### Port Already in Use

```bash
# Find and kill process
lsof -i :5000
kill -9 <PID>
```

## 📞 Getting Help

1. Check documentation files
2. Read error messages carefully
3. Search GitHub issues
4. Ask in team chat
5. Create detailed bug report

## ✅ Coding Checklist

Before submitting PR:

- [ ] Code follows style guide
- [ ] Tests written and passing
- [ ] No console errors/warnings
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No sensitive data committed
- [ ] Performance acceptable
- [ ] Accessibility considered
- [ ] Cross-browser compatibility checked
- [ ] Git history clean

---

**Happy Coding! 🚀**
