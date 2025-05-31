.PHONY: help install-tools migrate-up migrate-down migrate-create sqlc-generate dev build test clean docker-up docker-down start-all

# Load environment variables
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install-tools: ## Install development tools
	@echo "🔧 Installing development tools..."
	@go install github.com/pressly/goose/v3/cmd/goose@latest
	@go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest
	@go install github.com/cosmtrek/air@latest
	@echo "✅ Tools installed successfully"

migrate-up: ## Run database migrations up
	@echo "⬆️  Running migrations..."
	@goose -dir sql/migrations postgres "$(DATABASE_URL)" up

migrate-down: ## Run database migrations down
	@echo "⬇️  Rolling back migrations..."
	@goose -dir sql/migrations postgres "$(DATABASE_URL)" down

migrate-create: ## Create a new migration file (usage: make migrate-create NAME=migration_name)
	@goose -dir sql/migrations create $(NAME) sql

migrate-status: ## Check migration status
	@goose -dir sql/migrations postgres "$(DATABASE_URL)" status

sqlc-generate: ## Generate Go code from SQL queries
	@echo "🔄 Generating SQLC code..."
	@sqlc generate
	@echo "✅ SQLC code generated successfully"

dev: sqlc-generate ## Run the application in development mode with hot reload
	@echo "🚀 Starting development server with hot reload..."
	@air

dev-no-air: sqlc-generate ## Run the application in development mode without hot reload
	@echo "🚀 Starting development server..."
	@go run ./cmd/web

build: sqlc-generate ## Build the application
	@echo "🔨 Building backend..."
	@go build -o bin/{{PROJECT_NAME}} ./cmd/web
	@echo "🔨 Building frontend..."
	@cd ui && npm run build
	@echo "✅ Built successfully to bin/{{PROJECT_NAME}}"

build-backend: sqlc-generate ## Build only the backend
	@echo "🔨 Building backend..."
	@go build -o bin/{{PROJECT_NAME}} ./cmd/web

build-frontend: ## Build only the frontend
	@echo "🔨 Building frontend..."
	@cd ui && npm run build

test: ## Run all tests
	@echo "🧪 Running backend tests..."
	@go test -v ./...
	@echo "🧪 Running frontend tests..."
	@cd ui && npm test

test-backend: ## Run backend tests only
	@go test -v ./...

test-frontend: ## Run frontend tests only
	@cd ui && npm test

test-coverage: ## Run tests with coverage
	@go test -coverprofile=coverage.out ./...
	@go tool cover -html=coverage.out -o coverage.html
	@echo "✅ Coverage report generated: coverage.html"

clean: ## Clean build artifacts
	@rm -rf bin/
	@rm -rf ui/dist/
	@rm -f coverage.out coverage.html
	@echo "✅ Cleaned build artifacts"

docker-up: ## Start development environment with Docker
	@echo "🐳 Starting development environment..."
	@docker-compose up -d
	@echo "✅ Development environment started"
	@echo "   PostgreSQL: localhost:5432"
	@echo "   Redis: localhost:6379"

docker-down: ## Stop development environment
	@docker-compose down
	@echo "✅ Development environment stopped"

docker-logs: ## Show Docker logs
	@docker-compose logs -f

start-all: docker-up install-tools migrate-up sqlc-generate ## Start everything for development
	@echo "🚀 Starting full development environment..."
	@echo "✅ Backend will be available at http://localhost:8080"
	@echo "✅ Frontend will be available at http://localhost:5173"
	@echo ""
	@echo "Run in separate terminals:"
	@echo "   make dev        # Backend with hot reload"
	@echo "   cd ui && npm run dev  # Frontend with hot reload"

lint: ## Run linter
	@golangci-lint run
	@cd ui && npm run lint

format: ## Format code
	@go fmt ./...
	@cd ui && npm run format
	@echo "✅ Code formatted"

ui-install: ## Install UI dependencies
	@cd ui && npm install

ui-dev: ## Start UI development server
	@cd ui && npm run dev

ui-build: ## Build UI for production
	@cd ui && npm run build

ui-test: ## Run UI tests
	@cd ui && npm test

