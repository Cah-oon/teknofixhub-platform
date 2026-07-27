# TeknoFixHub Architecture

Dokumentasi lengkap arsitektur sistem TeknoFixHub.

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENT LAYER                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐  │
│  │   Frontend       │  │   Admin Panel    │  │  Mobile App  │  │
│  │  (React 18.2)    │  │  (React Admin)   │  │  (React N.)  │  │
│  │                  │  │                  │  │              │  │
│  │  - Home          │  │  - Dashboard     │  │  (Planned)   │  │
│  │  - Blog          │  │  - Users Mgmt    │  │              │  │
│  │  - Products      │  │  - Content Mgmt  │  │              │  │
│  │  - Profile       │  │  - Analytics     │  │              │  │
│  │  - Cart          │  │  - Settings      │  │              │  │
│  └──────────────────┘  └──────────────────┘  └──────────────┘  │
│           │                    │                    │            │
└───────────┼────────────────────┼────────────────────┼────────────┘
            │                    │                    │
            └────────────────────┼────────────────────┘
                                 │
                      ┌──────────▼──────────┐
                      │   NGINX GATEWAY     │
                      │  (Reverse Proxy)    │
                      │  - Load Balancing   │
                      │  - SSL/TLS          │
                      │  - Compression      │
                      └──────────┬──────────┘
                                 │
        ┌────────────────────────┼────────────────────────┐
        │                        │                        │
┌───────▼────────┐      ┌────────▼────────┐     ┌────────▼─────┐
│  FRONTEND API  │      │  BACKEND API    │     │  ADMIN API   │
│  :3000         │      │  :5000          │     │  :3001       │
└────────────────┘      └────────┬────────┘     └──────────────┘
        │                        │
        └────────────────────────┼────────────────┐
                                 │                │
                      ┌──────────▼──────────┐     │
                      │   APPLICATION      │     │
                      │   SERVER LAYER     │     │
                      │  (Node.js+Express) │     │
                      │                    │     │
                      │ ┌────────────────┐ │     │
                      │ │   Controllers  │ │     │
                      │ │   - Blog       │ │     │
                      │ │   - Product    │ │     │
                      │ │   - User       │ │     │
                      │ │   - Auth       │ │     │
                      │ │   - Payment    │ │     │
                      │ └────────────────┘ │     │
                      │ ┌────────────────┐ │     │
                      │ │   Services     │ │     │
                      │ │   - Auth       │ │     │
                      │ │   - Email      │ │     │
                      │ │   - Storage    │ │     │
                      │ │   - Payment    │ │     │
                      │ └────────────────┘ │     │
                      │ ┌────────────────┐ │     │
                      │ │  Middleware    │ │     │
                      │ │  - Auth JWT    │ │     │
                      │ │  - Validation  │ │     │
                      │ │  - CORS        │ │     │
                      │ └────────────────┘ │     │
                      └────────┬───────────┘     │
                               │                 │
        ┌──────────────────────┼─────────────────┼──────────┐
        │                      │                 │          │
┌───────▼──────────┐  ┌────────▼────────┐  ┌───▼──────┐  ┌─▼────┐
│    DATABASE      │  │   CACHE LAYER   │  │ STORAGE  │  │ MAIL  │
│    LAYER         │  │   (Redis)       │  │ (S3/GCS) │  │       │
│                  │  │                 │  │          │  │       │
│ ┌──────────────┐ │  │ - Session       │  │ - Images │  │ SMTP  │
│ │   MongoDB    │ │  │ - Cache         │  │ - Files  │  │       │
│ │   OR         │ │  │ - Queue         │  │ - Media  │  └───────┘
│ │  PostgreSQL  │ │  │ - Rate Limit    │  │          │
│ │              │ │  │                 │  │          │
│ │ Collections: │ │  └─────────────────┘  └──────────┘
│ │ - users      │ │
│ │ - blogs      │ │
│ │ - products   │ │
│ │ - orders     │ │
│ │ - affiliates │ │
│ └──────────────┘ │
└──────────────────┘
```

## 📊 Data Flow

### User Authentication Flow

```
1. User Input (Email/Password)
        ↓
2. POST /api/auth/login
        ↓
3. Backend Validation
   - Validate email format
   - Check user exists
   - Verify password (bcrypt)
        ↓
4. Generate JWT Token
   - user_id
   - email
   - role
        ↓
5. Return Token + User Data
        ↓
6. Frontend Store Token (localStorage/sessionStorage)
        ↓
7. Set Authorization Header
   Authorization: Bearer {token}
        ↓
8. Protected Routes Access
```

### Blog Post Creation Flow

```
1. Admin/Writer Input
   - Title, Content, Images, Tags, Category
        ↓
2. POST /api/blogs (with JWT)
        ↓
3. Middleware Validation
   - JWT verification
   - Authorization check
   - Input validation
        ↓
4. Image Upload Service
   - Upload to S3/Storage
   - Generate URLs
        ↓
5. Create Blog Post
   - Save to MongoDB/PostgreSQL
   - Create slug
   - Set metadata
        ↓
6. Update Cache (Redis)
   - Cache recent posts
   - Invalidate relevant caches
        ↓
7. Return Success Response
```

### Product Purchase Flow

```
1. Customer Adds to Cart
   - Store in localStorage/Session
        ↓
2. Checkout
   - Review items & quantities
   - Provide shipping address
   - Select payment method
        ↓
3. POST /api/orders
   - Create order record
   - Update inventory
   - Generate order ID
        ↓
4. Payment Processing
   - Stripe/PayPal integration
   - Validate payment
   - Confirm transaction
        ↓
