# {{PROJECT_NAME}}

A modern full-stack web application built with **Go Chi**, **PostgreSQL**, **React**, and **Vite**.

## 🚀 Tech Stack

### Backend

- **Framework:** Go with Chi router
- **Database:** PostgreSQL with pgx driver
- **Queries:** SQLC for type-safe SQL
- **Migrations:** Goose
- **Authentication:** JWT
- **Cache:** Redis (optional)
- **Validation:** go-playground/validator

### Frontend

- **Framework:** React 18
- **Build Tool:** Vite
- **Styling:** Tailwind CSS
- **State Management:** Zustand
- **HTTP Client:** Axios + React Query
- **Routing:** React Router v6

## 📁 Project Structure

```
{{PROJECT_NAME}}/
├── cmd/web/              # Application entry point
├── internal/
│   ├── handlers/         # HTTP handlers (controllers)
│   ├── services/         # Business logic
│   ├── database/         # SQLC generated code
│   ├── cache/            # Redis integration
│   ├── dto/              # Data transfer objects
│   ├── config/           # Configuration
│   ├── middleware/       # HTTP middleware
│   └── utils/            # Utilities
├── sql/
│   ├── migrations/       # Goose database migrations
│   └── queries/          # SQLC query definitions
├── ui/                   # React + Vite frontend
└── scripts/              # Development scripts
```

## 🛠 Quick Start

### 1. Create from Template

```bash
# Use GitHub's "Use this template" button or:
gh repo create {{PROJECT_NAME}} --template yourusername/go-chi-react-template
```

### 2. Setup Project

```bash
cd {{PROJECT_NAME}}
./scripts/setup.sh {{PROJECT_NAME}}
```

### 3. Start Everything

```bash
make start-all
```

This will:

- Start PostgreSQL and Redis with Docker
- Install development tools
- Run database migrations
- Generate SQLC code

### 4. Start Development Servers

```bash
# Terminal 1: Backend (with hot reload)
make dev

# Terminal 2: Frontend (with hot reload)
cd ui && npm run dev
```

**🎉 Your app is ready!**

- Backend: <http://localhost:8080>
- Frontend: <http://localhost:5173>
- Database: PostgreSQL on localhost:5432
- Cache: Redis on localhost:6379

## 🧰 Development Commands

### Backend

```bash
make help                    # Show all commands
make dev                     # Start with hot reload
make build                   # Build production binary
make test                    # Run tests
make migrate-up              # Run migrations
make migrate-create NAME=... # Create new migration
make sqlc-generate           # Generate Go from SQL
```

### Frontend

```bash
cd ui
npm run dev                  # Development server
npm run build                # Production build
npm test                     # Run tests
npm run lint                 # Lint code
```

### Database

```bash
make docker-up               # Start PostgreSQL + Redis
make migrate-status          # Check migration status
make migrate-down            # Rollback migrations
```

## 🔧 Configuration

### Environment Variables

Copy `.env.example` to `.env` and configure:

```bash
# Database
DATABASE_URL=postgres://postgres:postgres@localhost:5432/{{PROJECT_NAME}}_dev?sslmode=disable

# Server
SERVER_ADDRESS=:8080
JWT_SECRET=your-secret-key

# Redis (optional)
REDIS_ENABLED=true
REDIS_URL=redis://localhost:6379

# Frontend
FRONTEND_URL=http://localhost:5173
```

### Frontend Environment

Create `ui/.env.local`:

```bash
VITE_API_URL=http://localhost:8080/api/v1
```

## 🗄️ Database

### Migrations

```bash
# Create new migration
make migrate-create NAME=add_users_table

# Run migrations
make migrate-up

# Check status
make migrate-status
```

### Queries

Write SQL in `sql/queries/*.sql`:

```sql
-- name: GetUser :one
SELECT id, name, email FROM users WHERE id = $1;

-- name: ListUsers :many
SELECT id, name, email FROM users ORDER BY name;
```

Generate Go code:

```bash
make sqlc-generate
```

## 🧪 Testing

```bash
# Backend tests
make test-backend

# Frontend tests
make test-frontend

# All tests
make test

# Coverage report
make test-coverage
```

## 🚀 Production Deployment

### Docker

```bash
docker-compose -f docker-compose.prod.yml up --build
```

### Manual

```bash
# Build everything
make build

# Run migrations
make migrate-up

# Start server
./bin/{{PROJECT_NAME}}
```

## 📝 API Documentation

The API follows RESTful conventions:

- `GET /api/v1/health` - Health check
- `POST /api/v1/auth/register` - User registration
- `POST /api/v1/auth/login` - User login
- `GET /api/v1/snippets` - List snippets
- `POST /api/v1/snippets` - Create snippet

See [docs/API.md](docs/API.md) for complete documentation.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Add tests
5. Run tests: `make test`
6. Commit: `git commit -m 'Add amazing feature'`
7. Push: `git push origin feature/amazing-feature`
8. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

🎯 **Generated from [go-chi-react-template](https://github.com/yourusername/go-chi-react-template)**

**Happy coding!** 🚀
