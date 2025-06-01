package main

import (
	"fmt"
	"os"

	"github.com/Primestack-Solutions-LLC/go-chi-react-template/scaffold"
)

func main() {
	if len(os.Args) < 3 || os.Args[1] != "init" {
		fmt.Println("Usage: go run github.com/Primestack-Solutions-LLC/go-chi-react-template@v0.1.0 init <project-name>")
		return
	}
	scaffold.Init(os.Args[2])
}
