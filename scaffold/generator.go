package scaffold

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
)

func Init(project string) {
	fmt.Println("Scaffolding project:", project)

	dirs := []string{
		"cmd/web",
		"internal",
		"ui/html",
		"ui/static",
	}
	for _, dir := range dirs {
		path := filepath.Join(project, dir)
		if err := os.MkdirAll(path, 0755); err != nil {
			log.Fatalf("failed to create directory %s: %v", path, err)
		}
	}

	writeFile(filepath.Join(project, "go.mod"), fmt.Sprintf(`module github.com/yourusername/%s

go 1.21

require (
	github.com/go-chi/chi/v5 v5.0.9
	github.com/jackc/pgx/v5 v5.5.4
	github.com/pressly/goose/v3 v3.12.0
)
`, project))

	writeFile(filepath.Join(project, "cmd/web/main.go"), `package main

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
}`)

	touch(filepath.Join(project, "cmd/web/handlers.go"))
	touch(filepath.Join(project, "sqlc.yaml"))

	writeFile(filepath.Join(project, "docker-compose.yml"), fmt.Sprintf(`version: '3.8'

services:
  db:
    image: postgres:15
    restart: always
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: %s
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
`, project))

	writeFile(filepath.Join(project, "README.md"), fmt.Sprintf("# %s\n\nGolang (Chi) + React + Tailwind + Postgres project scaffold.\n", project))

	runFrontendSetup(filepath.Join(project, "ui/static"))
}

func writeFile(path, content string) {
	if err := os.WriteFile(path, []byte(content), 0644); err != nil {
		log.Fatalf("failed to write file %s: %v", path, err)
	}
}

func touch(path string) {
	file, err := os.Create(path)
	if err != nil {
		log.Fatalf("failed to create file %s: %v", path, err)
	}
	file.Close()
}

func runFrontendSetup(staticPath string) {
	fmt.Println("Setting up frontend with bun + Vite + Tailwind...")

	if err := runCmd(".", "bun", "create", "vite", staticPath, "--template", "react-ts"); err != nil {
		log.Fatal(err)
	}
	if err := runCmd(staticPath, "bun", "install"); err != nil {
		log.Fatal(err)
	}
	if err := runCmd(staticPath, "bun", "add", "-d", "tailwindcss", "postcss", "autoprefixer"); err != nil {
		log.Fatal(err)
	}
	if err := runCmd(staticPath, "bunx", "tailwindcss", "init", "-p"); err != nil {
		log.Fatal(err)
	}

	tailwindConfig := `import type { Config } from 'tailwindcss'

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
`
	writeFile(filepath.Join(staticPath, "tailwind.config.ts"), tailwindConfig)

	indexCSS := `@tailwind base;
@tailwind components;
@tailwind utilities;
`
	os.MkdirAll(filepath.Join(staticPath, "src"), 0755)
	writeFile(filepath.Join(staticPath, "src", "index.css"), indexCSS)
}

func runCmd(dir string, name string, args ...string) error {
	cmd := exec.Command(name, args...)
	cmd.Dir = dir
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	return cmd.Run()
}
