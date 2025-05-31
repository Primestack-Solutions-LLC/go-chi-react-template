#!/bin/bash

PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: $0 <project-name>"
  echo "Example: $0 my-awesome-app"
  exit 1
fi

echo "🚀 Setting up Go Chi + React + Vite project: $PROJECT_NAME"

# Validate project name
if [[ ! "$PROJECT_NAME" =~ ^[a-z][a-z0-9-]*$ ]]; then
  echo "❌ Project name must start with a letter and contain only lowercase letters, numbers, and hyphens"
  exit 1
fi

# Replace template variables
echo "📝 Replacing template variables..."

# Handle go.mod specially
if [ -f "go.mod.template" ]; then
  sed "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" go.mod.template >go.mod
  rm go.mod.template
fi

# Replace in all relevant files
find . -type f \( -name "*.go" -o -name "*.md" -o -name "*.yml" -o -name "*.yaml" -o -name "*.sql" -o -name "*.js" -o -name "*.jsx" -o -name "*.json" -o -name "*.toml" \) \
  -not -path "./node_modules/*" \
  -not -path "./.git/*" \
  -not -path "./ui/dist/*" \
  -not -path "./ui/build/*" \
  -exec sed -i.bak "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" {} +

# Clean up backup files
find . -name "*.bak" -delete

# Initialize Go module
echo "📦 Initializing Go module..."
go mod tidy

# Make scripts executable
chmod +x scripts/*.sh

# Create .env from example
if [ ! -f ".env" ]; then
  cp .env.example .env
  sed -i.bak "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" .env
  rm .env.bak
  echo "📋 Created .env file from template"
fi

# Setup UI dependencies
echo "🎨 Setting up React + Vite frontend..."
cd ui
npm install
cd ..

echo ""
echo "✅ Project $PROJECT_NAME setup complete!"
echo ""
echo "🔧 Next steps:"
echo "1. Edit .env file with your database credentials"
echo "2. Start database: make docker-up"
echo "3. Install tools: make install-tools"
echo "4. Run migrations: make migrate-up"
echo "5. Generate SQLC: make sqlc-generate"
echo "6. Start backend: make dev"
echo "7. Start frontend: cd ui && npm run dev"
echo ""
echo "🚀 Quick start everything:"
echo "   make start-all"