5. Order Confirmation
   - Send email
   - Update order status
   - Clear cart
        ↓
6. Affiliate Commission
   - Check affiliate link
   - Track sale
   - Credit commission
```

## 🔐 Security Architecture

```
┌─────────────────────────────────────────────────────────┐
│              SECURITY LAYERS                             │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  1. HTTPS/TLS Layer
│     - Encrypt data in transit
│     - SSL certificates
│                                                          │
│  2. CORS Policy
│     - Whitelist allowed origins
│     - Prevent CSRF attacks
│                                                          │
│  3. Authentication Layer
│     - JWT tokens
│     - Session management
│     - Refresh tokens
│                                                          │
│  4. Authorization Layer
│     - Role-based access control
│     - Resource ownership checks
│     - Permission validation
│                                                          │
│  5. Input Validation
│     - XSS prevention
│     - SQL injection prevention
│     - Rate limiting
│                                                          │
│  6. Password Security
│     - bcryptjs hashing
│     - Salt generation
│     - Password complexity rules
│                                                          │
│  7. Data Protection
│     - Sensitive data encryption
│     - Secure headers
│     - HTTPS only cookies
│                                                          │
└─────────────────────────────────────────────────────────┘
```

## 🎯 Microservices Architecture (Future)

```
┌──────────────────────────────────────────────────────┐
│           API GATEWAY (Kong/Nginx)                   │
├──────────────────────────────────────────────────────┤
│  - Route requests
│  - Rate limiting
│  - Authentication
│  - Load balancing
└────────┬────────┬──────────┬─────────┬──────────────┘
         │        │          │         │
    ┌────▼──┐ ┌──▼───┐ ┌────▼──┐ ┌──▼───┐
    │ Auth  │ │ Blog │ │Product│ │Order │
    │Service│ │Service│ │Service│ │Service
    └───┬───┘ └──┬───┘ └───┬───┘ └──┬───┘
        │        │         │        │
    ┌───▼───────▼─────────▼────────▼───┐
    │      Message Queue (RabbitMQ)    │
    │      - Event publishing          │
    │      - Async processing          │
    │      - Service communication     │
    └────────────────────────────────────┘
         │         │         │
    ┌────▼──────┬──▼──┬──────▼──┐
    │ Email     │ SMS │ Notification
    │Service    │Svc  │Service
    └───────────┴─────┴──────────┘
```

## 📈 Scalability Considerations

### Horizontal Scaling
```
Load Balancer (Nginx)
    │
    ├─ Backend Instance 1 (Node.js)
    ├─ Backend Instance 2 (Node.js)
    └─ Backend Instance 3 (Node.js)
            │
        ┌───┴───┐
        │       │
   MongoDB  Redis
   Cluster  Cluster
```

### Database Optimization
- Indexing: Proper database indexes
- Caching: Redis for frequently accessed data
- Partitioning: Shard large collections
- Replication: Master-slave database setup

### Performance Tips
- Image optimization with CDN
- Code splitting in React
- API response caching
- Database query optimization
- Compression (gzip)

## 🔄 CI/CD Pipeline

```
Git Push
   │
   ├─ GitHub Webhook
   │
   └─ GitHub Actions Workflow
      │
      ├─ Test
      │  ├─ Lint
      │  ├─ Unit Tests
      │  └─ Integration Tests
      │
      ├─ Build
      │  ├─ Compile
      │  └─ Bundle
      │
      ├─ Docker Image
      │  └─ Build & Push to Registry
      │
      └─ Deploy (Main branch only)
         ├─ Development
         ├─ Staging
         └─ Production
```

## 📚 Design Patterns Used

### 1. MVC (Model-View-Controller)
- Backend: Controllers handle requests
- Frontend: Components as views
- Database: Models define data structure

### 2. Service Layer Pattern
- Business logic separated from controllers
- Reusable services across the application
- Easy testing and maintenance

### 3. Repository Pattern
- Data access layer abstraction
- Easy switching between databases
- Simplified testing

### 4. Middleware Pattern
- Request/response processing pipeline
- Authentication, validation, logging
- Clean separation of concerns

### 5. Observer Pattern
- Event-driven architecture
- Redis pub/sub for real-time updates
- Loose coupling between services

### 6. Factory Pattern
- Database instance creation
- Service instantiation
- Flexible object creation

## 🗺️ File Structure Rationale

```
frontend/          → UI layer, user-facing features
backend/           → Business logic, API server
admin/             → Management interface
api/               → API documentation
database/          → Schema, migrations, seeds
docker/            → Containerization configs
docs/              → Project documentation
config/            → Centralized configuration
scripts/           → Automation utilities
github/            → CI/CD workflows
assets/            → Static resources
products/          → Product data
affiliate/         → Affiliate system
firmware/          → IoT firmware
media/             → User uploads
storage/           → Cloud config
```

## 🔄 Request-Response Cycle

```
HTTP Request
   │
   ├─ Nginx (Reverse Proxy)
   │
   ├─ Express Middleware Stack
   │  ├─ CORS middleware
   │  ├─ Body parser
   │  ├─ Authentication
   │  └─ Validation
   │
   ├─ Route Handler (Controller)
   │  ├─ Request parsing
   │  └─ Call service
   │
   ├─ Service Layer
   │  ├─ Business logic
   │  ├─ Database queries
   │  └─ External API calls
   │
   ├─ Database Layer
   │  ├─ Query execution
   │  └─ Result processing
   │
   ├─ Response Assembly
   │  ├─ Format response
   │  ├─ Set headers
   │  └─ Cache if needed
   │
   └─ HTTP Response
      └─ JSON/HTML sent to client
```

---

**For more details, see specific component documentation in their README files.**
