package main

import (
	"fmt"
	"net/http"

	"github.com/CarlosAsrc/url-shortener/api/handlers"
)

func main() {
	port := ":8080"

	http.HandleFunc("/shorten", handlers.ShortenURLHandler)
	http.ListenAndServe(port, nil)
	fmt.Printf("Server listen in port %s", port)
}
