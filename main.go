package main

import (
	"fmt"
	"os"
	"os/exec"
)

func main() {
	if len(os.Args) < 3 || os.Args[1] != "init" {
		fmt.Println("Usage: go run github.com/Primestack-Solutions-LLC/go-chi-react-template@latest init <project-name>")
		return
	}

	project := os.Args[2]
	fmt.Println("Scaffolding project:", project)

	// You could embed or generate the full structure here
	cmd := exec.Command("bash", "-c", "./scaffold.sh "+project)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	cmd.Run()
}
