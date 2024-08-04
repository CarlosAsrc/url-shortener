package main

import (
	"fmt"
	"net/http"

	"github.com/CarlosAsrc/url-shortener/api/routes"
)

func main() {
	port := ":8080"

	router := routes.SetupRoutes()

	fmt.Printf("Server listening on port %s\n", port)

	if err := http.ListenAndServe(port, router); err != nil {
		fmt.Printf("Error starting server: %v\n", err)
	}
}
