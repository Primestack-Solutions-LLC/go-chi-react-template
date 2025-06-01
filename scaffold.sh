#!/bin/bash

# Project name
PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: $0 <project-name>"
  exit 1
fi

# Create directory structure based on Let's Go conventions
mkdir -p "$PROJECT_NAME"/{cmd/web,internal,ui/{html,static}}
cd "$PROJECT_NAME"

# Initialize Go module
go mod init github.com/yourusername/$PROJECT_NAME

echo "module github.com/yourusername/$PROJECT_NAME

go 1.21

require (
	github.com/go-chi/chi/v5 v5.0.9
	github.com/jackc/pgx/v5 v5.5.4
	github.com/pressly/goose/v3 v3.12.0
)
" >go.mod

# Main application file
cat <<EOF >cmd/web/main.go
package main

import (
	"log"
	"net/http"

	"github.com/go-chi/chi/v5"
)

func main() {
	r := chi.NewRouter()
	r.Get("/*", http.FileServer(http.Dir("./ui/static")).ServeHTTP)

	log.Println("Server started on :4000")
	http.ListenAndServe(":4000", r)
}
EOF

# Create placeholder handlers file
touch cmd/web/handlers.go

# SQLC config
touch sqlc.yaml

# Docker Compose setup
cat <<EOF >docker-compose.yml
version: '3.8'

services:
  db:
    image: postgres:15
    restart: always
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: ${PROJECT_NAME}
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
EOF

# Generate a README file
cat <<EOF >README.md
# $PROJECT_NAME

Golang (Chi) + React + Tailwind + Postgres project scaffold.
EOF

# Bootstrap Vite React app using Bun
bun create vite ui/static --template react-ts
cd ui/static
bun install
bun add -d tailwindcss postcss autoprefixer
bunx tailwindcss init -p

# Configure Tailwind
cat <<EOF >tailwind.config.ts
import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}"
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
export default config
EOF

# Update index.css
cat <<EOF >src/index.css
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

cd ../../

# Output final structure
echo "\nProject $PROJECT_NAME scaffolded successfully!"
echo "Directory structure:"
tree -L 2 . || find . -maxdepth 2 -print
